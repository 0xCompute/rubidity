class BoolType < ValueType
    def format() 'bool'; end
    alias_method :to_s, :format 

    def ==(other)  other.is_a?( BoolType ); end
    def zero()   false; end
    

    def self.instance()  @instance ||= new; end

    def typedclass_name()  Bool.name; end
    def typedclass()       Bool;  end    
    def new_zero() Bool.new( false ); end
    def new( initial_value=false ) Bool.new( initial_value ); end 
    alias_method :create, :new     ## remove create alias - why? why not?
end


## fix-fix-fix  - use TypedData - to make Bool into enum like constant!!!
##       cannot use new!!!!! (only (re)use true|false instances)
class Bool < TypedValue
    def self.type() BoolType.instance; end  
  
    def initialize( initial_value = nil)
       initial_value ||= type.zero
       raise ArgumentError, "expected literal of type #{type}; got typed #{initial_value.pretty_print_inspect}"    if initial_value.is_a?( Typed )    
      
       @value = type.check_and_normalize_literal( initial_value )  
    end 


    ## lets you "toogle" bool wrapper (until we get true bools!!!)
    def !@()  
      puts "[debug] Bool#!@ self: #{pretty_print_inspect}"
      Bool.new( !@value )
    end


    ## return nil if not bool - check if this works with <=>???
    def _to_bool( other )
      return other.as_data if other.is_a?( Bool )
      return other         if other.is_a?( TrueClass ) || other.is_a?( FalseClass )
      return nil    ## not a bool  - what to return here?
    end

    def ==(other)
      puts "[debug] Bool#== self: #{pretty_print_inspect}, other: #{other.pretty_print_inspect}"
      ## note: yes - nil == false #=> false (only false == false)
      @value ==  _to_bool( other )
    end

    include Comparable
    def <=>(other)  
      @value <=> _to_bool( other ) 
    end   
end  # class Bool

