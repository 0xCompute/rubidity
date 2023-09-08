
require 'forwardable'  ## def_delegate


module Typed

def self.var( type, value = nil, **kwargs )
     Var.create( type, value, **kwargs )
end



class Var
  
  attr_accessor :type, :value

  def initialize( type, value = nil)
    @type        = type
    self.value   = value || type.default_value
  end
 
  
  def self.create( type, value = nil, **kwargs)
    type = Type.create( type, **kwargs )
    
    if type.is_a?( Mapping )
      MappingVar.new( type, value )
    elsif type.is_a?( Array )
      ArrayVar.new(type, value )
    else
      new( type, value )
    end
  end


  def as_json(args = {}) 
     serialize
  end
  def serialize() @value; end

  def to_s
    if @value.is_a?(String) || @value.is_a?(Integer)
      @value.to_s
    else
      raise "No string conversion"
    end
  end
  
  def deserialize( serialized_value )
    self.value = serialized_value
  end

 
  def value=(new_value)
    @value = if new_value.is_a?(Var)
               if new_value.type != @type
                 if @type.is_a?( AddressOrDumbContract) &&
                     (new_value.type.is_a?( Address) ||
                      new_value.type.is_a?( DumbContract))           
                   new_value.value
                 else
                  ## fix: raise typeerror - if exists!!!
                   raise ArgumentError, "invalid #{type}: #{new_value.value}"
                 end
               end
               new_value.value
            else
               @type.check_and_normalize_literal(new_value)
            end
  end
end # class Var




class ArrayVar < Var  
 
  def serialize
    @value.data.map {|item| item.serialize }
  end
  

  class Proxy
    attr_accessor :subtype, :data
  
    def initialize(initial_value=[], subtype:)
      unless subtype.is_value_type?
        raise ArgumentError, "Only value types for array elements supported; sorry" 
      end
      
      @subtype = subtype
      @data    = initial_value
    end
  
    def []( index )
      ## fix: use index out of bounds error - why? why not?
      raise ArgumentError, "Index out of bounds"   if index >= @data.size

      value = @data[index]
      value || Var.create( subtype )
    end
  
    def []=(index, value) 
      raise ArgumentError, "Sparse arrays are not supported"   if index > @data.size

      val_var = Var.create( subtype, value )
      @data[ index ] = val_var
    end
    
    def push(value)
      next_index = @data.size
      
      self.[]=(next_index, value)
    end
  end  # class Proxy
end # class ArrayVar




class MappingVar < Var
  extend Forwardable   ## pulls in def_delegator

  
  def serialize
    @value.data.reduce({}) do |h, (k, v)|
      h[k.serialize] = v.serialize;
      h
    end
  end

  
  def_delegator :@value,   :[]
  def_delegator :@value,   :[]=
  

  class Proxy
    attr_accessor :keytype, :valuetype, :data
    
    def initialize(initial_value = {}, keytype:, valuetype:)
      @keytype   = keytype
      @valuetype = valuetype
      
      @data = initial_value 
    end
    
    def [](key_var)
      key_var = Var.create( keytype, key_var)
      value = @data[key_var]

      if valuetype.is_a?( Mapping ) && value.nil?
        value = Var.create( valuetype )
        @data[key_var] = value
      end

      value || Var.create(valuetype)
    end

    def []=(key_var, value)
      key_var = Var.create(keytype, key_var)
      val_var = Var.create(valuetype, value)

      if valuetype.is_a?( Mapping )
        val_var = Proxy.new(keytype: valuetype.keytype, valuetype: valuetype.valuetype)
        raise "What?"
      end

      @data[key_var] = val_var
    end
  end # class Proxy
end # class MappingVar
end  #  module Typed




__END__
  
  def value=(new_value)
    @value = if new_value.is_a?(TypedVariable)
      if new_value.type != type
        if type == Type.create(:addressOrDumbContract) &&
           [Type.create(:address), Type.create(:dumbContract)].include?(new_value.type)
           
          new_value.value
        else
          raise VariableTypeError.new("invalid #{type}: #{new_value.value}")
        end
      end
      
      new_value.value
    else
      type.check_and_normalize_literal(new_value)
    end
  end
  
  def method_missing(name, *args, &block)
    if value.respond_to?(name)
      result = value.send(name, *args, &block)
      
      if result.class == value.class
        result = type.check_and_normalize_literal(result)
      end
      
      if name.to_s.end_with?("=") && !%w[>= <=].include?(name.to_s[-2..])
        self.value = result if type.is_value_type?
        self
      else
        result
      end
    else
      binding.pry
      super
    end
  end

  def respond_to_missing?(name, include_private = false)
    value.respond_to?(name, include_private) || super
  end
  
  def !=(other)
    !(self == other)
  end
  
  def ==(other)
    other.is_a?(self.class) &&
    value == other.value &&
    type == other.type
  end
  
  def hash
    [value, type].hash
  end

  def eql?(other)
    hash == other.hash
  end
end
