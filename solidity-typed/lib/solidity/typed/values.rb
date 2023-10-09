module Types




class String < TypedValue
  def self.type() StringType.instance; end  
  def self.zero() @zero ||= new; end
  def zero?() @value.empty?; end


  def initialize( initial_value = STRING_ZERO )
    ## was: initial_value ||= type.zero
    ##     check if nil gets passed in - default not used?  

    raise ArgumentError, "expected literal of type #{type}; got typed #{initial_value.pretty_print_inspect}"    if initial_value.is_a?( Typed )
    
    @value = type.check_and_normalize_literal( initial_value )
    @value.freeze  ## freeze here - why? why not?
    @value
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
  def self.zero() @zero ||= new; end
  def zero?() @value == ADDRESS_ZERO; end

  
   def initialize( initial_value = ADDRESS_ZERO )
      ## was: initial_value ||= type.zero
      ##     check if nil gets passed in - default not used?  

      raise ArgumentError, "expected literal of type #{type}; got typed #{initial_value.pretty_print_inspect}"    if initial_value.is_a?( Typed )
      
      @value = type.check_and_normalize_literal( initial_value )  
      @value.freeze  ## freeze here - why? why not?
      @value
   end
end  # class Address


class InscriptionId < TypedValue
    def self.type() InscriptionIdType.instance; end  
    def self.zero() @zero ||= new; end
    def zero?() @value == INSCRIPTION_ID_ZERO; end

    def initialize( initial_value = INSCRIPTION_ID_ZERO )
      ##  was: nitial_value ||= type.zero
      ##     check if nil gets passed in - default not used?  

      raise ArgumentError, "expected literal of type #{type}; got typed #{initial_value.pretty_print_inspect}"    if initial_value.is_a?( Typed )    
      
      @value = type.check_and_normalize_literal( initial_value ) 
      @value.freeze  ## freeze here - why? why not?
      @value   
    end 
end  # class InscriptionId



class Bytes32 < TypedValue
  def self.type() Bytes32Type.instance; end  
  def self.zero() @zero ||= new; end
  def zero?()  @value == BYTES32_ZERO; end

  def initialize( initial_value = BYTES32_ZERO )
     ## was: initial_value ||= type.zero
     ##     check if nil gets passed in - default not used?  

     raise ArgumentError, "expected literal of type #{type}; got typed #{initial_value.pretty_print_inspect}"    if initial_value.is_a?( Typed )    
      
     @value = type.check_and_normalize_literal( initial_value )
     @value.freeze  ## freeze here - why? why not?
     @value   
  end
end  # class Bytes32


class Bytes < TypedValue
  def self.type() BytesType.instance; end  
  def self.zero()  @zero ||= new; end
  def zero?()  @value == BYTES_ZERO; end

  def initialize( initial_value = BYTES_ZERO )
    ## was: initial_value ||= type.zero
    ##     check if nil gets passed in - default not used?  

    raise ArgumentError, "expected literal of type #{type}; got typed #{initial_value.pretty_print_inspect}"    if initial_value.is_a?( Typed )    
      
    @value = type.check_and_normalize_literal( initial_value )  
    @value.freeze  ## freeze here - why? why not?
    @value
   end
end  # class Bytes



end  # module Types
 