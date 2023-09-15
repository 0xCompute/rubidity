

class StateVariable
  
  attr_accessor :typed_variable, 
                :name, 
                :visibility,    # internal|private|public
                :immutable,    ## fix: change to immutable? - why? why not?
                :constant      ## fix: change to constant? - why? why not?
  
  def immutable?() @immutable; end
  def constant?()  @constant; end

  def initialize(name, typed_variable, args)
    visibility = :internal
    
    args.each do |arg|
      case arg
      when :public, :private
        visibility = arg
      end
    end
    
    @visibility = visibility
    @immutable = args.include?(:immutable)
    @constant = args.include?(:constant)
    @name = name
    @typed_variable = typed_variable
  end
  
  def self.create(name, type, args)
    var = TypedVariable.create(type)
    new(name, var, args)
  end
  

  def type() @typed_variable.type; end



  def create_public_getter_function( contract_class )
    return unless @visibility == :public
  
    new_var = self
    
    if type.mapping?
      create_mapping_getter_function(contract_class)
    elsif type.array?
      contract_class.class_eval do
        self.function(new_var.name, {index: :uint256},
                       :public, :view, returns: new_var.type.sub_type.name) do
          puts "[debug] call public (state) array getter for #{new_var.name} : #{new_var.type} with index #{send(:index)}"
          value = s.send(new_var.name)
          value[send(:index)]
          # new_var.typed_variable[ send(:index) ]
        end
      end
    else
      contract_class.class_eval do
        self.function(new_var.name, {}, 
                       :public, :view, returns: new_var.type.name) do
          ## s.send(new_var.name)
          ## return typed_variable directly (no s/state proxy)
          puts "[debug] call public (state) getter for #{new_var.name} : #{new_var.type}"
          ## new_var.typed_variable
          s.send(new_var.name)
        end
      end
    end
  end
  

  def create_mapping_getter_function(contract_class)
    arguments = {}
    current_type = type
    index = 0
    new_var = self
    
    while current_type.name == :mapping
      arguments["arg#{index}".to_sym] = current_type.key_type.name
      current_type = current_type.value_type
      index += 1
    end
    
    puts "[debug] auto-generate public mapping getter - #{new_var.name} : #{new_var.type}:"
    puts "    arguments:"
    pp   arguments
    puts "    index: #{index}"
# {:arg0=>:addressOrDumbContract}
#    index: 1

    contract_class.class_eval do
      self.function(new_var.name, arguments, :public, :view, returns: current_type.name) do

        puts "[debug] call public (state) mapping getter for #{new_var.name} : #{new_var.type}"
        value = s.send(new_var.name)
        (0...index).each do |i|
          value = value[send("arg#{i}".to_sym)]
        end
        value
      end
    end
  end
  
=begin
  def create_array_getter_function(contract_class)
    current_type = type
    new_var = self
    contract_class.class_eval do
      self.function(new_var.name, {index: :uint256}, :public, :view, returns: current_type.sub_type.name) do
        value = s.send(new_var.name)
        value[send(:index)]
      end
    end
  end
=end  

=begin  
  def serialize
    typed_variable.serialize
  end
  
  def deserialize(value)
    typed_variable.deserialize(value)
  end
=end


#  def method_missing(name, *args, &block)
#    if typed_variable.respond_to?(name)
#      puts "[debug] StateVariabe#method_missing( #{name}, #{args.inspect})"
#      typed_variable.send(name, *args, &block)
#    else
#      super
#    end
#  end
#
#  def respond_to_missing?(name, include_private = false)
#    typed_variable.respond_to?(name, include_private) || super
#  end
  

  def ==(other)
    other.is_a?(StateVariable) &&
      typed_variable == other.typed_variable &&
      name == other.name &&
      visibility == other.visibility &&
      immutable == other.immutable &&
      constant == other.constant
  end
   
  def hash
    [typed_variable, name, visibility, immutable, constant].hash
  end
  def eql?(other) hash == other.hash; end
end
