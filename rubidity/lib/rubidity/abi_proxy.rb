

class AbiProxy
  
  ## todo: make data private!!!
  ##  make  read access available via #each !!!


  attr_accessor :data, :contract_class
  
  def initialize(contract_class)
    @contract_class = contract_class
    @data = HashWithIndifferentAccess.new     ## was {}.with.with_indifferent_access
     

    parents = contract_class.linearized_parents 
    if parents.empty?
      ## do nothing
    else 
      _merge_events( parents )  
      _merge_state_variables( parents)
      _merge_abis( parents )  
    end
  end
  

def generate_functions
  puts "==> generate (typed) functions for #{@contract_class.name}"
  
  parents = @contract_class.linearized_parents 
  ## revesee order - why? why not?
  parents.each do |parent|
    _generate_functions( parent )
  end
  _generate_functions( @contract_class )
end


def _generate_functions( contract_class )
  ## start with simple (no parents) for now

   sigs = contract_class.sigs
   puts "#{sigs.size} function signatures in #{contract_class.name}:"
   pp sigs
   sigs.each do |name, definition|
      ## must? find matching method in class
      exists = contract_class.instance_methods.include?( name )
      if !exists
        error_message = "[ERRRO] no method #{name} found for sig in class #{contract_class.name}"
        puts error_message
        raise NameError, error_message
      end
      puts "  bingo! #{name}"
  
      ##
      ##  use :name_raw instead of :name_unsafe - why? why not?

      ## rewire
      ##   alias_method :name_unsafe, :name
      ##   alias_method :name,        :name_typed
      inputs = definition[:inputs] 
      contract_class.class_eval do
         define_method :"#{name}_typed" do |*args_unsafe,**kwargs_unsafe|
            puts "==> calling #{name}_typed"
  
            params = method( "#{name}_unsafe" ).parameters
            puts "params:"
            pp params
            ## e.g.
            ## [[:keyreq, :name], 
            ##  [:keyreq, :symbol], 
            ##  [:keyreq, :decimals], 
            ##  [:keyreq, :totalSupply]]
            ## get keys
            keys = params.map { |param| param[1] }
            puts "keys:"
            pp keys

            
            kwargs =  if !args_unsafe.empty? 
              values = inputs.zip( args_unsafe ).map do |type, value|
                ## todo/check:  change create to cast/try_cast or such - why? why not?
                ##                might already be proper type? no?
                 TypedVariable.create(type, value)
              end
              puts "args:"
              pp values

              keys.zip( values ).map do |key,value|
                                                 [key,value]
              end.to_h
            elsif !kwargs_unsafe.empty?
               types = keys.zip( inputs ).map do |key,type|
                                                 [key,type]
               end.to_h
               puts "types:"
               pp types
               kwargs_unsafe.map do |key,value|
                    type = types[key]
                    raise ArgumentError, "unknown kwarg #{key}; sorry"   if type.nil?
                    [key, TypedVariable.create( type, value)]
               end.to_h
            else
              ## assume no args - e.g. construct - double check for empty input spec/def!!!
              if inputs.empty?
                 {}   
              else
                raise ArgumentError, "Array (args) or Hash (kwargs) required for func call; sorry"
              end
            end

            puts "kwargs:"
            pp kwargs

            ret = send( "#{name}_unsafe", **kwargs )
            ret
         end 
         alias_method :"#{name}_unsafe", :"#{name}"
         alias_method :"#{name}",        :"#{name}_typed"
      end
   end
end

  ### todo/check -- where used? check for parent_contracts
  # def parent_contracts
  #  contract_class.parent_contracts
  # end
  
  
  def _merge_events( parents )
    parent_events = parents.map(&:events).reverse
    contract_class.events = parent_events.reduce( {} ) { |mem,h| mem.merge(h) }
                                         .merge(contract_class.events)
  end
  
  def _merge_state_variables( parents )
    puts "[debug] AbiProxy#merge_parent_state_variables - #{contract_class}"
    parent_state_variables = parents.map(&:state_variable_definitions).reverse
    vars = parent_state_variables.reduce( {} ) { |mem,h| mem.merge(h) }
                                 .merge( contract_class.state_variable_definitions)
    puts "[debug]   merged state_variables:"
    pp vars
    contract_class.state_variable_definitions = vars    
  end
  

  def _merge_abis( parents )
    parents.each do |parent|
      parent.abi.data.each do |name, func|
        prefixed_name = "__#{parent.name.demodulize}__#{name}"
        puts "[debug] adding function w/ prefixed_name - #{prefixed_name}"
        define_function_method(prefixed_name, func, contract_class)
      end
  
      contract_class.class_eval do
        define_method(parent.name.demodulize) do |*args, **kwargs|
          send("__#{parent.name.demodulize}__constructor", *args, **kwargs)
        end
        
        ##
        # todo/check - what is this for???
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
    
    closest_parent = parents.first
    
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
    ## gets used for select - what else?
    puts "WARN!! AbiProxy#method_missing name: #{name}, args: #{args.inspect} - do NOT use; get removed SOON!"

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
