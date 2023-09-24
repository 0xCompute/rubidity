  class FunctionProxy
    
    attr_accessor :args, :state_mutability, :visibility,
      :returns, :type, :implementation, :override_modifiers,
      :from_parent
    
    def initialize(**opts)
      @args = opts[:args] || {}
      @state_mutability = opts[:state_mutability]
      @visibility = opts[:visibility]
      @returns = opts[:returns]
      @type = opts[:type]
      @override_modifiers = Array.wrap(opts[:override_modifiers]).uniq.map{|i| i.to_sym}
      @implementation = opts[:implementation]
      @from_parent = !!opts[:from_parent]
    end
    
    def arg_names
      args.keys
    end
    
    def virtual?
      override_modifiers.include?(:virtual)
    end
    
    def override?
      override_modifiers.include?(:override)
    end
    
    def constructor?
      type == :constructor
    end
    
    def read_only?
      [:view, :pure].include?(state_mutability)
    end
    
    def publicly_callable?
      [:public, :external].include?(visibility) || constructor?
    end
    
    def func_location
      implementation.to_s.gsub(%r(.*/app/models/contracts/), '').chop
    end
    


    def validate_arg_names(other_args)
      if other_args.is_a?(Hash)
        missing_args = arg_names - other_args.keys
        extra_args = other_args.keys - arg_names
      elsif other_args.is_a?(Array)
        missing_args = arg_names.size > other_args.size ? arg_names.last(arg_names.size - other_args.size) : []
        extra_args = other_args.size > arg_names.size ? other_args.last(other_args.size - arg_names.size) : []
      else
        raise ArgumentError, "Expected Hash or Array, got #{other_args.class}"
      end
      
      errors = [].tap do |error_messages|
        error_messages << "Missing arguments for: #{missing_args.join(', ')}." if missing_args.any?
        error_messages << "Unexpected arguments provided for: #{extra_args.join(', ')}." if extra_args.any?
      end
      
      if errors.any?
        raise ArgumentError, errors.join(' ')
      end
    end
    
    
    def convert_args_to_typed_variables_struct(other_args, other_kwargs)
      ## note: was other_kwargs.present?  assume other_kwargs is a hash   
      if other_kwargs && !other_kwargs.empty?
        # fix: was  other_kwargs.deep_symbolize_keys
        other_args = other_kwargs   
      end
      
      if other_args.first.is_a?(Hash) && other_args.length == 1
        # fix: was  other_args.first.deep_symbolize_keys
        other_args = other_args.first
      end
      
      validate_arg_names(other_args)
      
      ## note: was args.blank?  assumes args is a hash {} or nil
      return Struct.new(nil) if args.nil? || args.empty? 
      
      as_typed = if other_args.is_a?(Array)
        args.keys.zip(other_args).map do |key, value|
          type = args[key]
          [key, TypedVariable.create(type, value)]
        end.to_h
      else
        other_args.each.with_object({}) do |(key, value), acc|
          type = args[key]
          acc[key.to_sym] = TypedVariable.create(type, value)
        end
      end
      
      struct_class = Struct.new(*as_typed.keys)
      struct_class.new(*as_typed.values)
    end
    
    def convert_return_to_typed_variable(ret_val)
      return ret_val if ret_val.nil? || returns.nil?
      TypedVariable.create(returns, ret_val)
    end
    
    def self.create(name, args, *options, returns: nil, &block)
      options_hash = {
        state_mutability: :non_payable,
        visibility: :internal,
        override_modifiers: []
      }
    
      options.each do |option|
        case option
        when :payable, :nonpayable, :view, :pure
          options_hash[:state_mutability] = option
        when :public, :external, :private
          options_hash[:visibility] = option
        when :override, :virtual
          options_hash[:override_modifiers] << option
        end
      end
      
      new(
        args: args,
        state_mutability: options_hash[:state_mutability],
        override_modifiers: options_hash[:override_modifiers],
        visibility: name == :constructor ? nil : options_hash[:visibility],
        returns: returns,
        type: name == :constructor ? :constructor : :function,
        implementation: block
      )
    end
  end  #  class FunctionProxy
 