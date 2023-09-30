

class Object   ### move to core_ext/object - why? why not?
  ## check -  add ContractBase here too - why? why not?
  ##           e.g. is_a?( Typed ) || is_a?( ContractBase )
  ##             or add a TypedContract delagate class or such - why? why not?
  ##    fix - check for class has singelton method type - why? why not?
  def typed?() is_a?( Typed ); end
end



class Typed 
  ### fix-fix-fix-  move Forward to where it's used only; not here - why? why not?
   extend Forwardable   ## pulls in def_delegator

  def self.type      
    raise "no required typed class accessor/ getter method defined for Typed subclass #{self.class.name}; sorry"
  end
  def type() self.class.type; end


  def as_json( args={} )  serialize; end
  def serialize      
    raise "no required serialize method defined for Typed subclass #{self.class.name}; sorry"
  end  

  def deserialize( serialized_value )  replace( serialized_value ); end
  def replace( new_value )      
    raise "no required replace method defined for Typed subclass #{self.class.name}; sorry"
  end  
end  # class Typed



## add value & reference type base - why? why not?
class TypedValue < Typed
    
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



class TypedReference < Typed

    def ==(other)
        other.is_a?(self.class) &&
        type == other.type &&
        data == other.data 
    end
      
    def hash()       [data, type].hash; end
    def eql?(other)  hash == other.hash;  end
end 



class TypedString < TypedValue
  def self.type() StringType.instance; end  

  ## todo/check -- use self.zero or such - why? why not?
  def self.zero() @zero ||= new; end

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
  def self.type() AddressType.instance; end  
 
   def initialize( initial_value = nil)
      replace( initial_value || type.zero )
   end
end   # class TypedAddress


class TypedInscriptionId < TypedValue
    def self.type() InscriptionIdType.instance; end  
  
    def initialize( initial_value = nil)
       replace( initial_value || type.zero )
    end 
end  # class TypedInscriptionId



class TypedBytes32 < TypedValue
  def self.type() Bytes32Type.instance; end  

  def initialize( initial_value = nil )
    replace( initial_value || type.zero )
  end
end

class TypedBytes < TypedValue
  def self.type() BytesType.instance; end  

  def initialize( initial_value = nil )
    replace( initial_value || type.zero )
  end
end



class TypedBool < TypedValue
    def self.type() BoolType.instance; end  
  
    def initialize( initial_value = nil)
       replace( initial_value || type.zero )
    end 
end  # class TypedBool


class TypedUInt < TypedValue
    def self.type() UIntType.instance; end  

    ## todo/check -- use self.zero or such - why? why not?
    def self.zero() @zero ||= new; end

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
    def self.type() IntType.instance; end  
  
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
    def self.type() TimestampType.instance; end  
  
    def initialize( initial_value = nil)
       replace( initial_value || type.zero )
    end 
end  # class TypedTimestamp



  