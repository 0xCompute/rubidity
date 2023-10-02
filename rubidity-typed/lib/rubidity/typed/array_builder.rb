
module Types
class Array

def self.build_class( sub_type )
  ## add convenience sub_type helper here - why? why not?
  ## sub_type = Type.create( sub_type )  if sub_type.is_a?( Symbol ) ||
  ##                                       sub_type.is_a?( String )
  sub_type = sub_type.type   if sub_type.is_a?( Class ) && sub_type.ancestors.include?( Typed )
      

  unless sub_type.is_value_type?
       raise ArgumentError, "Only value types for array elements supported for now; sorry" 
  end
  
  type = ArrayType.instance( sub_type )

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

      ## add to cache for later (re)use
      cache[ class_name ] = klass

      ## for default scope use Kernel - why? why not?
      ##   or Globals  or Typed - why? why not?
      Types.const_set( class_name, klass )
    end

    klass
end   # method self.build_class 
end   # class Array
end  # module Types
