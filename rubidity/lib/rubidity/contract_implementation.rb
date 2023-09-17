class ContractImplementation  < ContractBase
 
  attr_reader :contract_record
  
 
  extend Forwardable   ## pulls in def_delegators

  ## delegate :block, :tx, :esc, to: :current_transaction
  ## delegate :current_transaction, :contract_id, to: :contract_record
  def_delegators :contract_record,  :current_transaction,
                                    :contract_id 
  
  def_delegators :current_transaction, :block, :tx, :esc

  def initialize(contract_record)
    @state_proxy = StateProxy.new(
      ## was: 
      ##  contract_record.type.constantize.state_variable_definitions
       self.class.state_variable_definitions 
    )
    
    @contract_record = contract_record
  end
  
  
  
  def s
    @state_proxy
  end
  alias_method :state_proxy, :s    ## keep state_proxy alias - why? why not?
  

###
#  add convenience serialize/deserialize(load) helpers - why? why not?
   def serialize() @state_proxy.serialize; end
   alias_method :dump, :serialize  ### use dump as alias - why? why not?
   def deserialize(state_data)  @state_proxy.deserialize( state_data ); end
   alias_method :load, :deserialize


  def msg
    @msg ||= ContractTransactionGlobals::Message.new
  end
  
  def emit(event_name, args = {})
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
  

  
  
  def require(condition, message)
    unless condition
      caller_location = caller_locations.detect { |l| l.path.include?('/app/models/contracts') }
      file = caller_location.path.gsub(%r{.*app/models/contracts/}, '')
      line = caller_location.lineno
      
      error_message = "#{message}. (#{file}:#{line})"
      ## todo/fix: change to (built-in) ???Error, ....
      raise ContractError.new(error_message, self)
    end
  end
  
  
  
  
  
  
  def keccak256(input)
    str = TypedVariable.create(:string, input)
    
    "0x" + Digest::Keccak256.new.hexdigest(str.value)
  end
  
  protected

  def string(i)
    if i.is_a?(TypedVariable) && i.type.is_value_type?
      return TypedVariable.create(:string, i.value.to_s)
    else
      raise "Input must be typed"
    end
  end
  
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
end
