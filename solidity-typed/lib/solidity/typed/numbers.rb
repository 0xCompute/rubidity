module Types


class UInt < TypedValue
    def self.type() UIntType.instance; end  
    def self.zero()  @zero ||= UInt.new; end
    def zero?()   @value == 0; end

    def initialize( initial_value = 0 )
       ## was: initial_value ||= type.zero
       ##     check if nil gets passed in - default not used?  

      raise ArgumentError, "expected literal of type #{type}; got typed #{initial_value.pretty_print_inspect}"    if initial_value.is_a?( Typed )    
      
       @value = type.check_and_normalize_literal( initial_value )     
       @value.freeze  ## freeze here (and freeze self!) - why? why not?
       @value
    end 
  

     ## called / required if type is rvalue (NOT lvalue)
     ##   tries to coerce lvalue to this type here
     def coerce(other)
        puts "calling UInt#coerce other=#{other}:#{other.class.name}"
        [UInt.new( other.to_int ), self]
      end
    
     include Comparable
     def <=>(other)  @value <=> other.to_int; end

     def +(other ) UInt.new( @value + other.to_int); end
     def -(other)  UInt.new( @value - other.to_int); end
     def *(other)  UInt.new( @value * other.to_int); end
     def /(other)  UInt.new( @value / other.to_int); end

     def div(other) UInt.new( @value.div(other.to_int)); end
      ## add more Integer forwards here!!!!
     ##def_delegators :@value, :+, :-

## 
## undefined method `>=' for #<UInt @value=21000000> (NoMethodError)
## undefined method `-' for #<UInt @value=21000000> (NoMethodError)
    ## def to_i() @value; end
    def to_int() @value; end  ## "automagilally" support implicit integer conversion - why? why not?
    def to_i() @value; end
end  # class UInt



class Int < TypedValue
    def self.type() IntType.instance; end  
    def self.zero() @zero ||= Int.new; end
    def zero?()  @value == 0; end
  
    def initialize( initial_value = 0 )
       ## was: initial_value ||= type.zero
       ##     check if nil gets passed in - default not used?  

      raise ArgumentError, "expected literal of type #{type}; got typed #{initial_value.pretty_print_inspect}"    if initial_value.is_a?( Typed )    
      
       @value = type.check_and_normalize_literal( initial_value )     
       @value.freeze  ## freeze here (and freeze self!) - why? why not?
       @value
    end 

    include Comparable
    def <=>(other)  @value <=> other.to_int; end

    def +(other ) Int.new( @value + other.to_int); end
    def -(other)  Int.new( @value - other.to_int); end
    def *(other)  Int.new( @value * other.to_int); end
    def /(other)  Int.new( @value / other.to_int); end

      
    def to_int() @value; end  ## "automagilally" support implicit integer conversion - why? why not?
    def to_i() @value; end
end  # class Int
    


class Timestamp < TypedValue
    def self.type() TimestampType.instance; end  
    def self.zero() @zero ||= new; end
    def zero?()  @value == 0; end
  
    def initialize( initial_value = 0 )
       ## was: initial_value ||= type.zero
       ##     check if nil gets passed in - default not used?  

       raise ArgumentError, "expected literal of type #{type}; got typed #{initial_value.pretty_print_inspect}"    if initial_value.is_a?( Typed )    
      
       @value = type.check_and_normalize_literal( initial_value )     
       @value.freeze  ## freeze here (and freeze self!) - why? why not?
       @value
    end 

    ## todo/check - only allow other if Timestamp - why? why not? 
    include Comparable
    def <=>(other)  @value <=> other.to_int; end

    def +(other) Timestamp.new( @value + other.to_int); end
    def -(other)  Timestamp.new( @value - other.to_int); end
 
    def to_int() @value; end  ## "automagilally" support implicit integer conversion - why? why not?
end  # class Timestamp


class Timedelta < TypedValue
    def self.type() TimedeltaType.instance; end  
    def self.zero()  @zero ||= new; end
    def zero?()  @value == 0; end
    
    def initialize( initial_value = 0 )
       ## was: initial_value ||= type.zero
       ##     check if nil gets passed in - default not used?  

       raise ArgumentError, "expected literal of type #{type}; got typed #{initial_value.pretty_print_inspect}"    if initial_value.is_a?( Typed )    
      
       @value = type.check_and_normalize_literal( initial_value )     
       @value.freeze  ## freeze here (and freeze self!) - why? why not?
       @value
    end 
end  # class Timedelta


end   # module Types
 