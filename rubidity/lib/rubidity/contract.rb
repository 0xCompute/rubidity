
class Contract 


  class << self
    attr_accessor :state_variable_definitions, 
                  :parent_contracts, 
                  :events, 
                  :is_abstract_contract
  end

  
  ##################
  # parent contracts 
  #   keep abstract - why? why not? 
  def self.abstract
    @is_abstract_contract = true
  end
  

  def self.linearize_contracts( contract )
   ## for now 
    ##    include all classes before Contract
    ##    cache result - why? why not?

    ##
    ## todo/fix: check if include? Contract
    ##                    if not raise error - CANNOT linearize (no contract base found)
    classes = []
    contract.ancestors.each do |ancestor|
        break if ancestor == Contract 
        if ancestor.instance_of?( Class )
            classes << ancestor 
        else  ### assume Module
            puts "[debug] skipping module - #{ancestor.name} : #{ancestor.class.name}"
        end
    end    
    classes
  end

  def self.linearized_parents
    ## note: exclude self (that is, cut-off first class)
    linearize_contracts( self )[1..-1]
  end

  class << self
     ## note: for now the same (might change with support for module?)
     alias_method :parent_contracts, :linearized_parents 
  end



  ########
  # state variables

  def self.state_variable_definitions
    @state_variable_definitions ||= {}
  end


  def self.define_state_variable(type, args)
    ## note: REMOVE last item from array (use Array#pop)
    ##  make sure name is ALWAYS a symbol!!!
    name = args.pop.to_sym
    
    if state_variable_definitions[name]
      raise "No shadowing: #{name} is already defined."
    end

    ## check for visibility  - internal/private/public
    ##  note: make :public default and :internal only if name starting with underscore (_) - why? why not?
    visibility = name.start_with?( '_' ) ? :internal  : :public    
 
 #  note: for now NO support for immutable and constant!!!!!   
 #   immutable  = false
 #   constant   = false

    ##  todo/check - force strict check for double (public/private etc.) use - why? why not?
    args.each do |arg|
      case arg
      when :public, :private, :internal then  visibility = arg
 #     when :immutable                   then  immutable = true
 #     when :constant                    then  constant = true
      else
         raise ArgumentError, "unknown type qualifier >#{arg}<; sorry for typedef #{type} in #{args.inspect}" 
      end
    end
    
    state_variable_definitions[name] = { type: type, 
                                         visibility: visibility }
                                       #  immutable: immutable,
                                       #  constant: constant 
    
  
    ## check - visibility 
    if visibility == :public
       contract_class = self
       Generator.getter_function( contract_class, name, type  )
    end
    
    type
  end


  def self.storage( **kwargs )
    ## note: assume keys are names and values are types for storage
    ## note:  allow multiple calls of storage!!!
    
    kwargs.each do |name, type|
       type = typeof( type )  
             
       ## add support for more args - e.g. visibility or such - why? why not?
       args = [name] 
       define_state_variable( type, args )                       
    end
  end 
 


  ####
  #  functions / abis

  def self.abi
    @abi ||= AbiProxy.new(self)
  end

  def self.public_abi() abi.public_api; end
  def public_abi() self.class.public_abi; end



  
  def self.struct( class_name, **attributes )
    typedclass = Types::Struct.new( class_name, scope: self, **attributes )
    typedclass  
  end

  def self.enum( class_name, *args )
    typedclass = Types::Enum.new( class_name, *args, scope: self  )
    typedclass
  end

  def self.event( class_name, **attributes )
    typedclass = Types::Event.new( class_name, scope: self, **attributes )
    typedclass  
  end


   include CryptoHelper     # e.g. keccak256
   include RuntimeHelper    # e.g. msg, tx, block, log, etc.


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
  args = args.map { |value| typeof( value ) }

  ###
  ## note: turn returns into an array - empty if nil, etc.
  ##        always wrap into array
  returns =  if returns.nil?
                  []
             elsif returns.is_a?( ::Array ) 
                  returns 
             else  ## assume single type
                  [returns]  
             end  

  returns = returns.map { |value| typeof( value ) }


  @sigs_unnamed ||= [] 
  @sigs_unnamed.push( { inputs:  args,
                        outputs: returns,
                        options: options } )
end



##
#  todo/fix:
#    always auto-add (default) constructor 
#      CAN get redefined
#       if not redefined
#         is empty BUT will call super construct (if has parent)!!!!

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
