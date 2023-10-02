module Types



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
 