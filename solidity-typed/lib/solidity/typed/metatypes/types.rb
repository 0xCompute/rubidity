
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

#######
##   global literal constants
##    add LITERAL_ eg. LITERAL_STRING_ZERO - why? why not?

STRING_ZERO          = ''.freeze             ## string with utf-8 encoding 
BYTES_ZERO           = String.new().freeze   ## string with binary encoding
BYTES20_ZERO         = ('0x'+'00'*20).freeze   ## 20 bytes (40 hexchars)  ## care about string encoding here - why? why not?
BYTES32_ZERO         = ('0x'+'00'*32).freeze   ## 32 bytes (64 hexchars)

ADDRESS_ZERO         = BYTES20_ZERO
INSCRIPTION_ID_ZERO  = INSCRIPTIONID_ZERO = BYTES32_ZERO



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

    def mut?  # is mutable (read/write)
      raise "no require mut(ability)? helper for Type subclass #{self.class.name}; sorry"
    end


#  ##  todo/check - make "dynamic" e.g. structs with all value types still value type? - why? why not?  
#  ##    check if is_value_type is used anywhere?  remove!!!! - why? why not?
#  def is_value_type?() is_a?( ValueType ); end    


  def mapping?()  is_a?( MappingType ); end
  def array?()    is_a?( ArrayType ); end
  ## add more metatype helpers here - why? why not?
 

### todo/check for minimal required methods required for
##    compare and equal support??
def ==(other)
  raise "no required == method defined for Type subclass #{self.class.name}; sorry"
end


######
## note: format MUST be unique for types
##           if self.format == other.format than same type
##   use for hash?  
##    check default eql?  is self.object_id == other.object_id ???
###     change to hash == other.hash; why? why not?

def hash()    [format].hash;  end    ## add Type prefix or such - why? why not?  
def eql?(other)  hash == other.hash; end  ## check eql? used for what?
end  # class Type


   ## use for (abstract) data types
   ##  e.g. bool, enums - why? why not?
   ##   can only (re)use constants (true|false or defined enums) 
   ##    BUT not any new values!!!! 
   class DataType < Type; end   
    
   class ValueType < Type; end       ## add value & reference type base - why? why not?

   class ReferenceType < Type; end


##
## ruby note:  is_a? and kind_of? are alias - the same
##            for "strict" checking use instance_of?


class StringType < ValueType  ## note: strings are frozen / immutable - check again!!

    def self.instance()  @instance ||= new; end


    def format() 'string'; end
    alias_method :to_s, :format 

    def ==(other)  other.is_a?( StringType ); end
   
    
    ##   note: use Types::String here to avoid confusion with ::String - why? why not?
    ### -fix-fix-fix- remove typedclass for "primitives" - used anywhere - why? why not?
    def typedclass_name()  Types::String.name; end
    def typedclass()       Types::String;  end
   
    def mut?()  false; end
    def zero() Types::String.zero;  end
    alias_method :new_zero, :zero   ## add/keep (convenience) alias for new_zero - why? why not?
    def new( initial_value ) Types::String.new( initial_value ); end 
end



class AddressType < ValueType
 
    def self.instance()  @instance ||= new; end

    def format() 'address'; end
    alias_method :to_s, :format 

    def ==(other)  other.is_a?( AddressType ); end
     
    def typedclass_name()  Address.name; end
    def typedclass()       Address;  end

    def mut?() false; end
    def zero() Address.zero; end
    alias_method :new_zero, :zero   ## add/keep (convenience) alias for new_zero - why? why not?
    def new( initial_value ) Address.new( initial_value ); end 
end




class InscriptionIdType < ValueType      ## todo/check: rename to inscripeId or inscriptionId

    def self.instance()  @instance ||= new; end

    def format() 'inscriptionId'; end
    alias_method :to_s, :format 

    def ==(other)  other.is_a?( InscriptionIdType ); end
      
    def typedclass_name()  InscriptionId.name; end
    def typedclass()       InscriptionId;  end    

    def mut?() false; end
    def zero() InscriptionId.zero; end
    alias_method :new_zero, :zero   ## add/keep (convenience) alias for new_zero - why? why not?
    def new( initial_value ) InscriptionId.new( initial_value ); end 
end


class Bytes32Type < ValueType  
  def self.instance()  @instance ||= new; end


  def format() 'bytes32'; end
  alias_method :to_s, :format 

  def ==(other)  other.is_a?( Bytes32Type ); end
 
  
  def typedclass_name()  Bytes32.name; end
  def typedclass()       Bytes32;  end    

  def mut?() false; end
  def zero() Bytes32.zero; end
  alias_method :new_zero, :zero   ## add/keep (convenience) alias for new_zero - why? why not?
  def new( initial_value ) Bytes32.new( initial_value ); end 
end


class BytesType < ValueType       ### fix: see comments above - is bytes dynamic? or frozen?
  def self.instance()  @instance ||= new; end

  def format() 'bytes'; end
  alias_method :to_s, :format 

  def ==(other)  other.is_a?( BytesType ); end
  
  def typedclass_name()  Bytes.name; end
  def typedclass()       Bytes;  end    

  def mut?() false; end
  def zero() Bytes.zero; end
  alias_method :new_zero, :zero   ## add/keep (convenience) alias for new_zero - why? why not?
  def new( initial_value ) Bytes.new( initial_value ); end 
end


class UIntType < ValueType
    def self.instance()  @instance ||= new; end

    def format() 'uint'; end
    alias_method :to_s, :format 
    
    ## note abi requires uint256!!! (not uint)
    ## todo/check - rename to sig or abisig or selector or ???
    def abi() 'uint256'; end

    def ==(other)  other.is_a?( UIntType ); end
       

    def typedclass_name()  UInt.name; end
    def typedclass()       UInt;  end    
  
    def mut?() false; end
    def zero() UInt.zero; end
    alias_method :new_zero, :zero   ## add/keep (convenience) alias for new_zero - why? why not?
    def new( initial_value ) UInt.new( initial_value ); end 
end


class IntType < ValueType
    def self.instance()  @instance ||= new; end

    def format() 'int'; end
    alias_method :to_s, :format 

    ## note abi requires uint256!!! (not uint)
    ## todo/check - rename to sig or abisig or selector or ???
    def abi() 'int256'; end


    def ==(other)  other.is_a?( IntType ); end
        

    def typedclass_name()  Int.name; end
    def typedclass()       Int;  end   

    def mut?() false; end
    def zero() Int.zero; end
    alias_method :new_zero, :zero   ## add/keep (convenience) alias for new_zero - why? why not?
    def new( initial_value ) Int.new( initial_value ); end 
end


class TimestampType < ValueType   ## note: datetime is int (epoch time since 1970 in seconds in utc)
    def self.instance()  @instance ||= new; end

    def format() 'timestamp'; end
    alias_method :to_s, :format 

    ## check for abi sig format is it uint32 ???

    def ==(other)  other.is_a?( TimestampType ); end
        

    def typedclass_name()  Timestamp.name; end
    def typedclass()       Timestamp;  end    

    def mut?() false; end
    def zero() Timestamp.zero; end
    alias_method :new_zero, :zero   ## add/keep (convenience) alias for new_zero - why? why not?
    def new( initial_value ) Timestamp.new( initial_value ); end 
end 


class TimedeltaType < ValueType   
  def self.instance()  @instance ||= new; end

  def format() 'timedelta'; end
  alias_method :to_s, :format 

  def ==(other)  other.is_a?( TimedeltaType ); end
      

  def typedclass_name()  Timedelta.name; end
  def typedclass()       Timedelta;  end    

  def mut?()  false; end
  def zero() Timedelta.zero; end
  alias_method :new_zero, :zero   ## add/keep (convenience) alias for new_zero - why? why not?
  def new( initial_value ) Timedelta.new( initial_value ); end 
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

  ## note abi requires uint8!!! 0-255 (8bit)
  ## todo/check - rename to sig or abisig or selector or ???
  def abi()  'uint8'; end


  def ==(other)
    other.is_a?( EnumType ) &&
    @enum_name  == other.enum_name &&  ## check for name too - why? why not? 
    @enum_class == other.enum_class 
  end


  def typedclass_name() @enum_class.name;  end
  def typedclass() @enum_class;  end

  def mut?() false; end
  def zero() @enum_class.zero;  end 
  alias_method :new_zero, :zero   ## add/keep (convenience) alias for new_zero - why? why not?
  def new( initial_value ) 
     ## allow new use here - why? why not?
     @enum_class.members[ initial_value ] 
  end 
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


     ### note: abi requires "tuple()"
     def abi
      types = @struct_class.attributes.map  {|_,type| type.abi }
      "tuples(#{types.join(',')})" 
     end

     def ==(other)
       other.is_a?( StructType ) &&
       @struct_name  == other.struct_name &&  ## check for name too - why? why not? 
       @struct_class == other.struct_class 
     end
    

     def typedclass_name() @struct_class.name;  end
     def typedclass() @struct_class;  end
    
     ## note: mut? == true MUST use new_zero (dup)
     ##       mut? == false MUST use zero (frozen/shared/singelton)
     def mut?() true; end
     def new_zero() @struct_class.new_zero; end 
     def new( initial_values )  ## todo/check: change to values with splat - why? why not?  
         ## note: use "splat" here - must be empty or matching number of fields/attributes
         ##  change - why? why not?
        @struct_class.new( *initial_values ) 
     end 
end # class StructType



###
#  event for now kind of like a struct - why? why not?
##    but MUST be initialized (and than frozen) 
##    and no zero possible etc.

class EventType < ReferenceType
  attr_reader :event_name
  attr_reader :event_class ## reference event_class here - why? why not? 
  def initialize( event_name, event_class )
    @event_name  = event_name
    @event_class = event_class
  end
  def format
    ## use tuple here (not event) - why? why not?
     named_types = @event_class.attributes.map  {|key,type| "#{key} #{type.format}" }
     "#{@event_name} event(#{named_types.join(',')})" 
  end
  alias_method :to_s, :format 

  ## check what abi looks like if possible for event
  ##                  is like tuple?

  def ==(other)
    other.is_a?( EventType ) &&
    @event_name  == other.event_name &&  ## check for name too - why? why not? 
    @event_class == other.event_class 
  end
 

  def typedclass_name() @event_class.name;  end
  def typedclass() @event_class;  end
 
  ## note: mut? == true MUST use new_zero (dup)
  ##       mut? == false MUST use zero (frozen/shared/singelton)
  def mut?() false; end
  def zero
    raise "event cannot be zero (by defintion); sorry"
  end
  alias_method :new_zero, :zero 

  def new( initial_values )  ## todo/check: change to values with splat - why? why not?  
      ## note: use "splat" here - must be empty or matching number of fields/attributes
      ##  change - why? why not?
     @event_class.new( *initial_values ) 
  end 
end # class EventType



###
#  error for now kind of like a struct - why? why not?
##    but MUST be initialized (and than frozen) 
##    and no zero possible etc.

class ErrorType < ReferenceType
  attr_reader :error_name
  attr_reader :error_class ## reference error_class here - why? why not? 
  def initialize( error_name, error_class )
    @error_name  = error_name
    @error_class = error_class
  end
  def format
    ## use tuple here (not error) - why? why not?
     named_types = @error_class.attributes.map  {|key,type| "#{key} #{type.format}" }
     "#{@error_name} error(#{named_types.join(',')})" 
  end
  alias_method :to_s, :format 

  ## check what abi looks like if possible for error
  ##                  is like tuple?

  def ==(other)
    other.is_a?( ErrorType ) &&
    @error_name  == other.error_name &&  ## check for name too - why? why not? 
    @error_class == other.error_class 
  end
 

  def typedclass_name() @error_class.name;  end
  def typedclass() @error_class;  end
 
  ## note: mut? == true MUST use new_zero (dup)
  ##       mut? == false MUST use zero (frozen/shared/singelton)
  def mut?() false; end
  def zero
    raise "error cannot be zero (by defintion); sorry"
  end
  alias_method :new_zero, :zero 

  def new( initial_values )  ## todo/check: change to values with splat - why? why not?  
      ## note: use "splat" here - must be empty or matching number of fields/attributes
      ##  change - why? why not?
     @error_class.new( *initial_values ) 
  end 
end # class ErrorType











## todo/check
##    keep (internal) contract type??
##      -  raise error on create?  
##      - check what operations to support
##      - is like address (value type??)



class ContractType < ValueType

  def self.instance( contract_type ) 
    raise ArgumentError, "[ContractType.insntance] class expected for contract_type arg"  unless contract_type.is_a?( Class )
    @instances ||= {}
    @instances[ contract_type.name ] ||= new( contract_type ) 
  end

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

 
   def mut?() false; end
   ## add support with passed in address - why? why not?    
   def new( initial_value ) 
     raise NameError, "no method create for ContractType; sorry"
   end
end  # class ContractType


## note: use class Typed as namespace (all metatype etc. nested here - the end)
end  #  class Typed  

end  ## module Types
