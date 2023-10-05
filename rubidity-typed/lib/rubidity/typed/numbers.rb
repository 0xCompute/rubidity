module Types


class UInt < TypedValue
    def self.type() UIntType.instance; end  

    def initialize( initial_value = 0 )
       ## was: initial_value ||= type.zero
       ##     check if nil gets passed in - default not used?  

      raise ArgumentError, "expected literal of type #{type}; got typed #{initial_value.pretty_print_inspect}"    if initial_value.is_a?( Typed )    
      
       @value = type.check_and_normalize_literal( initial_value )     
    end 
  
     include Comparable
     def <=>(other)  @value <=> other.to_int; end

     def +(other ) UInt.new( @value + other.to_int); end
     def -(other)  UInt.new( @value - other.to_int); end
     def *(other)  UInt.new( @value * other.to_int); end
     def /(other)  UInt.new( @value / other.to_int); end
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
  
    def initialize( initial_value = 0 )
       ## was: initial_value ||= type.zero
       ##     check if nil gets passed in - default not used?  

      raise ArgumentError, "expected literal of type #{type}; got typed #{initial_value.pretty_print_inspect}"    if initial_value.is_a?( Typed )    
      
       @value = type.check_and_normalize_literal( initial_value )     
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
  
    def initialize( initial_value = 0 )
       ## was: initial_value ||= type.zero
       ##     check if nil gets passed in - default not used?  

       raise ArgumentError, "expected literal of type #{type}; got typed #{initial_value.pretty_print_inspect}"    if initial_value.is_a?( Typed )    
      
       @value = type.check_and_normalize_literal( initial_value )     
    end 
end  # class Timestamp


class Timedelta < TypedValue
    def self.type() TimedeltaType.instance; end  
  
    def initialize( initial_value = 0 )
       ## was: initial_value ||= type.zero
       ##     check if nil gets passed in - default not used?  

       raise ArgumentError, "expected literal of type #{type}; got typed #{initial_value.pretty_print_inspect}"    if initial_value.is_a?( Typed )    
      
       @value = type.check_and_normalize_literal( initial_value )     
    end 
end  # class Timedelta


end   # module Types
 