module Types
class Typed  ## note: use class Typed as namespace (all metatype etc. nested here - the beginning)
    

class ArrayType < ReferenceType   ## note: dynamic array for now (NOT fixed!!!! - add FixedArray - why? why not?)
    attr_reader :sub_type
    attr_reader :size     ## rename size to dim(ension) or such - why? why not?
    def initialize( sub_type, size=0 )
      @sub_type = sub_type
      @size     = size
    end
    def format
      if @size == 0   ## assume dynamic
         "#{@sub_type.format}[]"   
      else
        "#{@sub_type.format}[#{@size}]"
      end
    end
    alias_method :to_s, :format 

    def ==(other)
      other.is_a?( ArrayType ) &&
       @sub_type == other.sub_type &&
       @size     == other.size    ### add check for size too - why? why not?  
    end
    def zero
        ## return [] - why? why not?
        ## fix-fix-fix-  return zero-ed array for fixed array - why? why not?
        []    
    end
    
    def self.instance( sub_type, size=0 ) 
       raise ArgumentError, "[ArrayType.instance] sub_type not a type - got #{sub_type}; sorry" unless sub_type.is_a?( Type )
       @instances ||= {}
       key = ''  ## note: String.new('') will pick-up TypedString!!; thus, use literal for now 
       key += sub_type.format
       key += "×#{size}"   if size != 0
       @instances[ key ] ||= new( sub_type, size ) 
    end

    def typedclass_name
      ## return/use symbol (not string here) - why? why not?
      ##  or use TypedArrayOf<sub-type.typedclass_name>  - why? why not?
      sub_name = _sanitize_class_name( @sub_type.typedclass_name )
      name = ''   ## note: String.new('') will pick-up TypedString!!; thus, use literal for now
      name += "Array‹#{sub_name}›"
      name += "×#{size}"   if @size != 0
      name 
    end
    def typedclass()  Types.const_get( typedclass_name ); end
    def new_zero()   typedclass.new( [] ); end  
    def new( initial_value=[] ) typedclass.new( initial_value ); end 
    alias_method :create, :new     ## remove create alias - why? why not?
end # class ArrayType


end  # class Typed  ## note: use class Typed as namespace (all metatype etc. nested here - the beginning)
end # module Types  