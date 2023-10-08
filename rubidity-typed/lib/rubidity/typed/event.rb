
module Types
class Event  < Typed

def self.zero
   raise "event cannot be zero (by defintion); sorry"
end

def zero?() false; end



def initialize( *args, **kwargs  )
   ## fix-fix-fix: first check for matching args - why? why not?
    if kwargs.size > 0   ## assume kwargs
      ## note: kwargs.size check matching attributes "upstream" in new!!!
      self.class.attributes.each do |key, type|
         value = kwargs[ key ]
         raise ArgumentError,  "event arg with key >#{key}< missing; sorry"  if value.nil?
         value = if value.is_a?(Typed)
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
 

end # class Event
end # module Types
