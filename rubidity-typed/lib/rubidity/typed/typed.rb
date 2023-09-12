
class Object   ### move to core_ext/object - why? why not?
  def typed?() is_a?( Typed ); end
end



def typed( type, value = nil, **kwargs)
    case type
    when :string                then  TypedString.new( value )
    when :address               then  TypedAddress.new( value ) 
    when :dumbContract          then  TypedDumbContract.new( value )
    when :addressOrDumbContract then  TypedAddressOrDumbContract.new( value ) 
    when :ethscriptionId        then  TypedEthscriptionId.new( value )
    when :bool                  then  TypedBool.new( value ) 
    when :uint256               then  TypedUint256.new( value )
    when :int256                then  TypedInt256.new( value )
    when :datetime              then  TypedDatatime.new( value )
    when :array                 then  TypedArray.new( value, **kwargs )
    when :mapping               then  TypedMapping.new( value, **kwargs )
    else
      raise ArgumentError, "unknown type #{type}; sorry"
    end
end





class Typed 
   extend Forwardable   ## pulls in def_delegator

  def type      
    raise "no required typed accessor/ getter method defined for Typed subclass #{self.class.name}; sorry"
  end

  def as_json(args = {}) 
    serialize
  end
  def serialize      
    raise "no required serialize method defined for Typed subclass #{self.class.name}; sorry"
  end  
  def deserialize( serialized_value )
    replace( serialized_value )
  end
  def replace( new_value )      
    raise "no required replace method defined for Typed subclass #{self.class.name}; sorry"
  end  
end  # class Typed



### note: for "legacy" use TypedVariable as legacy base - remove? SOON? why? why not?
class TypedVariable  < Typed   ## old "legacy" class for create - do NOT use  
  def self.create(  type, value = nil, **kwargs ) 
     typed( type, value, **kwargs ); 
   end
end # class TypedVariable





## add value & reference type base - why? why not?
class TypedValue < TypedVariable
    
  ## todo/check: make "internal" value (string/integer) available? why? why not?
  attr_reader :value   

  def zero?()  @value == type.zero; end

  def serialize() @value; end  

  def replace(new_value)
    @value = if new_value.is_a?( Typed )
               if new_value.type != type
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
               type.check_and_normalize_literal( new_value )
            end
  end

  def pretty_print( printer ) printer.text( "<val #{type}:#{@value.inspect}>" ); end

  def to_s
    if @value.is_a?(String) || @value.is_a?(Integer)
      @value.to_s
    else
      raise "No string conversion"
    end
  end

      def ==(other)
        other.is_a?(self.class) &&
        type == other.type &&     ## note: type for no redundant (always the same if same class AND TypedValue)
        value == other.value
      end
      
      def hash()       [value, type].hash; end
      def eql?(other)  hash == other.hash;  end
end  # TypedValue



class TypedReference < TypedVariable

    def ==(other)
        other.is_a?(self.class) &&
        type == other.type &&
        data == other.data 
      end
      
      def hash()       [data, type].hash; end
      def eql?(other)  hash == other.hash;  end
end 



class TypedString < TypedValue
  def type() StringType.instance; end  

  def initialize( value = nil )
    replace( value || type.zero )
  end
  
  ## add more String forwards here!!!!
  def_delegators :@value, :downcase, 
                          :index, :include?,
                          :+

  def to_str() @value; end  ## "automagilally" support implicit string conversion - why? why not?
end


class TypedAddress < TypedValue
   def type() AddressType.instance; end  
 
   def initialize( value = nil)
      replace( value || type.zero )
   end
end   # class TypedAddress

class TypedDumbContract < TypedValue
    def type() DumpContractType.instance; end  
  
    def initialize( value = nil)
       replace( value || type.zero )
    end 
end  # class TypedDumbContract

class TypedAddressOrDumbContract < TypedValue
    def type() AddressOrDumbContractType.instance; end  
  
    def initialize( value = nil)
       replace( value || type.zero )
    end 
end  # class TypedAddressOrDumbContract

class TypedEthscriptionId < TypedValue
    def type() EthscriptionIdType.instance; end  
  
    def initialize( value = nil)
       replace( value || type.zero )
    end 
end  # class TypedEthscriptionId
   
class TypedBool < TypedValue
    def type() BoolType.instance; end  
  
    def initialize( value = nil)
       replace( value || type.zero )
    end 
end  # class TypedBool

class TypedUint256 < TypedValue
    def type() Uint256Type.instance; end  
  
    def initialize( value = nil)
       replace( value || type.zero )
    end 

    def to_int() @value; end  ## "automagilally" support implicit integer conversion - why? why not?
end  # class TypedUint256

class TypedInt256 < TypedValue
    def type() Int256Type.instance; end  
  
    def initialize( value = nil)
       replace( value || type.zero )
    end 

    def to_int() @value; end  ## "automagilally" support implicit integer conversion - why? why not?
end  # class TypedInt256
    
class TypedDatetime < TypedValue
    def type() DatetimeType.instance; end  
  
    def initialize( value = nil)
       replace( value || type.zero )
    end 
end  # class TypedDatetime






__END__
  
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
  
  