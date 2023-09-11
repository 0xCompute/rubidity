


class TypedVariable
  extend Forwardable   ## pulls in def_delegator


  attr_accessor :type, :value


 ## todo/fix: make initialize "private" - always use create!!! 
  def initialize( type, value = nil)
    @type        = type

    unless type.is_a?( Type )
      puts  "!! [warn] no type passed in; got #{type.inspect} for #{self.class.name} with value >#{value.inspect}<"
    end

    self.value   = value || type.zero
  end
 

  
  def self.create( type, value = nil, **kwargs)
    case type
    when :string  
      TypedString.new( value ) 
    when :array 
      TypedArray.new( value, **kwargs )
    when :mapping 
      TypedMapping.new( value, **kwargs )
    else
      new( Type.create( type ), value )
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

  ### value=(new_value) change to replace
  ##
  def value=(new_value)
    @value = if new_value.is_a?(TypedVariable)
               if new_value.type != @type
                 if type.is_a?( AddressOrDumbContractType ) &&
                     (new_value.type.is_a?( AddressType ) ||
                      new_value.type.is_a?( DumbContractType ))           
                   new_value.value
                 else
                   raise TypeError, "expected type #{type}; got #{new_value.type} : #{new_value.value}"
                 end
               end
               new_value.value
            else
               type.check_and_normalize_literal(new_value)
            end
  end
end # class Var



## add value & reference type base - why? why not?
class TypedValue < TypedVariable; end
class TypedReference < TypedVariable; end 





class TypedString < TypedValue

  ## used shared type instance - why? why not?
  def type() StringType.instance; end  

  def initialize( value = nil )
    self.value  = value || type.zero
  end

  
  ## add more String forwards here!!!!
  def_delegators :@value, :downcase, 
                          :index, :include?,
                          :+

  def to_str() @value; end  ## "automagilally" support implicit string conversion - why? why not?


  def zero?()  @value == type.zero; end


  def pretty_print( printer ) printer.text( "<var string:#{@value.inspect}>" ); end
end



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
