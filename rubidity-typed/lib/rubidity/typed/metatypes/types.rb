
###  
#  Metatype classes like Class in ruby 
#    every Typed<> has a (Meta)Type class singleton (shared) instance that is_a?( Type )


## note:
##   make bytes a reference type?
##     bytes NOT like string frozen?
##    more like a stringbuffer / bytesbuffer - 
##   double check if "in-place" updates to value possible!!!



###
# global helper(s) - move to ??? - why? why not?

def _sanitize_class_name( name )
  name = name.sub( /\bContractBase::/, '' )   ## remove contract module from name if present
  name = name.sub( /\bContract::/, '' )   ## remove contract module from name if present
  name = name.sub( /\bTyped::/, '' )
  name = name.sub( /\bTypes::/, '' )
  name = name.sub( /\bTypedArray::/, '' )
  name = name.sub( /\bTypedMapping::/, '' )
  name = name.gsub( '::', '' )                ## remove module separator if present
  name
end



module Types
class Typed  ## note: use class Typed as namespace (all metatype etc. nested here - the beginning)
class Type
     ## change format to type or typesig/type_sig 
     ##       or sig or signature or typespec   - why? why not?   
    def format    
        ## check/todo: what error to raise for not implemented / method not defined???
        ### note: raise (will use RuntimeError/Exception?)
        raise "no required format method defined for Type subclass #{self.class.name}; sorry"
    end   
    ## return type signature string - why? why not?
    ##   e.g.     string
    ##            mapping(address=>uint256)
    ##            string[]
    ##       and so on...
    def pretty_print( printer ) printer.text( "<type #{format}>" ); end

    def zero   ## change to zero_literal (returns 0, [], {} - NOT typed version) - why? why not?
      #    ## check/todo: what error to raise for not implemented / method not defined???
      raise "no required zero method defined for Type subclass #{self.class.name}; sorry"
    end

  ##  todo/check - make "dynamic" e.g. structs with all value types still value type? - why? why not?  
  def is_value_type?() is_a?( ValueType ); end    


  def mapping?()  is_a?( MappingType ); end
  def array?()    is_a?( ArrayType ); end
  ## add more metatype helpers here - why? why not?
 

### todo/check for minimal required methods required for
##    compare and equal support??
def ==(other)
  raise "no required == method defined for Type subclass #{self.class.name}; sorry"
end

def hash()    [format].hash;  end    ## add Type prefix or such - why? why not?  
def eql?(other)  hash == other.hash; end  ## check eql? used for what?
end  # class Type



   class ValueType < Type; end       ## add value & reference type base - why? why not?
   class ReferenceType < Type; end


##
## ruby note:  is_a? and kind_of? are alias - the same
##            for "strict" checking use instance_of?()


class StringType < ValueType  ## note: strings are frozen / immutable - check again!!
    def format() 'string'; end
    alias_method :to_s, :format 

    def ==(other)  other.is_a?( StringType ); end
    def zero()  STRING_ZERO;  end    
 
 
    def self.instance()  @instance ||= new; end

    
    ## todo: return "shared" String zero - why? why not?
    ##   note: use Types::String here to avoid confusion with ::String - why? why not?
    def typedclass_name()  Types::String.name; end
    def typedclass()       Types::String;  end
    def new_zero()   Types::String.new( STRING_ZERO ); end
    def new( initial_value=STRING_ZERO ) Types::String.new( initial_value ); end 
    alias_method :create, :new     ## remove create alias - why? why not?
end



class AddressType < ValueType
    def format() 'address'; end
    alias_method :to_s, :format 

    def ==(other)  other.is_a?( AddressType ); end
    def zero() ADDRESS_ZERO;  end
    
 
    def self.instance()  @instance ||= new; end
 
    ## todo: return "shared" Address zero - why? why not?
    def typedclass_name()  Address.name; end
    def typedclass()       Address;  end
    def new_zero() Address.new( ADDRESS_ZERO ); end
    def new( initial_value=ADDRESS_ZERO ) Address.new( initial_value ); end 
    alias_method :create, :new     ## remove create alias - why? why not?
end



class InscriptionIdType < ValueType      ## todo/check: rename to inscripeId or inscriptionId
    def format() 'inscriptionId'; end
    alias_method :to_s, :format 

    def ==(other)  other.is_a?( InscriptionIdType ); end
    def zero()  INSCRIPTION_ID_ZERO; end
 
    
    def self.instance()  @instance ||= new; end
 
    def typedclass_name()  InscriptionId.name; end
    def typedclass()       InscriptionId;  end    
    def new_zero() InscriptionId.new( INSCRIPTION_ID_ZERO ); end
    def new( initial_value=INSCRIPTION_ID_ZERO ) InscriptionId.new( initial_value ); end 
    alias_method :create, :new     ## remove create alias - why? why not?
end


class Bytes32Type < ValueType  
  def format() 'bytes32'; end
  alias_method :to_s, :format 

  def ==(other)  other.is_a?( Bytes32Type ); end
  def zero()  BYTES32_ZERO; end

  
  def self.instance()  @instance ||= new; end

  def typedclass_name()  Bytes32.name; end
  def typedclass()       Bytes32;  end    
  def new_zero() Bytes32.new( BYTES32_ZERO ); end
  def new( initial_value=BYTES32_ZERO ) Bytes32.new( initial_value ); end 
  alias_method :create, :new     ## remove create alias - why? why not?
end


class BytesType < ValueType       ### fix: see comments above - is bytes dynamic? or frozen?
  def format() 'bytes'; end
  alias_method :to_s, :format 

  def ==(other)  other.is_a?( BytesType ); end
  def zero()  BYTES_ZERO; end
  

  def self.instance()  @instance ||= new; end

  def typedclass_name()  Bytes.name; end
  def typedclass()       Bytes;  end    
  def new_zero() Bytes.new( BYTES_ZERO ); end
  def new( initial_value=BYTES_ZERO ) Bytes.new( initial_value ); end 
  alias_method :create, :new     ## remove create alias - why? why not?
end



class BoolType < ValueType
    def format() 'bool'; end
    alias_method :to_s, :format 

    def ==(other)  other.is_a?( BoolType ); end
    def zero()   false; end
    

    def self.instance()  @instance ||= new; end

    def typedclass_name()  Bool.name; end
    def typedclass()       Bool;  end    
    def new_zero() Bool.new( false ); end
    def new( initial_value=false ) Bool.new( initial_value ); end 
    alias_method :create, :new     ## remove create alias - why? why not?
end

class UIntType < ValueType
    def format() 'uint'; end
    alias_method :to_s, :format 

    def ==(other)  other.is_a?( UIntType ); end
    def zero()   0; end
       

    def self.instance()  @instance ||= new; end

    def typedclass_name()  UInt.name; end
    def typedclass()       UInt;  end    
    def new_zero() UInt.new( 0 ); end
    def new( initial_value=0 ) UInt.new( initial_value ); end 
    alias_method :create, :new     ## remove create alias - why? why not?
end


class IntType < ValueType
    def format() 'int'; end
    alias_method :to_s, :format 

    def ==(other)  other.is_a?( IntType ); end
    def zero()   0; end
        

    def self.instance()  @instance ||= new; end

    def typedclass_name()  Int.name; end
    def typedclass()       Int;  end    
    def new_zero() Int.new( 0 ); end
    def new( initial_value=0 ) Int.new( initial_value ); end 
    alias_method :create, :new     ## remove create alias - why? why not?
end


class TimestampType < ValueType   ## note: datetime is int (epoch time since 1970 in seconds in utc)
    def format() 'timestamp'; end
    alias_method :to_s, :format 

    def ==(other)  other.is_a?( TimestampType ); end
    def zero()   0; end
        

    def self.instance()  @instance ||= new; end

    def typedclass_name()  Timestamp.name; end
    def typedclass()       Timestamp;  end    
    def new_zero() Timestamp.new( 0 ); end
    def new( initial_value=0 ) Timestamp.new( initial_value ); end 
    alias_method :create, :new     ## remove create alias - why? why not?
end 




### note:  for bool and enum use DataType or AbstractDataType (ADT)
##             values must always be from existing set (CANNOT create new values/ones)
##               all instances are immutable/frozen and shared
class EnumType < Type
  attr_reader :enum_name
  attr_reader :enum_class ## reference enum_class here - why? why not? 
  def initialize( enum_name, enum_class )
    @enum_name  = enum_name
    @enum_class = enum_class
  end
  def format
     "#{enum_name} enum(#{enum_class.keys.join(',')})" 
  end
  alias_method :to_s, :format 
  def ==(other)
    other.is_a?( EnumType ) &&
    @enum_name  == other.enum_name &&  ## check for name too - why? why not? 
    @enum_class == other.enum_class 
  end
  def zero
     ## return 0 - why? why not?
     ## or
     ##   raise NameError, "no method zero for EnumType; sorry"
     0    
  end
 

  def typedclass_name() @enum_class.name;  end
  def typedclass() @enum_class;  end
 def new_zero() @enum_class.new_zero; end 
 def new( initial_value=0 ) 
     ## allow new use here - why? why not?
     @enum_class.members[ initial_value ] 
 end 
 alias_method :create, :new     ## remove create alias - why? why not?
end



class StructType < ReferenceType
     attr_reader :struct_name
     attr_reader :struct_class ## reference struct_class here - why? why not? 
     def initialize( struct_name, struct_class )
       @struct_name  = struct_name
       @struct_class = struct_class
     end
     def format
       ## use tuple here (not struct) - why? why not?
        named_types = @struct_class.attributes.map  {|key,type| "#{key} #{type.format}" }
        "#{@struct_name} struct(#{named_types.join(',')})" 
     end
     alias_method :to_s, :format 
     def ==(other)
       other.is_a?( StructType ) &&
       @struct_name  == other.struct_name &&  ## check for name too - why? why not? 
       @struct_class == other.struct_class 
     end
     def zero
        ## return [] - why? why not?
        ## or
        ##   raise NameError, "no method zero for StructType; sorry"
        []    
     end
    

     def typedclass_name() @struct_class.name;  end
     def typedclass() @struct_class;  end
    def new_zero() @struct_class.new_zero; end 
    def new( initial_value=[] )  ## todo/check: change to values with splat - why? why not?  
         ## note: use "splat" here - must be empty or matching number of fields/attributes
         ##  change - why? why not?
        @struct_class.new( *initial_value ) 
    end 
    alias_method :create, :new     ## remove create alias - why? why not?
end # class StructType




## todo/check
##    keep (internal) contract type??
##      -  raise error on create?  
##      - check what operations to support
##      - is like address (value type??)



class ContractType < ValueType
  attr_reader :contract_type
  ## note: assume for now contract_type is a (contract) class!!!!!
  def initialize( contract_type )
    raise ArgumentError, "[ContractType#initialize] class expected for contract_type arg"  unless contract_type.is_a?( Class )
    @contract_type = contract_type
  end

  def format() "contract(#{@contract_type.name})"; end
  alias_method :to_s, :format 
 
  def ==(other)
    other.is_a?( ContractType ) && 
    @contract_type  == other.contract_type
  end

  ## fix!! double check - what to return/use here?
  def zero  
    ##  TypedMapping.new( key_type: @key_type, value_type: @value_type )    
     ## not possible??
     raise NameError, "no method zero for ContractType; sorry"
  end


  def self.instance( contract_type ) 
    raise ArgumentError, "[ContractType.insntance] class expected for contract_type arg"  unless contract_type.is_a?( Class )
    @instances ||= {}
    @instances[ contract_type.name ] ||= new( contract_type ) 
  end

   ## add support with passed in address - why? why not?    
   def new( initial_value ) 
     raise NameError, "no method create for ContractType; sorry"
   end
   alias_method :create, :new     ## remove create alias - why? why not?
end  # class ContractType


## note: use class Typed as namespace (all metatype etc. nested here - the end)
end  #  class Typed  

end  ## module Types