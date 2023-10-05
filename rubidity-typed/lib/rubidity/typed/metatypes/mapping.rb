module Types
class Typed  ## note: use class Typed as namespace (all metatype etc. nested here - the beginning)
    

class MappingType < ReferenceType
     def self.instance( key_type, value_type ) 
        raise ArgumentError, "[MappingType.instance] key_type not a type - got #{key_type}; sorry" unless key_type.is_a?( Type )
        raise ArgumentError, "[MappingType.instance] value_type not a type - got #{value_type}; sorry" unless value_type.is_a?( Type )
        @instances ||= {}
        @instances[ key_type.format+"=>"+value_type.format ] ||= new(key_type, value_type) 
     end


    attr_reader :key_type
    attr_reader :value_type
     def initialize( key_type, value_type )
       @key_type   = key_type
       @value_type = value_type
     end
     def format() "mapping(#{@key_type.format}=>#{@value_type.format})"; end
     alias_method :to_s, :format 

     def ==(other)
       other.is_a?( MappingType ) && 
       @key_type   == other.key_type &&
       @value_type == other.value_type 
     end
     def zero
        ##  return {} - why? why not?
        {}    
     end
    

     def typedclass_name
      ## return/use symbol (not string here) - why? why not?
      ##  or use TypedMappingOf<key-type.typedclass_name><value_type...>  - why? why not?
      key_name   = _sanitize_class_name( key_type.typedclass_name )
      value_name = _sanitize_class_name( value_type.typedclass_name )
      "Mapping‹#{key_name}→#{value_name}›"
    end
    def typedclass()  Types.const_get( typedclass_name ); end
   
    def new_zero() typedclass.new; end 
    def new( initial_value ) typedclass.new( initial_value ); end 
end # class MappingType


end  # class Typed  ## note: use class Typed as namespace (all metatype etc. nested here - the beginning)
end # module Types  