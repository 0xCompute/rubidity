

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
    alias_method :to_s, :format 
    def pretty_print( printer ) printer.text( "<type #{format}>" ); end

    def zero
    #    ## check/todo: what error to raise for not implemented / method not defined???
    #    raise ArgumentError, "no required zero method defined for Type subclass #{self.class.name}; sorry"
    end
    alias_method :default_value, :zero   ## keep default_value alias - why? why not?




    TYPES = [:string,  
             :address, :ethscriptionId,
             :bytes32, :bytes,
             :bool, 
             :uint256, :int256, 
             :datetime,
             :array, :mapping]
            
             
  TYPES.each do |type|  ## legacy - use classes e.g is_a?( ArrayType ) - why? why not?
     define_method( "#{type}?" ) do
         ## note: must be symbols both (symbol != string!!!)
         self.name == type
     end
  end


  def is_value_type?() is_a?( ValueType ); end    

  def self.value_types
    ## note: use shared single (type) instances
    [:string,   
     :address, :ethscriptionId,
     :bytes32,
     :bytes,   ### fix: see notes on bytes - is dynamic?? (reference value) double-check!!
     :bool,
     :uint256, :int256, 
     :datetime, 
    ]
  end
 

  def self.create( type_or_name, **kwargs )
    return type_or_name   if type_or_name.is_a?( Type )
  
    type_name = type_or_name.to_sym
  
    case type_name
    when :string                 then StringType.instance   ## share single (type) instance
    when :address                then AddressType.instance
    when :ethscriptionId         then EthscriptionIdType.instance
    when :bytes32                then Bytes32Type.instance
    when :bytes                  then BytesType.instance
    when :bool                   then BoolType.instance 
    when :uint256                then Uint256Type.instance 
    when :int256                 then Int256Type.instance 
    when :datetime               then DatetimeType.instance 
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
 

    elsif is_a?(Uint256Type)
      if literal.is_a?(String)
        literal = parse_integer(literal)
      end
        
      if literal.is_a?(Integer) && literal.between?(0, 2 ** 256 - 1)
        return literal
      end
      
      raise_type_error(literal)
    elsif is_a?( Int256Type )
      if literal.is_a?(String)
        literal = parse_integer(literal)
      end
        
      if literal.is_a?(Integer) && literal.between?(-2 ** 255, 2 ** 255 - 1)
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
    elsif is_a?( EthscriptionIdType ) || is_a?( Bytes32Type )
      unless literal.is_a?(String) && literal.match?(/\A0x[a-f0-9]{64}\z/i)
        raise_type_error(literal)
      end

      ## note: always downcase & freeze address - why? why not?
      ##  fix - fix -fix - remove CONTRACT_ZERO - use BYTES32_ZERO - why? why not?
      return literal == CONTRACT_ZERO ? literal : literal.downcase.freeze

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


    elsif is_a?( DatetimeType )
      dummy_uint = Uint256Type.instance
      
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


=begin
def ==(other)
## todo: check what to do for AddressOrDumbContract
  ##                               allow union? (e.g. Address and DumbContract) too
  ##
  ##

  if is_a?( ValueType )
     other.is_a?( self.class )
  else 
    ## note: also check for matching sub_type or key_type/value_type
    other.is_a?(self.class) && other.format == format
  end
end
=end


def hash()    [format].hash;  end    ## add Type prefix or such - why? why not?  
def eql?(other)  hash == other.hash; end  ## check eql? used for what?
end  # class Type



class ValueType < Type; end       ## add value & reference type base - why? why not?
class ReferenceType < Type; end


##
## ruby note:  is_a? and kind_of? are alias - the same
##            for "strict" checking use instance_of?()

STRING_ZERO   = ''.freeze 
class StringType < ValueType  ## note: strings are frozen / immutable - check again!!
    def name() :string; end     ## change name to type or symbol  or - why? why not???
    def format() 'string'; end
    def ==(other)  other.is_a?( StringType ); end
    def zero()  STRING_ZERO;  end    

    alias_method :to_s,          :format
    alias_method :default_value, :zero

    def self.instance()  @instance ||= new; end

    #####
    #  add create helper - why? why not?    
    def create( initial_value=STRING_ZERO ) TypedString.new( initial_value ); end 
end



ADDRESS_ZERO  = ('0x'+'0'*40).freeze
class AddressType < ValueType
    def name() :address; end
    def format() 'address'; end
    def ==(other)  other.is_a?( AddressType ); end
    def zero() ADDRESS_ZERO;  end
    
    alias_method :to_s,          :format
    alias_method :default_value, :zero
  
    def self.instance()  @instance ||= new; end

    #####
    #  add create helper - why? why not?    
    def create( initial_value=ADDRESS_ZERO ) TypedAddress.new( initial_value ); end 
end




CONTRACT_ZERO = ('0x'+'0'*64).freeze 
DUMP_CONTRACT_ZERO = DUMPCONTRACT_ZERO = CONTRACT_ZERO
ETHSCRIPTION_ID_ZERO = ETHSCRIPTIONID_ZERO = CONTRACT_ZERO

class EthscriptionIdType < ValueType      ## todo/check: rename to inscripeId or inscriptionId
    def name() :ethscriptionId; end
    def format() 'ethscriptionId'; end
    def ==(other)  other.is_a?( EthscriptionIdType ); end
    def zero()  ETHSCRIPTION_ID_ZERO; end
    
    alias_method :to_s,          :format
    alias_method :default_value, :zero

    def self.instance()  @instance ||= new; end

    #####
    #  add create helper - why? why not?    
    def create( initial_value=ETHSCRIPTION_ID_ZERO ) TypedEthscriptionId.new( initial_value ); end 
end


class Bytes32Type < ValueType  
  def name() :bytes32; end
  def format() 'bytes32'; end
  def ==(other)  other.is_a?( Bytes32Type ); end
  def zero()  ETHSCRIPTION_ID_ZERO; end
  
  alias_method :to_s,          :format
  alias_method :default_value, :zero

  def self.instance()  @instance ||= new; end

  #####
  #  add create helper - why? why not?    
  def create( initial_value=ETHSCRIPTION_ID_ZERO ) TypedBytes32.new( initial_value ); end 
end


BYTES_ZERO = String.new().freeze   ## string with binary encoding
class BytesType < ValueType       ### fix: see comments above - is bytes dynamic? or frozen?
  def name() :bytes; end
  def format() 'bytes'; end
  def ==(other)  other.is_a?( BytesType ); end
  def zero()  BYTES_ZERO; end
  
  alias_method :to_s,          :format
  alias_method :default_value, :zero

  def self.instance()  @instance ||= new; end

  #####
  #  add create helper - why? why not?    
  def create( initial_value=BYTES_ZERO ) TypedBytes.new( initial_value ); end 
end



class BoolType < ValueType
    def name() :bool; end
    def format() 'bool'; end
    def ==(other)  other.is_a?( BoolType ); end
    def zero()   false; end
    
    alias_method :to_s,          :format
    alias_method :default_value, :zero

    def self.instance()  @instance ||= new; end

    #####
    #  add create helper - why? why not?    
    def create( initial_value=false ) TypedBool.new( initial_value ); end 
end

class Uint256Type < ValueType
    def name() :uint256; end
    def format() 'uint256'; end
    def ==(other)  other.is_a?( Uint256Type ); end
    def zero()   0; end
     
    alias_method :to_s,          :format
    alias_method :default_value, :zero
   
    def self.instance()  @instance ||= new; end

    #####
    #  add create helper - why? why not?    
    def create( initial_value=0 ) TypedUint256.new( initial_value ); end 
end


class Int256Type < ValueType
    def name() :int256; end
    def format() 'int256'; end
    def ==(other)  other.is_a?( Int256Type ); end
    def zero()   0; end
        
    alias_method :to_s,          :format
    alias_method :default_value, :zero

    def self.instance()  @instance ||= new; end

    #####
    #  add create helper - why? why not?    
    def create( initial_value=0 ) TypedInt256.new( initial_value ); end 
end

class DatetimeType < ValueType   ## note: datetime is int (epoch time since 1970 in seconds in utc)
    def name() :datetime; end
    def format() 'datetime'; end
    def ==(other)  other.is_a?( DatetimeType ); end
    def zero()   0; end
        
    alias_method :to_s,          :format
    alias_method :default_value, :zero

    def self.instance()  @instance ||= new; end

    #####
    #  add create helper - why? why not?    
    def create( initial_value=0 ) TypedDatetime.new( initial_value ); end 
end 


class ArrayType < ReferenceType   ## note: dynamic array for now (NOT fixed!!!! - add FixedArray - why? why not?)
    attr_reader :sub_type
    def initialize( sub_type )
      @sub_type = sub_type
    end
    def name() :array; end
    def format() "#{@sub_type.format}[]"; end
    def ==(other)
      other.is_a?( ArrayType ) && @sub_type == other.sub_type
    end
    def zero
        ## or just return [] - why? why not?
        TypedArray.new( sub_type: @sub_type )    
    end
    
    alias_method :to_s,          :format
    alias_method :default_value, :zero

    def self.instance( sub_type ) 
       @instances ||= {}
       @instances[ sub_type.format ] ||= new(sub_type) 
    end

    #####
    #  add create helper - why? why not?    
    def create( initial_value=[] ) TypedArray.new( initial_value, sub_type: sub_type ); end 
end # class ArrayType



class MappingType < ReferenceType
    attr_reader :key_type
    attr_reader :value_type
     def initialize( key_type, value_type )
       @key_type   = key_type
       @value_type = value_type
     end
     def name() :mapping; end
     def format() "mapping(#{@key_type.format}=>#{@value_type.format})"; end
     def ==(other)
       other.is_a?( MappingType ) && 
       @key_type   == other.key_type &&
       @value_type == other.value_type 
     end
     def zero
        ## or just return {} - why? why not?
        TypedMapping.new( key_type: @key_type, value_type: @value_type )    
     end
    
     alias_method :to_s,          :format
     alias_method :default_value, :zero
 
     def self.instance( key_type, value_type ) 
        @instances ||= {}
        @instances[ key_type.format+"=>"+value_type.format ] ||= new(key_type, value_type) 
     end

    #####
    #  add create helper - why? why not?    
    def create( initial_value={} ) TypedMapping.new( initial_value, key_type: key_type,
                                                         value_type: value_type ); end 
end # class MappingType




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

  def name() :contract; end
  def format() "contract(#{@contract_type.name})"; end
 
  def ==(other)
    other.is_a?( ContractType ) && 
    @contract_type  == other.contract_type
  end

  ## fix!! double check - what to return/use here?
  def zero 
    ##  CONTRACT_ZERO; 
    ##  TypedMapping.new( key_type: @key_type, value_type: @value_type )    
     ## not possible??
     raise NameError, "no method zero for ContractType; sorry"
  end
  
  alias_method :to_s,          :format
  alias_method :default_value, :zero


  def self.instance( contract_type ) 
    raise ArgumentError, "[ContractType.insntance] class expected for contract_type arg"  unless contract_type.is_a?( Class )
    @instances ||= {}
    @instances[ contract_type.name ] ||= new( contract_type ) 
  end

#####
#  add create helper - why? why not?
   ## add support with passed in address - why? why not?    
   def create( initial_value ) 
     raise NameError, "no method create for ContractType; sorry"
   end
end  # class ContractType




