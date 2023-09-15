module ContractErrors
  class ContractError < StandardError
    attr_accessor :contract
    attr_accessor :error_status
  
    def initialize( message, contract )
      super(message)
      @contract = contract
    end
    
    def message
      ## note: was contract.blank?    - assumes contract is a object
      return super   if contract.nil?
      "#{contract.class.name.demodulize} error: " + super + " (contract id: #{contract.contract_id})"
    end
  end

  class ContractRuntimeError < ContractError; end
  class ContractDefinitionError < ContractError; end
  
  class StaticCallError < StandardError; end  
  class TransactionError < StandardError; end
  class StateVariableTypeError < StandardError; end
  class VariableTypeError < StandardError; end
  class StateVariableMutabilityError < StandardError; end
  class ContractArgumentError < StandardError; end
  class CallingNonExistentContractError < TransactionError; end
  class UnknownEthscriptionError < StandardError; end
  class FatalNetworkError < StandardError; end
  class InvalidOverrideError < StandardError; end
  class FunctionAlreadyDefinedError < StandardError; end
end
