

## note:
##   make bytes a reference type?
##     bytes NOT like string frozen?
##    more like a stringbuffer / bytesbuffer - 
##   double check if "in-place" updates to value possible!!!



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



  def self.create( type_or_name, **kwargs )
    return type_or_name   if type_or_name.is_a?( Type )
  
    type_name = type_or_name.to_sym
  
    case type_name
    when :string                 then StringType.instance   ## share single (type) instance
    when :address                then AddressType.instance
    when :inscriptionId          then InscriptionIdType.instance
    when :bytes32                then Bytes32Type.instance
    when :bytes                  then BytesType.instance
    when :bool                   then BoolType.instance 
    when :uint                   then UIntType.instance 
    when :int                    then IntType.instance 
    when :timestamp              then TimestampType.instance 
    when :array
      ## todo: fix - find metadata format
      sub_type = create( kwargs[:sub_type] )  
      ArrayType.instance( sub_type )
    when :mapping 
      # e.g. mapping ({ addressOrDumbContract: :uint256 }), :public, :balanceOf    
      key_type  =  create( kwargs[:key_type] )
      value_type = create( kwargs[:value_type] )
      MappingType.instance( key_type, value_type )
    else
      raise ArgumentError, "unknown type #{type_name}; sorry"
    end    
  end


 
  def raise_type_error(literal)
    ## change to typeerror or such - why? why not?
    raise TypeError, "expected type #{self.format}; got #{literal.inspect}"
  end


  def parse_integer(literal)
    base = literal.start_with?( '0x' ) ? 16 : 10
    
    begin
      Integer(literal, base)
    rescue ArgumentError 
      raise_type_error( literal )
    end
  end


  def check_and_normalize_literal( literal )
     ### todo/check - split up and move to type classes - why? why not?

## fix fix fix:  allow typed passed in as literals here?
##    if literal.is_a?(TypedVariable)
##     raise TypeError, "Only literals can be passed to check_and_normalize_literal: #{literal.inspect}"
##    end


    if is_a?(AddressType)
 ##  fix fix fix: add contract support     
 #     if literal.is_a?(ContractType::Proxy)
 #       return literal.address
 #     end
 
      unless literal.is_a?(String) && literal.match?(/\A0x[a-f0-9]{40}\z/i)
        raise_type_error(literal)
      end
      
      ## note: always downcase & freeze address - why? why not?
      return literal == ADDRESS_ZERO ? literal : literal.downcase.freeze
    elsif is_a?( ContractType )  
      ## elsif is_contract_type?
      ##   uses in original. 
      ##     def is_contract_type?
      ##       ContractImplementation.valid_contract_types.include?(name)
      ##     end
    
      ## todo/check - use a different base class for contracts - why? why not?
      ##   fix fix fix: check matching contract type/class too - why? why not?
       if literal.is_a?( ContractBase )
         return literal
       else
         raise TypeError, "No literals allowed for contract types  got: #{literal}; sorry"
       end
 

    elsif is_a?(UIntType)
      if literal.is_a?(String)
        literal = parse_integer(literal)
      end
        
      if literal.is_a?(Integer) && literal.between?(0, 2 ** 256 - 1)
        return literal
      end
      
      raise_type_error(literal)
    elsif is_a?( IntType )
      if literal.is_a?(String)
        literal = parse_integer(literal)
      end
        
      if literal.is_a?(Integer) && literal.between?(-2 ** 255, 2 ** 255 - 1)
        return literal
      end
      
      raise_type_error(literal)
    elsif is_a?( EnumType )
       if literal.is_a?( Integer )  ## todo - check literal is withing min/max
          return literal
       end
       raise_type_error(literal)
    elsif is_a?( StringType )
      unless literal.is_a?(String)
        raise_type_error(literal)
      end
      
      return literal.freeze
    elsif is_a?( BoolType )
      unless literal == true || literal == false
        raise_type_error(literal)
      end
      
      return literal
    elsif is_a?( InscriptionIdType ) || is_a?( Bytes32Type )
      unless literal.is_a?(String) && literal.match?(/\A0x[a-f0-9]{64}\z/i)
        raise_type_error(literal)
      end

      ## note: always downcase & freeze address - why? why not?
      ##   fix-fix-fix - check - use BYTES32_ZERO - why? why not?
      return literal == INSCRIPTION_ID_ZERO ? literal : literal.downcase.freeze

    elsif is_a?( BytesType )
      ## note:  assume empty string is bytes literal!!!
      if literal.is_a?(String) && literal.length == 0
        return literal
      end
      
      unless literal.is_a?(String) && 
              literal.match?(/\A0x[a-fA-F0-9]*\z/)  && 
              literal.size.even?
        raise_type_error( literal )
      end
      
      ##
      ##  check if dynamic? (like bytebuffer) - freeze? why? why not?
      return literal.downcase


    elsif is_a?( TimestampType )
      dummy_uint = UIntType.instance
      
      begin
        return dummy_uint.check_and_normalize_literal(literal)
      rescue TypeError   ## TypeError => e
        raise_type_error(literal)
      end
    elsif is_a?( MappingType )
      if literal.is_a?(TypedMapping)   ## todo - check if possible (literal) typed mapping
        return literal    
      end
 
      unless literal.is_a?(Hash)
        raise_type_error(literal)
      end
      
      ## add types (wrap literal in types)
      ## todo - do a quick check - if hash populated with vars - why? why not?
      ## todo/fix: check for nested arrays/mappings!!!
      ##    do NOT wrap in SafeMapping/SafeArray
      data = literal.map do |key, value|
        [
          key_type.check_and_normalize_literal( key ),
          value_type.check_and_normalize_literal( value )
        ]
      end.to_h

      return data
    elsif is_a?( ArrayType )  
      
      ## todo/fix: check for matching sub_type!!!!
      ## check if possible to get TypedArray passed in as literal!!!
      if literal.is_a?(TypedArray)
        return literal    ## .data   ## note: return nested (inside) data e.g. array!!!
      end
      
      unless literal.is_a?(Array)
        raise_type_error(literal)
      end
      
      ## check types only - wrap literal in types - why? why not?
      data = literal.map do |value|
        sub_type.check_and_normalize_literal( value )
      end

      return data    
    end


    raise TypeError, "invalid type; expected #{self.format}; got #{literal.inspect}"
  end

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

    
    ## todo: return "shared" TypedString zero - why? why not?
    def typedclass_name()  TypedString.name; end
    def typedclass()       TypedString;  end
    def new_zero()   TypedString.new( STRING_ZERO ); end
    def new( initial_value=STRING_ZERO ) TypedString.new( initial_value ); end 
    alias_method :create, :new     ## remove create alias - why? why not?
end



class AddressType < ValueType
    def format() 'address'; end
    alias_method :to_s, :format 

    def ==(other)  other.is_a?( AddressType ); end
    def zero() ADDRESS_ZERO;  end
    
 
    def self.instance()  @instance ||= new; end
 
    ## todo: return "shared" TypedAddress zero - why? why not?
    def typedclass_name()  TypedAddress.name; end
    def typedclass()       TypedAddress;  end
    def new_zero() TypedAddress.new( ADDRESS_ZERO ); end
    def new( initial_value=ADDRESS_ZERO ) TypedAddress.new( initial_value ); end 
    alias_method :create, :new     ## remove create alias - why? why not?
end



class InscriptionIdType < ValueType      ## todo/check: rename to inscripeId or inscriptionId
    def format() 'inscriptionId'; end
    alias_method :to_s, :format 

    def ==(other)  other.is_a?( InscriptionIdType ); end
    def zero()  INSCRIPTION_ID_ZERO; end
 
    
    def self.instance()  @instance ||= new; end
 
    def typedclass_name()  TypedInscriptionId.name; end
    def typedclass()       TypedInscriptionId;  end    
    def new_zero() TypedInscriptionId.new( INSCRIPTION_ID_ZERO ); end
    def new( initial_value=INSCRIPTION_ID_ZERO ) TypedInscriptionId.new( initial_value ); end 
    alias_method :create, :new     ## remove create alias - why? why not?
end


class Bytes32Type < ValueType  
  def format() 'bytes32'; end
  alias_method :to_s, :format 

  def ==(other)  other.is_a?( Bytes32Type ); end
  def zero()  BYTES32_ZERO; end

  
  def self.instance()  @instance ||= new; end

  def typedclass_name()  TypedBytes32.name; end
  def typedclass()       TypedBytes32;  end    
  def new_zero() TypedBytes32.new( BYTES32_ZERO ); end
  def new( initial_value=BYTES32_ZERO ) TypedBytes32.new( initial_value ); end 
  alias_method :create, :new     ## remove create alias - why? why not?
end


class BytesType < ValueType       ### fix: see comments above - is bytes dynamic? or frozen?
  def format() 'bytes'; end
  alias_method :to_s, :format 

  def ==(other)  other.is_a?( BytesType ); end
  def zero()  BYTES_ZERO; end
  

  def self.instance()  @instance ||= new; end

  def typedclass_name()  TypedBytes.name; end
  def typedclass()       TypedBytes;  end    
  def new_zero() TypedBytes.new( BYTES_ZERO ); end
  def new( initial_value=BYTES_ZERO ) TypedBytes.new( initial_value ); end 
  alias_method :create, :new     ## remove create alias - why? why not?
end



class BoolType < ValueType
    def format() 'bool'; end
    alias_method :to_s, :format 

    def ==(other)  other.is_a?( BoolType ); end
    def zero()   false; end
    

    def self.instance()  @instance ||= new; end

    def typedclass_name()  TypedBool.name; end
    def typedclass()       TypedBool;  end    
    def new_zero() TypedBool.new( false ); end
    def new( initial_value=false ) TypedBool.new( initial_value ); end 
    alias_method :create, :new     ## remove create alias - why? why not?
end

class UIntType < ValueType
    def format() 'uint'; end
    alias_method :to_s, :format 

    def ==(other)  other.is_a?( UIntType ); end
    def zero()   0; end
       

    def self.instance()  @instance ||= new; end

    def typedclass_name()  TypedUInt.name; end
    def typedclass()       TypedUInt;  end    
    def new_zero() TypedUInt.new( 0 ); end
    def new( initial_value=0 ) TypedUInt.new( initial_value ); end 
    alias_method :create, :new     ## remove create alias - why? why not?
end


class IntType < ValueType
    def format() 'int'; end
    alias_method :to_s, :format 

    def ==(other)  other.is_a?( IntType ); end
    def zero()   0; end
        

    def self.instance()  @instance ||= new; end

    def typedclass_name()  TypedInt.name; end
    def typedclass()       TypedInt;  end    
    def new_zero() TypedInt.new( 0 ); end
    def new( initial_value=0 ) TypedInt.new( initial_value ); end 
    alias_method :create, :new     ## remove create alias - why? why not?
end


class TimestampType < ValueType   ## note: datetime is int (epoch time since 1970 in seconds in utc)
    def format() 'timestamp'; end
    alias_method :to_s, :format 

    def ==(other)  other.is_a?( TimestampType ); end
    def zero()   0; end
        

    def self.instance()  @instance ||= new; end

    def typedclass_name()  TypedTimestamp.name; end
    def typedclass()       TypedTimestamp;  end    
    def new_zero() TypedTimestamp.new( 0 ); end
    def new( initial_value=0 ) TypedTimestamp.new( initial_value ); end 
    alias_method :create, :new     ## remove create alias - why? why not?
end 



class ArrayType < ReferenceType   ## note: dynamic array for now (NOT fixed!!!! - add FixedArray - why? why not?)
    attr_reader :sub_type
    def initialize( sub_type )
      @sub_type = sub_type
    end
    def format() "#{@sub_type.format}[]"; end
    alias_method :to_s, :format 

    def ==(other)
      other.is_a?( ArrayType ) && @sub_type == other.sub_type
    end
    def zero
        ## return [] - why? why not?
        []    
    end
    
    def self.instance( sub_type ) 
       raise ArgumentError, "[ArrayType.instance] sub_type not a type - got #{sub_type}; sorry" unless sub_type.is_a?( Type )
       @instances ||= {}
       @instances[ sub_type.format ] ||= new(sub_type) 
    end

    def typedclass_name
      ## return/use symbol (not string here) - why? why not?
      ##  or use TypedArrayOf<sub-type.typedclass_name>  - why? why not?
      sub_name = _sanitize_class_name( sub_type.typedclass_name )
      "TypedArray‹#{sub_name}›"
    end
    def typedclass()  TypedArray.const_get( typedclass_name ); end
    def new_zero()   typedclass.new( [] ); end  
    def new( initial_value=[] ) typedclass.new( initial_value ); end 
    alias_method :create, :new     ## remove create alias - why? why not?
end # class ArrayType


def _sanitize_class_name( name )
  name = name.sub( /\bContractBase::/, '' )   ## remove contract module from name if present
  name = name.sub( /\bTypedArray::/, '' )
  name = name.sub( /\bTypedMapping::/, '' )
  name = name.gsub( '::', '' )                ## remove module separator if present
  name
end


class MappingType < ReferenceType
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
    

     def self.instance( key_type, value_type ) 
        raise ArgumentError, "[MappingType.instance] key_type not a type - got #{key_type}; sorry" unless key_type.is_a?( Type )
        raise ArgumentError, "[MappingType.instance] value_type not a type - got #{value_type}; sorry" unless value_type.is_a?( Type )
        @instances ||= {}
        @instances[ key_type.format+"=>"+value_type.format ] ||= new(key_type, value_type) 
     end

     def typedclass_name
      ## return/use symbol (not string here) - why? why not?
      ##  or use TypedMappingOf<key-type.typedclass_name><value_type...>  - why? why not?
      key_name   = _sanitize_class_name( key_type.typedclass_name )
      value_name = _sanitize_class_name( value_type.typedclass_name )
      "TypedMapping‹#{key_name}→#{value_name}›"
    end
    def typedclass()  TypedMapping.const_get( typedclass_name ); end
    def new_zero() typedclass.new( {} ); end 
    def new( initial_value={} ) typedclass.new( initial_value ); end 
    alias_method :create, :new     ## remove create alias - why? why not?
end # class MappingType



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

