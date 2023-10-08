
module Types
class Struct  < Typed

def self.zero
  ## note: freeze return new zero (for "singelton" & "immutable" zero instance)
  ##  todo/fix:
  ##   in build_class add freeze for composite/reference objects
  ##     that is, arrays, hash mappings, structs etc.
  ##   freeze only works for now for "value" objects e.g. integer, bool, etc.
  @zero ||= new_zero.freeze
end

def zero?() self == self.class.zero; end



def initialize( *args, **kwargs )
   ## fix-fix-fix: first check for matching args - why? why not?
   if kwargs.size > 0   ## assume kwargs init
      self.class.attributes.each do |key, type|
         ## note: allow unused keys (will get set to zero)
         value = kwargs.has_key?( key ) ? kwargs[ key ] : type.new_zero
         value = if value.is_a?( Typed )
                   ## fix-fix-fix - check type match here!!!
                   value
                 else 
                   type.new( value )
                 end
         instance_variable_set( "@#{key}", value )
       end
   else
     self.class.attributes.zip( args ).each do |(key, type), value|
       value = if value.is_a?(Typed)
                 ## fix-fix-fix - check type match here!!!
                 value
               else 
                 type.new( value )
               end
       instance_variable_set( "@#{key}", value )
     end
   end
   self  ## note: return reference to self for chaining method calls
end


def as_data
   self.class.attributes.keys.map do |key|
        ivar = instance_variable_get( "@#{key}" )
        puts "  @#{key}:"
        pp ivar
        ivar.as_data
   end
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
 

end # class Struct
end # module Types
