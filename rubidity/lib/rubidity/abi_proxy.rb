



class AbiProxy
  
  attr_accessor :data, :contract_class
  
  def initialize(contract_class)
    @contract_class = contract_class
    @data = HashWithIndifferentAccess.new     ## was {}.with.with_indifferent_access
    
    merge_parent_state_variables
    merge_parent_abis
    merge_parent_events
  end
  
  def parent_contracts
    contract_class.parent_contracts
  end
  
  
  def merge_parent_events
    parent_events = contract_class.linearized_parents.map(&:events).reverse
    contract_class.events = parent_events.reduce( {} ) { |mem,h| mem.merge(h) }
                                         .merge(contract_class.events)
  end
  
  def merge_parent_state_variables
    puts "[debug] AbiProxy#merge_parent_state_variables - #{contract_class}"
    parent_state_variables = contract_class.linearized_parents.map(&:state_variable_definitions).reverse
    vars = parent_state_variables.reduce( {} ) { |mem,h| mem.merge(h) }
                                 .merge( contract_class.state_variable_definitions)
    puts "[debug]   merged state_variables:"
    pp vars
    contract_class.state_variable_definitions = vars    
  end
  
  
  def merge_parent_abis
    ## note was:  unless linearized_parents.present? 
    return if contract_class.linearized_parents.nil? || contract_class.linearized_parents.empty?
    
    contract_class.linearized_parents.each do |parent|
      parent.abi.data.each do |name, func|
        prefixed_name = "__#{parent.name.demodulize}__#{name}"
        define_function_method(prefixed_name, func, contract_class)
      end
  
      contract_class.class_eval do
        define_method(parent.name.demodulize) do |*args, **kwargs|
          send("__#{parent.name.demodulize}__constructor", *args, **kwargs)
        end
        
        define_method("_" + parent.name.demodulize) do
          contract_instance = self
          Object.new.tap do |proxy|
            parent.abi.data.each do |name, _|
              proxy.define_singleton_method(name) do |*args, **kwargs|
                contract_instance.send("__#{parent.name.demodulize}__#{name}", *args, **kwargs)
              end
            end
          end
        end
      end
    end
    
    closest_parent = contract_class.linearized_parents.first
    
    closest_parent.abi.data.each do |name, func|
      add_function(name, func, from_parent: true)
    end
  end
  
  def add_function(name, new_function, from_parent: false)
    existing_function = @data[name]
    
    new_function.from_parent = from_parent
    
    if existing_function
      if existing_function.from_parent
        unless (existing_function.virtual? && new_function.override?) ||
               (existing_function.constructor? && new_function.constructor?)
          raise InvalidOverrideError, "Cannot override non-constructor parent function #{name} without proper modifiers!"
        end
      else
        raise FunctionAlreadyDefinedError, "Function #{name} already defined in child!"
      end
    elsif new_function.override?
      raise InvalidOverrideError, "Function #{name} declared with override but does not override any parent function!"
    end
  
    @data[name] = new_function
    define_function_method(name, new_function, contract_class)
  end
  
  def create_and_add_function(name, args, *options, returns: nil, &block)
    new_function = FunctionProxy.create(name, args, *options, returns: returns, &block)
    add_function(name, new_function)
  end
  
  private
  
  def define_function_method(method_name, func_proxy, target_class)
    target_class.class_eval do
      define_method(method_name) do |*args, **kwargs|
        begin
          cooked_args = func_proxy.convert_args_to_typed_variables_struct(args, kwargs)
          ret_val = FunctionContext.define_and_call_function_method(
            self, cooked_args, &func_proxy.implementation
          )
          func_proxy.convert_return_to_typed_variable(ret_val)
        rescue Contract::ContractArgumentError, Contract::VariableTypeError => e
          raise ContractError.new("Wrong args in #{method_name} (#{func_proxy.func_location}): #{e.message}", self)
        end
      end
    end
  end
  
  def method_missing(name, *args, &block)
    if data.respond_to?(name)
      data.send(name, *args, &block)
    else
      binding.pry
      super
    end
  end
  
  def respond_to_missing?(name, include_private = false)
    data.respond_to?(name, include_private) || super
  end  
end  # class  AbiProxy
