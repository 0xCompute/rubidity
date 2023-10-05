module Types
class Typed  ## note: use class Typed as namespace (all metatype etc. nested here - the beginning)


class BoolType  < DataType
  def self.instance() @instance ||= new; end

  def format() 'bool'; end
  alias_method :to_s, :format 

  def ==(other)  other.is_a?( BoolType ); end

  def zero()  false; end


  ## note: class is really a module for bool - hack!!!
  ##   remove class from methods (typedclass_name|typedclass) - why? why not?
  ##  change typedclass_name to typed_name !!!
  ##   and   typedclass      to typed      !!! - why? why not??
  def typedclass_name()  Bool.name; end
  def typedclass()       Bool;  end    


  def new_zero() false; end
  def new( initial_value )   ## check - add default zero value - why? why not?
     ## allow integer 0|1 here too - why? why not?
     ##  fix-fix-fix  check solidity functions with bool (if they use 0|1 or true|false)!!!
     if initial_value.instance_of?( TrueClass )
        true
     elsif initial_value.instance_of?( FalseClass )
        false
     else
        ## use value error?
        raise ArgumentError, "BoolType.new - true or false arg expected; got: #{initial_value}"
     end
  end
end  # class BoolType

end  # class Typed  ## note: use class Typed as namespace (all metatype etc. nested here - the beginning)
end # module Types   

