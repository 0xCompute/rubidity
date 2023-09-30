class Contract  < ContractBase
 
  

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
    addr_key = address.is_a?( TypedAddress ) ? address.serialize : address
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
      # constant  = definition[:constant] 
      # immutable = definition[:immutable]
     
      puts "[debug] add ivar @#{name} - #{type}"
      ### note. create Typed instance here (via Type#create)
      ##    fix-fix-fix  use type.new_zero !!!!
      instance_variable_set("@#{name}", type.create ) 
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
      ivar = instance_variable_get("@#{name}")
      ivar.deserialize( value )
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
  def assert(condition, message)
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

    str = TypedString.new( input )

    '0x' + Digest::KeccakLite.hexdigest( str.serialize, 256  )
  end
 
end    # class Contract
