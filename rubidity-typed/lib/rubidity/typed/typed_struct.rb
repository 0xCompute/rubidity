

class TypedStruct  < Typed


  ## add serialize & deserialize 
    ##   fix-fix-fix - move into base class (and reuse for all structs!!!) - why? why not?
def serialize
   self.class.attributes.keys.map do |key|
        ivar = instance_variable_get( "@#{key}" )
        puts "  @#{key}:"
        pp ivar
        ivar.serialize
   end
end

def replace( new_value )    ## note: used for (same as) deserialize!!!
   ## note: assume new_value is an array (of literal values)
   self.class.attributes.zip( new_value ).each do |(key, type), value|
        ## todo/check: change type.create   to type.new_zero
        ##          deprecate create without args - why? why not?
        ## fix-fix-fix:  also use type.create.deserialize in array and hash!!!
        ##                                       might be a struct too (or enum) !!!!!
        var = type.create   ## create zero var
        var.deserialize( value )
        instance_variable_set( "@#{key}", var )
    end
    self  ## note: return reference to self for chaining method calls
end
  


def ==(other)
   if other.is_a?( self.class )
      self.class.attributes.keys.all? do |key|
            __send__( key ) == other.__send__( key )
      end
   else
      false
   end
end
##  do note override eql? why? why not?
#       default is object id equality???
## alias_method :eql?, :==
 

def self.zero
  ## note: freeze return new zero (for "singelton" & "immutable" zero instance)
  ##  todo/fix:
  ##   in build_class add freeze for composite/reference objects
  ##     that is, arrays, hash mappings, structs etc.
  ##   freeze only works for now for "value" objects e.g. integer, bool, etc.
  @zero ||= new_zero.freeze
end

def zero?() self == self.class.zero; end

end # class TypedStruct
