class Contract  < ContractBase
 
  
  def self.struct( class_name, **attributes )
    typedclass = Types::Struct.new( class_name, scope: self, **attributes )
    typedclass  
  end

  def self.enum( class_name, *args )
    typedclass = Types::Enum.new( class_name, *args, scope: self  )
    typedclass
  end



  #####################
  ## quick hack - add contract registry
  ##                 for lookup by address and class
  def self.registry() @@registry ||= {}; end
  def self.register( obj )
    registry[ obj.__address__ ] = [obj.class, obj]   ## fix: in the future store state NOT object ref!!!
    obj
  end

  def self.at( address )
    klass = self
    puts "==> calling #{klass.name}.at( #{address.pretty_print_inspect })"
  
    ## note: support plain strings and typed address for now
    ##   use serialize to get "raw" string value of address
    ## fix - fix - fix - change back to address?
    addr_key = address.is_a?( Types::Address ) ? address.serialize : address
    rec = registry[ addr_key ] 
    
    if rec
      obj_klass = rec[0]
      ## raise type error if not matching class type
      if obj_klass == klass || obj_klass.parent_contracts.include?( klass )
        obj = rec[1]
        obj
      else
        raise TypeError, "#{obj_klass.name} contract found; is NOT a type of #{klass.name}; sorry"
      end
    else
        nil   # nothing found
    end
  end



  ##########################################
  ## "read-only" access for address
  ##   note: MUST use  __address__ - why? why not?
  ##    otherwise will conflicts with global conversion function
  ##        when used in contract code e.g. address(0) or such
 
  def __address__()   @__address__; end

  ## -- use a "number used once" counter for address generation for now
  ##      note: will count up for now for ALL contracts (uses @@)
  ##      fix: use a better formula later!!!!
  def self.nonce() @@nonce ||= 0; end
  def self.nonce=( value ) @@nonce = value; end

  def __autoregister__
    ## for now use
    nonce =  self.class.nonce += 1  
    @__address__ = '0x' + 'cc'*16 + ('%08d' % nonce )   ## count
    puts "   new #{self.class.name} contract @ address #{@__address__}"
    
    self.class.register( self )  
  end


  
  def initialize
    unless self.class.abi.generated?   
       ## only generate once? double check
       self.class.abi.generate_functions
    end

    ## rename to generate_storage or such - why? why not?
    generate_state
  end


  def generate_state
    puts "==> generate_state (ivars) #{self.class.name}"

    self.class.state_variable_definitions.each do |name, definition|
      type      = definition[:type]
     
      puts "[debug] add ivar @#{name} - #{type}"
      ### note. create Typed instance here (via Type#new_zero)
      instance_variable_set("@#{name}", type.new_zero ) 
    end
  end 

  
  def serialize
    self.class.state_variable_definitions.keys.reduce({}) do |h, name|
      ivar = instance_variable_get("@#{name}")
      ## todo/fix: make sure ivar is_a? Typed!!!!
      puts "WARN!! no ivar @#{name} found!!! - #{instance_variables}"   if ivar.nil?
      h[name] = ivar.serialize
      h
    end
  end
  alias_method :dump, :serialize  ### use dump as alias - why? why not?
 
  
  def deserialize(state_data)  
    state_data.each do |name, value|
      ## todo/fix: make sure ivar is_a? Typed!!!!
      ## lookup type info
      definition = self.class.state_variable_definitions[ name ]
      type  = definition[:type]
      typed = type.new( value )    ## note: always (re)create new typed classes (from literals)
      instance_variable_set( "@#{name}", typed )
    end
  end
  alias_method :load, :deserialize


  ## note: for now this is just the solidity alias/used name
  ##  for ruby's self  - anything missing - why? why not?
  def this()  self; end


  
  def current_transaction()  Runtime.current_transaction; end
  def msg()                  Runtime.msg; end
  def block()                Runtime.block; end

  def log( event_name, args = {} )
    event_name = event_name.to_sym  ## note: make sure event_name is ALWAYS as symbol
    unless self.class.events.key?( event_name)
      raise NameError, "Event #{event_name} is not defined in this contract."
    end

    expected_args = self.class.events[event_name]
    missing_args = expected_args.keys - args.keys
    extra_args   = args.keys - expected_args.keys

    if missing_args.any? || extra_args.any?
      error_messages = []
      error_messages << "Missing arguments for #{event_name} event: #{missing_args.join(', ')}." if missing_args.any?
      error_messages << "Unexpected arguments provided for #{event_name} event: #{extra_args.join(', ')}." if extra_args.any?
      raise ArgumentError, error_messages.join(' ')
    end

  
    current_transaction.log_event({ event: event_name, data: args })
  end
  

  ## note: change from require to assert
  ##         to avoid confusion with ruby require - why? why not?
  def assert(condition, message='no message')
    unless condition
      # caller_location = caller_locations.detect { |l| l.path.include?('/app/models/contracts') }
      # file = caller_location.path.gsub(%r{.*app/models/contracts/}, '')
      # line = caller_location.lineno
      
      error_message = "#{message}"     ##. (#{file}:#{line})"
      ## todo/fix: change to (built-in) ???Error, ....
      ##  check for error to raise for assertion fail??
      raise error_message
    end
  end
   

  
###
#  Digest::KeccakLite.new( 256 ).hexdigest( 'abc' )   # or
#  Digest::KeccakLite.hexdigest( 'abc', 256 )
#  #=> "4e03657aea45a94fc7d47ba826c8d667c0d1e6e33a64a036ec44f58fa12d6c45"  

  def keccak256( input )
  ## todo/fix: check if input is binary string 
  ##    (convert to bytes - why? why not?)
  ##    should really always use hex_to_bin !!! 
  ##    and convert the result in the end only - why? why not??

    str = Types::String.new( input )

    '0x' + Digest::KeccakLite.hexdigest( str.serialize, 256  )
  end
 




####
#   note:  sig machinery with method_added MUST come last here

def self.sigs
  @sigs ||= {}
end

def self.sigs_unnamed   ## unnamed sigs stack 
  @sigs_unnamed ||= []
end 

## ignore this methods; 
##   do NOT (auto-)generate wrapper method popping (unnamed) sig from stack!!!   
def self.sigs_exclude
  ## note: always exclude  globals
  ##        get or can get changed via runtime modules (simulacrm) and such!!!
  ##  e.g. msg.sender, block.timestamp, tx.origin, etc. 
  @sigs_exclude ||= [:block, :tx, :msg]
end



def self.sig( args=[], *options, returns: nil )

  puts "[debug] add sig args: #{args.inspect}, options: #{options.inspect}, returns: #{returns.inspect}"
  ## use inputs for args) and outputs for returns  - why? why not?

  ## check if include explicit visibility in options
  if  options.include?( :public ) ||
      options.include?( :private ) ||
      options.include?( :internal )
      # do nothing / pass-along as is
  else
      # auto-add default up-front - :public or :internal if name starting with underscore (_)
      visibility =  name.start_with?( '_' )  ? :internal : :public
      options.unshift( visibility )
  end

  ####  
  #  auto-convert args (inputs), returns (outputs) to type (defs)
  args = args.map do |value|  
       typeof( value )
  end

  returns = typeof( returns )   if returns

  @sigs_unnamed ||= [] 
  @sigs_unnamed.push( { inputs:  args,
                        outputs: returns,
                        options: options } )
end


###
#  sig []        
#  def constructor
#  end  
## auto-add default constructor in Contract (base) here
## add sig too - why? why not?
def constructor
  puts "   calling default (fallback dummy) contract constructor in #{self.class.name}"
end



def self.method_added( name )

  if sigs_exclude.include?( name )
     puts "--- skip method added hook >#{name}< - found in sigs exclude"
     return ## do nothing; 
  else
     puts "==> method added hook >#{name}<... processing..."
  end

  ## pp name
  ## pp name.class.name

  name = name.to_sym  ## note: make sure name is ALWAYS a symbol

  ## note:  method lookup via method needs an object / INSTANCE
  ##             NOT working with class only!!!!
 
  # m = method( name )
  # pp m.name
  # pp m.parameters
  # pp m

  raise "no unnamed sig(nature) on stack for method >#{name}< in class >#{self.name}<; sorry"   if sigs_unnamed.size == 0
  sig_unnamed = sigs_unnamed.pop  
  puts "    using sig_unnamed: #{sig_unnamed.inspect}"
  

  @sigs ||= {}
  raise "duplicate method sig(nature) for method >#{name}< in class >#{self.name}<; sorry"   if @sigs.has_key?( name )
  @sigs[ name ] = sig_unnamed

  puts "    generate typed_function >#{name}<"
  Generator.typed_function( self, name, 
                                   inputs: sig_unnamed[ :inputs ] )  

  puts "<== method added hook >#{name}< done."                               
end
end    # class Contract
