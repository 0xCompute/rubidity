
module Types

class Mapping

def self.build_class( key_type, value_type )

    # key_type   = Type.create( key_type )    if key_type.is_a?( Symbol ) ||
    #                                            key_type.is_a?( String )
    # value_type = Type.create( value_type )  if value_type.is_a?( Symbol ) ||
    #                                            value_type.is_a?( String )
    # key_type   = key_type.type     if key_type.is_a?( Class ) && key_type.ancestors.include?( Typed )
    # value_type = value_type.type   if value_type.is_a?( Class ) && value_type.ancestors.include?( Typed )

    key_type   = typeof( key_type )
    value_type = typeof( value_type ) 

    type = MappingType.instance( key_type, value_type )

    class_name =  type.typedclass_name
  
    ## note: keep a class cache
    ##  note: klasses may have different init sizes (default 0)
    cache           = @@cache ||= {}
    klass           = cache[ class_name ]
    ## fix-fix-fix - check if const klass defined for cache (no cache needed)!!!!!!!!
  
    if klass.nil?
      klass = Class.new( Mapping )
      klass.define_singleton_method( :type ) do
        @type  ||= type
      end

      ## add self.new too - note: call/forward to "old" orginal self.new of Event (base) class
      klass.define_singleton_method( :new ) do |*args|
        old_new( *args )
      end

      ## add to cache for later (re)use
      cache[ class_name ] = klass
      Types.const_set( class_name, klass )
    end

    klass
end # method self.build_class

class << self
  alias_method :old_new, :new       # note: store "old" orginal version of new
  alias_method :new,     :build_class    # replace original version with create
end


end  # class Mapping
end  # module Types
