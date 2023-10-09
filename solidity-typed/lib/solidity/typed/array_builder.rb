
module Types
class Array

## note: add size option here (size=0) default is dynamic (not fixed)!!!  
def self.build_class( sub_type, size=0 )
  ## add convenience sub_type helper here - why? why not?
  ## sub_type = Type.create( sub_type )  if sub_type.is_a?( Symbol ) ||
  ##                                       sub_type.is_a?( String )
  ## sub_type = sub_type.type   if sub_type.is_a?( Class ) && sub_type.ancestors.include?( Typed )
   sub_type = typeof( sub_type )    
  
  type = ArrayType.instance( sub_type, size )

  class_name =  type.typedclass_name
  
    ## note: keep a class cache
    ##  note: klasses may have different init sizes (default 0)
    cache           = @@cache ||= {}
    klass           = cache[ class_name ]
    ## fix-fix-fix - check if const klass defined for cache (no cache needed)!!!!!!!!
  
    if klass.nil?
      klass = Class.new( Array )
      klass.define_singleton_method( :type ) do
        @type  ||= type
      end

      ## add self.new too - note: call/forward to "old" orginal self.new of Event (base) class
      klass.define_singleton_method( :new ) do |*args|
         old_new( *args )
      end
    
      ## add to cache for later (re)use
      cache[ class_name ] = klass

      ## for default scope use Kernel - why? why not?
      ##   or Globals  or Typed - why? why not?
      Types.const_set( class_name, klass )
    end

    klass
end   # method self.build_class 

class << self
  alias_method :old_new, :new       # note: store "old" orginal version of new
  alias_method :new,     :build_class    # replace original version with create
end


end   # class Array
end  # module Types

