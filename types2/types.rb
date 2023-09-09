

class Type
    def format
        ## check/todo: what error to raise for not implemented / method not defined???
        raise ArgumentError, "no required format method defined for Type subclass #{self.class.name}; sorry"
    end   
    
 
    TYPES = [:string, :mapping, :address, :dumbContract,
             :addressOrDumbContract, :ethscriptionId,
             :bool, :address, :uint256, :int256, :array, :datetime]

             
  TYPES.each do |type|  ## legacy - use classes e.g is_a?( ArrayType ) - why? why not?
     define_method( "#{type}?" ) do
         ## note: must be symbols both (symbol != string!!!)
         self.name.to_sym == type
     end
  end


  def is_value_type?() !is_a?( ArrayType ) && !is_a?( MappingType ); end    


  def self.value_types
    ## note: use shared single (type) instances
    [StringType.instance,   
     AddressType.instance,
     DumbContractType.instance,
     AddressOrDumbContractType.instance,
     EthscriptionIdType.instance,
     BoolType.instance,
     Uint256Type.instance,
     Int256Type.instance, 
     DatetimeType.instance, 
    ]
  end
 

  def self.create( type_or_name, **kwargs )
    return type_or_name   if type_or_name.is_a?( Type )
  
    type_name = type_or_name.to_sym
  
    case type_name
    when :string  
      StringType.instance   ## share single (type) instance
    when :address  
      AddressType.instance
    when :dumbContract    
      DumbContractType.instance
    when :addressOrDumbContract
      AddressOrDumbContractType.instance 
    when :ethscriptionId
      EthscriptionIdType.instance
    when :bool
      BoolType.instance 
    when :uint256
      Uint256Type.instance 
    when :int256
      Int256Type.instance 
    when :datetime
       DatetimeType.instance 
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
      raise ArgumentError, "Invalid Type #{type_name}; sorry"
    end    
  end




 
  def raise_variable_type_error(literal)
    ## change to typeerror or such - why? why not?
    msg = "Invalid #{self}: #{literal.inspect}"
    raise ArgumentError, msg
  end

  def parse_integer(literal)
    base = literal.start_with?("0x") ? 16 : 10
    
    begin
      Integer(literal, base)
    rescue ArgumentError => e
      raise_variable_type_error(literal)
    end
  end
 


  def check_and_normalize_literal( literal )
    if is_a?(AddressType)
      unless literal.is_a?(String) && literal.match?(/^0x[a-f0-9]{40}$/i)
        raise_variable_type_error(literal)
      end
      
      return literal.downcase
    elsif is_a?(Uint256Type)
      if literal.is_a?(String)
        literal = parse_integer(literal)
      end
        
      if literal.is_a?(Integer) && literal.between?(0, 2 ** 256 - 1)
        return literal
      end
      
      raise_variable_type_error(literal)
    elsif is_a?( Int256Type )
      if literal.is_a?(String)
        literal = parse_integer(literal)
      end
        
      if literal.is_a?(Integer) && literal.between?(-2 ** 255, 2 ** 255 - 1)
        return literal
      end
      
      raise_variable_type_error(literal)
    elsif is_a?( StringType )
      unless literal.is_a?(String)
        raise_variable_type_error(literal)
      end
      
      return literal.freeze
    elsif is_a?( BoolType )
      unless literal == true || literal == false
        raise_variable_type_error(literal)
      end
      
      return literal
    elsif is_a?( DumbContractType ) || is_a?( EthscriptionIdType )
      unless literal.is_a?(String) && literal.match?(/^0x[a-f0-9]{64}$/i)
        raise_variable_type_error(literal)
      end
      
      return literal.downcase
    elsif is_a?( AddressOrDumbContractType )
      unless literal.is_a?(::String) && (literal.match?(/^0x[a-f0-9]{64}$/i) || literal.match?(/^0x[a-f0-9]{40}$/i))
        raise_variable_type_error(literal)
      end
      
      return literal.downcase
    elsif is_a?( DatetimeType )
      dummy_uint = Uint256.instance
      
      begin
        return dummy_uint.check_and_normalize_literal(literal)
      rescue VariableTypeError => e
        raise_variable_type_error(literal)
      end
    elsif is_a?( MappingType )
      if literal.is_a?(SafeMapping)
        return literal    ## .data  ## note: return nested (inside) data e.g. hash!!!
      end
 
      unless literal.is_a?(Hash)
        raise ArgumentError, "invalid #{literal}"
      end
      
      ## add types (wrap literal in types)
      ## todo - do a quick check - if hash populated with vars - why? why not?
      ## todo/fix: check for nested arrays/mappings!!!
      ##    do NOT wrap in SafeMapping/SafeArray
      data = literal.map do |key, value|
        [
          keytype.check_and_normalize_literal( key ),
          valuetype.check_and_normalize_literal( value )
        ]
      end.to_h

      proxy =  SafeMapping.new( data, key_type: key_type, 
                                      value_type: value_type )
       return proxy
    elsif is_a?( ArrayType )   
      if literal.is_a?(SafeArray)
        return literal    ## .data   ## note: return nested (inside) data e.g. array!!!
      end
      
      unless literal.is_a?(Array)
        raise_variable_type_error(literal)
      end
      
      ## add types (wrap literal in types)
      data = literal.map do |value|
        subtype.check_and_normalize_literal( value )
      end

      proxy = SafeArray.new( data, sub_type: sub_type ) 
      return proxy
    end
    
    raise ArgumentError, "Unknown type #{self.inspect}: #{literal.inspect}"
  end
end  # class Type





class StringType < Type
    def name() 'string'; end
    def format() 'string'; end
    def ==(another_type)  another_type.kind_of?( StringType ); end
    def default_value()  ''; end
    def self.instance()  @instance ||= new; end
end


class AddressType < Type
    def name() 'address'; end
    def format() 'address'; end
    def ==(another_type)  another_type.kind_of?( AddressType ); end
    def default_value()   '0x'+'0'*40; end
    def self.instance()  @instance ||= new; end
end

class DumbContractType < Type
    def name() 'dumbContract'; end
    def format() 'dumbContract'; end
    def ==(another_type)  another_type.kind_of?( DumbContractType ); end
    def default_value()   '0x'+'0'*64; end
    def self.instance()  @instance ||= new; end
end

class AddressOrDumbContractType < Type  ## note: use "generic" "union" type???
    def name() 'addressOrDumbContract'; end
    def format() 'addressOrDumbContract'; end
    def ==(another_type)  another_type.kind_of?( AddressType ) || another_type.kind_of?( DumbContractType ); end
    def default_value()   '0x'+'0'*40; end  # note: default is address(0)
    def self.instance()  @instance ||= new; end
end

class EthscriptionIdType < Type      ## todo/check: rename to inscripeId or inscriptionId
    def name() 'ethscriptionId'; end
    def format() 'ethscriptionId'; end
    def ==(another_type)  another_type.kind_of?( EthscriptionIdType ); end
    def default_value()   '0x'+'0'*64; end
    def self.instance()  @instance ||= new; end
end


class BoolType < Type
    def name() 'bool'; end
    def format() 'bool'; end
    def ==(another_type)  another_type.kind_of?( BoolType ); end
    def default_value()   false; end
    def self.instance()  @instance ||= new; end
end

class Uint256Type < Type
    def name() 'uint256'; end
    def format() 'uint256'; end
    def ==(another_type)  another_type.kind_of?( Uint256Type ); end
    def default_value()   0; end
    def self.instance()  @instance ||= new; end
end

class Int256Type < Type
    def name() 'int256'; end
    def format() 'int256'; end
    def ==(another_type)  another_type.kind_of?( Int256Type ); end
    def default_value()   0; end
    def self.instance()  @instance ||= new; end
end

class DatetimeType < Type   ## note: datetime is int (epoch time since 1970 in seconds in utc)
    def name() 'datetime'; end
    def format() 'datetime'; end
    def ==(another_type)  another_type.kind_of?( DatetimeType ); end
    def default_value()   0; end
    def self.instance()  @instance ||= new; end
end 


class ArrayType < Type   ## note: dynamic array for now (NOT fixed!!!! - add FixedArray - why? why not?)
    attr_reader :sub_type
    def initialize( sub_type )
      @sub_type = sub_type
    end
    def name() 'array'; end
    def format() "#{@sub_type.format}[]"; end
    def ==(another_type)
      another_type.kind_of?( ArrayType ) && @sub_type == another_type.sub_type
    end
    def default_value
        ## or just return [] - why? why not?
        SafeArray.new( sub_type: @sub_type )     
    end
    def self.instance( sub_type ) 
       @instances ||= {}
       @instances[ sub_type.format ] ||= new(sub_type) 
    end
end # class ArrayType



class MappingType < Type
    attr_reader :key_type
    attr_reader :value_type
     def initialize( key_type, value_type )
       @key_type   = key_type
       @value_type = value_type
     end
     def name() 'mapping'; end
     def format() "mapping(#{@key_type.format}=>#{@value_type.format})"; end
     def ==(another_type)
       another_type.kind_of?( MappingType ) && 
       @key_type   == another_type.key_type &&
       @value_type == another_type.value_type 
     end
     def default_value 
        ## or just return {} - why? why not?
        SafeMapping.new( key_type: @key_type, value_type: @value_type )    
     end
     def self.instance( key_type, value_type ) 
        @instances ||= {}
        @instances[ key_type.format+"=>"+value_type.format ] ||= new(key_type, value_type) 
     end
end # class MappingType



__END__

  attr_accessor :name, :metadata, :key_type, :value_type
  
  
  TYPES.each do |type|
    define_method("#{type}?") do
      self.name == type
    end
  end
  
  def self.value_types
    TYPES.select do |type|
      create(type).is_value_type?
    end
  end
  
  def initialize(type_name, metadata = {})
    type_name = type_name.to_sym
    
    if TYPES.exclude?(type_name)
      raise "Invalid type #{type_name}"
    end
    
    self.name = type_name.to_sym
    self.metadata = metadata
  end
  
  def self.create(type_or_name, metadata = {})
    return type_or_name if type_or_name.is_a?(self)
    
    new(type_or_name, metadata)
  end
  
  def key_type=(type)
    return if type.nil?
    @key_type = self.class.create(type)
  end
  
  def value_type=(type)
    return if type.nil?
    @value_type = self.class.create(type)
  end
  
  def metadata=(metadata)
    self.key_type = metadata[:key_type]
    self.value_type = metadata[:value_type]
  end
  
  def metadata
    { key_type: key_type, value_type: value_type }
  end
  
  def to_s
    name.to_s
  end
  
  def default_value
    is_int256_uint256_datetime = int256? || uint256? || datetime?
    is_addressOrDumbContract = address? || addressOrDumbContract?
    is_dumbContract_ethscriptionId = dumbContract? || ethscriptionId?
  
    val = case
    when is_int256_uint256_datetime
      0
    when is_addressOrDumbContract
      "0x" + "0" * 40
    when is_dumbContract_ethscriptionId
      "0x" + "0" * 64
    when string?
      ''
    when bool?
      false
    when mapping?
      MappingType::Proxy.new(key_type: key_type, value_type: value_type)
    when array?
      ArrayType::Proxy.new(value_type: value_type)
    else
      raise "Unknown default value for #{self.inspect}"
    end
    
    check_and_normalize_literal(val)
  end
  
  def raise_variable_type_error(literal)
    raise VariableTypeError.new("Invalid #{self}: #{literal.inspect}")
  end
  
  def parse_integer(literal)
    base = literal.start_with?("0x") ? 16 : 10
    
    begin
      Integer(literal, base)
    rescue ArgumentError => e
      raise_variable_type_error(literal)
    end
  end
  
  def check_and_normalize_literal(literal)
    if address?
      unless literal.is_a?(String) && literal.match?(/^0x[a-f0-9]{40}$/i)
        raise_variable_type_error(literal)
      end
      
      return literal.downcase
    elsif uint256?
      if literal.is_a?(String)
        literal = parse_integer(literal)
      end
        
      if literal.is_a?(Integer) && literal.between?(0, 2 ** 256 - 1)
        return literal
      end
      
      raise_variable_type_error(literal)
    elsif int256?
      if literal.is_a?(String)
        literal = parse_integer(literal)
      end
        
      if literal.is_a?(Integer) && literal.between?(-2 ** 255, 2 ** 255 - 1)
        return literal
      end
      
      raise_variable_type_error(literal)
    elsif string?
      unless literal.is_a?(String)
        raise_variable_type_error(literal)
      end
      
      return literal.freeze
    elsif bool?
      unless literal == true || literal == false
        raise_variable_type_error(literal)
      end
      
      return literal
    elsif (dumbContract? || ethscriptionId?)
      unless literal.is_a?(String) && literal.match?(/^0x[a-f0-9]{64}$/i)
        raise_variable_type_error(literal)
      end
      
      return literal.downcase
    elsif addressOrDumbContract?
      unless literal.is_a?(String) && (literal.match?(/^0x[a-f0-9]{64}$/i) || literal.match?(/^0x[a-f0-9]{40}$/i))
        raise_variable_type_error(literal)
      end
      
      return literal.downcase
    elsif datetime?
      dummy_uint = Type.create(:uint256)
      
      begin
        return dummy_uint.check_and_normalize_literal(literal)
      rescue VariableTypeError => e
        raise_variable_type_error(literal)
      end
    elsif mapping?
      if literal.is_a?(MappingType::Proxy)
        return literal
      end
      
      unless literal.is_a?(Hash)
        raise VariableTypeError.new("invalid #{literal}")
      end
      
      data = literal.map do |key, value|
        [
          TypedVariable.create(key_type, key),
          TypedVariable.create(value_type, value)
        ]
      end.to_h
    
      proxy = MappingType::Proxy.new(data, key_type: key_type, value_type: value_type)
      
      return proxy
    elsif array?
      if literal.is_a?(ArrayType::Proxy)
        return literal
      end
      
      unless literal.is_a?(Array)
        raise_variable_type_error(literal)
      end
      
      data = literal.map do |value|
        TypedVariable.create(value_type, value)
      end
    
      proxy = ArrayType::Proxy.new(data, value_type: value_type)
      
      return proxy
    end
    
    raise VariableTypeError.new("Unknown type #{self.inspect}: #{literal.inspect}")
  end
  
  def ==(other)
    other.is_a?(self.class) &&
    other.name == name &&
    other.metadata == metadata
  end
  
  def !=(other)
    !(self == other)
  end
  
  def hash
    [name, metadata].hash
  end

  def eql?(other)
    hash == other.hash
  end
  
  def is_value_type?
    !mapping? && !array?
  end
end