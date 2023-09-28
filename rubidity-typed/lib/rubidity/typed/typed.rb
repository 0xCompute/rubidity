

class Object   ### move to core_ext/object - why? why not?
  ## check -  add ContractBase here too - why? why not?
  ##           e.g. is_a?( Typed ) || is_a?( ContractBase )
  ##             or add a TypedContract delagate class or such - why? why not?
  def typed?() is_a?( Typed ); end
end



def typed( type, initial_value = nil, **kwargs)   
    ## rename type to type_or_name or such - why? why not?
    return type.create( initial_value )   if type.is_a?( Type )    ## already a type(def) object

    ## check - allow strings too (onyl symbols now) - why? why not?

    ## check how to deal with :contract (only internal use) ???

    case type
    when :string                then  TypedString.new( initial_value )
    when :address               then  TypedAddress.new( initial_value ) 
    when :inscriptionId         then  TypedInscriptionId.new( initial_value )
    when :bytes32               then  TypedBytes32.new( initial_value )
    when :bytes                 then  TypedBytes.new( initial_value )
    when :bool                  then  TypedBool.new( initial_value ) 
    when :uint                  then  TypedUInt.new( initial_value )
    when :int                   then  TypedInt.new( initial_value )
    when :timestamp             then  TypedTimestamp.new( initial_value )
    when :array                 then  TypedArray.new( initial_value, **kwargs )
    when :mapping               then  TypedMapping.new( initial_value, **kwargs )
    else
      raise ArgumentError, "unknown type #{type}:#{type.class.name}; sorry"
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
  def self.create(  type, initial_value = nil, **kwargs ) 
     typed( type, initial_value, **kwargs ); 
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
                ## todo/check: add special handing for contracts here 
                ##                 why? why not?
                   raise TypeError, "expected type #{type}; got #{new_value.type} : #{new_value.value}"
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

  ## todo/check -- use self.zero or such - why? why not?
  def self.zero() @zero ||= new; end


  def type() StringType.instance; end  

  def initialize( initial_value = nil )
    replace( initial_value || type.zero )
  end
  
  ## add more String forwards here!!!!
  ##   fix!! - wrap returned values in typed value!!!
  ##                use type_cast_to_literal or such - why? why not?
  def_delegators :@value, :downcase, 
                          :index, :include?,
                          :+

  def to_str() @value; end  ## "automagilally" support implicit string conversion - why? why not?
end


class TypedAddress < TypedValue
   def type() AddressType.instance; end  
 
   def initialize( initial_value = nil)
      replace( initial_value || type.zero )
   end
end   # class TypedAddress


class TypedInscriptionId < TypedValue
    def type() InscriptionIdType.instance; end  
  
    def initialize( initial_value = nil)
       replace( initial_value || type.zero )
    end 
end  # class TypedInscriptionId



class TypedBytes32 < TypedValue
  def type() Bytes32Type.instance; end  

  def initialize( initial_value = nil )
    replace( initial_value || type.zero )
  end
end

class TypedBytes < TypedValue
  def type() BytesType.instance; end  

  def initialize( initial_value = nil )
    replace( initial_value || type.zero )
  end
end



class TypedBool < TypedValue
    def type() BoolType.instance; end  
  
    def initialize( initial_value = nil)
       replace( initial_value || type.zero )
    end 
end  # class TypedBool


class TypedUInt < TypedValue
    ## todo/check -- use self.zero or such - why? why not?
    def self.zero() @zero ||= new; end

    def type() UIntType.instance; end  
  
    def initialize( initial_value = nil)
       replace( initial_value || type.zero )
    end 


     include Comparable
     def <=>(other)  @value <=> other.to_int; end

     def +(other ) TypedUInt.new( @value + other.to_int); end
     def -(other)  TypedUInt.new( @value - other.to_int); end
     def *(other)  TypedUInt.new( @value * other.to_int); end
     def /(other)  TypedUInt.new( @value / other.to_int); end
      ## add more Integer forwards here!!!!
     ##def_delegators :@value, :+, :-

## 
## undefined method `>=' for #<TypedUInt @value=21000000> (NoMethodError)
## undefined method `-' for #<TypedUInt @value=21000000> (NoMethodError)
    ## def to_i() @value; end
    def to_int() @value; end  ## "automagilally" support implicit integer conversion - why? why not?
    def to_i() @value; end
end  # class TypedUInt


class TypedInt < TypedValue
    def type() IntType.instance; end  
  
    def initialize( initial_value = nil)
       replace( initial_value || type.zero )
    end 

    include Comparable
    def <=>(other)  @value <=> other.to_int; end

    def +(other ) TypedInt.new( @value + other.to_int); end
    def -(other)  TypedInt.new( @value - other.to_int); end
    def *(other)  TypedInt.new( @value * other.to_int); end
    def /(other)  TypedInt.new( @value / other.to_int); end

      
    def to_int() @value; end  ## "automagilally" support implicit integer conversion - why? why not?
    def to_i() @value; end
end  # class TypedInt
    
class TypedTimestamp < TypedValue
    def type() TimestampType.instance; end  
  
    def initialize( initial_value = nil)
       replace( initial_value || type.zero )
    end 
end  # class TypedTimestamp



  