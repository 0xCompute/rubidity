module Types


## add value & reference type base - why? why not?
class TypedValue < Typed
    
  ## todo/check: make "internal" value (string/integer) available? why? why not?
  ##  attr_reader :value   

  ## todo/check -- use self.zero or such - why? why not?
  def self.zero() @zero ||= new; end

  def zero?()  @value == type.zero; end
  def as_data() @value; end  

=begin  
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
=end

  def pretty_print( printer ) printer.text( "<val #{type}:#{@value.inspect}>" ); end

  def to_s
    if @value.is_a?(::String) || @value.is_a?(::Integer)
      @value.to_s
    else
      raise "no string conversion of value possible; sorry"
    end
  end

      def ==(other)
        other.is_a?(self.class) &&
        type == other.type &&     ## note: type for no redundant (always the same if same class AND TypedValue)
        as_data == other.as_data    ## compare value via as_data!!!
      end
      
      def hash()       [@value, type].hash; end
      ## todo/check - hash == other.hash is default any way??
      def eql?(other)  hash == other.hash;  end
end  # TypedValue



## fix-fix-fix  - use TypedData - to make Bool into enum like constant!!!
##       cannot use new!!!!! (only (re)use true|false instances)
class Bool < TypedValue
    def self.type() BoolType.instance; end  
  
    def initialize( initial_value = nil)
       initial_value ||= type.zero
       raise ArgumentError, "expected literal of type #{type}; got typed #{initial_value.pretty_print_inspect}"    if initial_value.is_a?( Typed )    
      
       @value = type.check_and_normalize_literal( initial_value )  
    end 
end  # class Bool



class String < TypedValue
  def self.type() StringType.instance; end  

  def initialize( initial_value = nil )
    initial_value ||= type.zero

    raise ArgumentError, "expected literal of type #{type}; got typed #{initial_value.pretty_print_inspect}"    if initial_value.is_a?( Typed )
    
    @value = type.check_and_normalize_literal( initial_value )
   end


  extend Forwardable   ## pulls in def_delegator
  ## add more String forwards here!!!!
  ##   fix!! - wrap returned values in typed value!!!
  ##                use type_cast_to_literal or such - why? why not?
  def_delegators :@value, :downcase, 
                          :index, :include?,
                          :+

  def to_str() @value; end  ## "automagilally" support implicit string conversion - why? why not?
end   # class String


class Address < TypedValue
  def self.type() AddressType.instance; end  
 
   def initialize( initial_value = nil )
      initial_value ||= type.zero
      raise ArgumentError, "expected literal of type #{type}; got typed #{initial_value.pretty_print_inspect}"    if initial_value.is_a?( Typed )
      
      @value = type.check_and_normalize_literal( initial_value )  
   end
end  # class Address


class InscriptionId < TypedValue
    def self.type() InscriptionIdType.instance; end  
  
    def initialize( initial_value = nil)
      initial_value ||= type.zero
      raise ArgumentError, "expected literal of type #{type}; got typed #{initial_value.pretty_print_inspect}"    if initial_value.is_a?( Typed )    
      
      @value = type.check_and_normalize_literal( initial_value )  
    end 
end  # class InscriptionId



class Bytes32 < TypedValue
  def self.type() Bytes32Type.instance; end  

  def initialize( initial_value = nil )
     initial_value ||= type.zero
     raise ArgumentError, "expected literal of type #{type}; got typed #{initial_value.pretty_print_inspect}"    if initial_value.is_a?( Typed )    
      
     @value = type.check_and_normalize_literal( initial_value )  
  end
end  # class Bytes32


class Bytes < TypedValue
  def self.type() BytesType.instance; end  

  def initialize( initial_value = nil )
    initial_value ||= type.zero
    raise ArgumentError, "expected literal of type #{type}; got typed #{initial_value.pretty_print_inspect}"    if initial_value.is_a?( Typed )    
      
    @value = type.check_and_normalize_literal( initial_value )  
 end
end  # class Bytes



end  # module Types
 