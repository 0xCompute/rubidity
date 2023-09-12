

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



    TYPES = [:string,  :address, :dumbContract,
             :addressOrDumbContract, :ethscriptionId,
             :bool, :address, :uint256, :int256, :datetime,
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
     :address,
     :dumbContract,
     :addressOrDumbContract,
     :ethscriptionId,
     :bool,
     :uint256,
     :int256, 
     :datetime, 
    ]
  end
 

  def self.create( type_or_name, **kwargs )
    return type_or_name   if type_or_name.is_a?( Type )
  
    type_name = type_or_name.to_sym
  
    case type_name
    when :string                 then StringType.instance   ## share single (type) instance
    when :address                then AddressType.instance
    when :dumbContract           then DumbContractType.instance
    when :addressOrDumbContract  then AddressOrDumbContractType.instance 
    when :ethscriptionId         then EthscriptionIdType.instance
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
    rescue ArgumentError => e
      raise_type_error(literal)
    end
  end
 


  def check_and_normalize_literal( literal )
     ### todo/check - split up and move to type classes - why? why not?

    if is_a?(AddressType)
      unless literal.is_a?(String) && literal.match?(/^0x[a-f0-9]{40}$/i)
        raise_type_error(literal)
      end
      
      ## note: always downcase & freeze address - why? why not?
      return literal == ADDRESS_ZERO ? literal : literal.downcase.freeze
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
    elsif is_a?( DumbContractType ) || is_a?( EthscriptionIdType )
      unless literal.is_a?(String) && literal.match?(/^0x[a-f0-9]{64}$/i)
        raise_type_error(literal)
      end

      ## note: always downcase & freeze address - why? why not?
      return literal == CONTRACT_ZERO ? literal : literal.downcase.freeze
    elsif is_a?( AddressOrDumbContractType )
      unless literal.is_a?(::String) && (literal.match?(/^0x[a-f0-9]{64}$/i) || literal.match?(/^0x[a-f0-9]{40}$/i))
        raise_type_error(literal)
      end

      ## note: always downcase & freeze address - why? why not?
      return [ADDRESS_ZERO, CONTRACT_ZERO].include?( literal ) ? literal : literal.downcase.freeze
    elsif is_a?( DatetimeType )
      dummy_uint = Uint256.instance
      
      begin
        return dummy_uint.check_and_normalize_literal(literal)
      rescue TypeError => e
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
    def create( value ) TypedString.new( value ); end 
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
    def create( value ) TypedAddress.new( value ); end 
end


CONTRACT_ZERO = ('0x'+'0'*64).freeze 
DUMP_CONTRACT_ZERO = DUMPCONTRACT_ZERO = CONTRACT_ZERO
ETHSCRIPTION_ID_ZERO = ETHSCRIPTIONID_ZERO = CONTRACT_ZERO
class DumbContractType < ValueType
    def name() :dumbContract; end
    def format() 'dumbContract'; end
    def ==(other)  other.is_a?( DumbContractType ); end
    def zero() CONTRACT_ZERO; end
    
    alias_method :to_s,          :format
    alias_method :default_value, :zero

    def self.instance()  @instance ||= new; end

    #####
    #  add create helper - why? why not?    
    def create( value ) TypedDumbContract.new( value ); end 
end



class AddressOrDumbContractType < ValueType  ## note: use "generic" "union" type???
    def name() :addressOrDumbContract; end
    def format() 'addressOrDumbContract'; end
   
## todo: check what to do for AddressOrDumbContract
##       allow union? (e.g. Address and DumbContract) too
##            or only AddressOrDumbContract???
      def ==(other)
        other.is_a?( AddressOrDumbContractType ) 
        ##  other.is_a?( AddressOrDumbContractType ) ||
        ##  other.is_a?( AddressType ) || 
        ##  other.is_a?( DumbContractType ) 
      end
    def zero()  ADDRESS_ZERO;  end  # note: default is address(0)
    
    alias_method :to_s,          :format
    alias_method :default_value, :zero

    def self.instance()  @instance ||= new; end

    #####
    #  add create helper - why? why not?    
    def create( value ) TypedAddressOrDumbContract.new( value ); end 
end


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
    def create( value ) TypedEthscriptionId.new( value ); end 
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
    def create( value ) TypedBool.new( value ); end 
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
    def create( value ) TypedUint256.new( value ); end 
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
    def create( value ) TypedInt256.new( value ); end 
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
    def create( value ) TypedDatetime.new( value ); end 
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
    def create( value ) TypedArray.new( value, sub_type: sub_type ); end 
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
    def create( value ) TypedMapping.new( value, key_type: key_type,
                                                 value_type: value_type ); end 
end # class MappingType
  
