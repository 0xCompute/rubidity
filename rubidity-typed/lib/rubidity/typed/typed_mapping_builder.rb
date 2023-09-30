

class TypedMapping

def self.build_class( key_type:, value_type: )

    key_type   = Type.create( key_type )    if key_type.is_a?( Symbol ) ||
                                               key_type.is_a?( String )
    value_type = Type.create( value_type )  if value_type.is_a?( Symbol ) ||
                                               value_type.is_a?( String )


    type = MappingType.instance( key_type, value_type )

    class_name =  type.typedclass_name
  
    ## note: keep a class cache
    ##  note: klasses may have different init sizes (default 0)
    cache           = @@cache ||= {}
    klass           = cache[ class_name ]
    ## fix-fix-fix - check if const klass defined for cache (no cache needed)!!!!!!!!
  
    if klass.nil?
      klass = Class.new( TypedMapping )
      klass.define_singleton_method( :type ) do
        @type  ||= type
      end

      ## add to cache for later (re)use
      cache[ class_name ] = klass
      TypedMapping.const_set( class_name, klass )
    end

    klass
end # method self.build_class

end  # class TypedMapping
