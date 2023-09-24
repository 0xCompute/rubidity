class ContractImplementation  < ContractBase
 
  attr_reader :contract_record
  
 
  extend Forwardable   ## pulls in def_delegators

  ## delegate :block, :tx, :esc, to: :current_transaction
  ## delegate :current_transaction, :contract_id, to: :contract_record
  def_delegators :contract_record,  :current_transaction,
                                    :contract_id 
  
  def_delegators :current_transaction, :block, :tx, :esc


  #####################
  ## quick hack - add contract registry
  ##                 for lookup by address and class
  def self.registry() @@registry ||= {}; end
  def self.register( obj )
    registry[ obj.address ] = [obj.class, obj] ## fix: in the future store state NOT object ref!!!
    obj
  end


  ##########################################
  ## "read-only" access for address
  def address()   @__address__; end
  
  ## -- use a "number used once" counter for address generation for now
  ##      note: will count up for now for ALL contracts (uses @@)
  ##      fix: use a better formula later!!!!
  def self.nonce() @@nonce ||= 0; end
  def self.nonce=( value ) @@nonce = value; end



  def initialize( contract_record )
    @contract_record = contract_record

    unless self.class.abi.generated?   
       ## only generate once? double check
       self.class.abi.generate_functions
    end

    ## rename to generate_storage or such - why? why not?
    generate_state

    ## for now use
    nonce = self.class.nonce += 1  
    @__address__ = '0x' + 'cc'*16 + ('%08d' % nonce ) ## count
    puts "   new #{self.class.name} contract @ address #{@__address__}"
  
    self.class.register( self )
  end

  

  def generate_state
    puts "==> generate_state (ivars) #{self.class.name}"

    self.class.state_variable_definitions.each do |name, definition|
      type      = definition[:type]
      # constant  = definition[:constant] 
      # immutable = definition[:immutable]
     
      puts "[debug] add ivar @#{name} - #{type}"
      ### note. create  TypedVariable instance here (via Type#create)
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

  

  def msg
    @msg ||= ContractTransactionGlobals::Message.new
  end
  
  def log(event_name, args = {})
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
      caller_location = caller_locations.detect { |l| l.path.include?('/app/models/contracts') }
      file = caller_location.path.gsub(%r{.*app/models/contracts/}, '')
      line = caller_location.lineno
      
      error_message = "#{message}. (#{file}:#{line})"
      ## todo/fix: change to (built-in) ???Error, ....
      ##  check for error to raise for assertion fail??
      raise error_message
    end
  end
  
  
  
  
  
  
  def keccak256(input)
    str = TypedVariable.create(:string, input)
    
    "0x" + Digest::Keccak256.new.hexdigest(str.value)
  end
  
  protected


##
##  fix: move to typed!!!
##  fix:  change typed/types.rb to type.rb !!!  
  def string(i)
    if i.is_a?(TypedVariable) && i.type.is_value_type?
      return TypedVariable.create(:string, i.value.to_s)
    else
      raise "Input must be typed"
    end
  end
  
=begin  
  def address(i)
    return TypedVariable.create(:address) if i == 0

    if i.is_a?(TypedVariable) && i.type == Type.create(:addressOrDumbContract)
      return TypedVariable.create(:address, i.value)
    end
    
    raise "Not implemented"
  end
  
  def addressOrDumbContract(i)
    return TypedVariable.create(:addressOrDumbContract) if i == 0
    raise "Not implemented"
  end
  
  def DumbContract(contract_id)
    current_transaction.create_execution_context_for_call(contract_id, self.contract_id)
  end
  
  def dumbContractId(i)
    return contract_id if i == self
    raise "Not implemented"
  end
=end


end
