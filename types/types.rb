
module Typed
class Type
    def format
        ## check/todo: what error to raise for not implemented / method not defined???
        raise ArgumentError, "no required format method defined for Type subclass #{self.class.name}; sorry"
    end   
    
    def is_value_type?() !is_a?( Array ) && !is_a?( Mapping ); end    
 

  def self.value_types
    ## note: use shared single (type) instances
    [String.instance,   
     Address.instance,
     DumbContract.instance,
     AddressOrDumbContract.instance,
     EthscriptionId.instance,
     Bool.instance,
     Uint256.instance,
     Int256.instance, 
     Datetime.instance, 
    ]
  end
 

  def self.create( type_or_name, **kwargs )
    return type_or_name   if type_or_name.is_a?( Type )
  
    type_name = type_or_name.to_sym
  
    case type_name
    when :string  
      String.instance   ## share single (type) instance
    when :address  
      Address.instance
    when :dumbContract    
      DumbContract.instance
    when :addressOrDumbContract
      AddressOrDumbContract.instance 
    when :ethscriptionId
      EthscriptionId.instance
    when :bool
      Bool.instance 
    when :uint256
      Uint256.instance 
    when :int256
      Int256.instance 
    when :datetime
       Datetime.instance 
    when :array
      ## todo: fix - find metadata format
      subtype = create( kwargs[:subtype] )  
      Array.instance( subtype )
    when :mapping 
      # e.g. mapping ({ addressOrDumbContract: :uint256 }), :public, :balanceOf    
      keytype  =  create( kwargs[:keytype] )
      valuetype = create( kwargs[:valuetype] )
      Mapping.instance( keytype, valuetype )
    else
      raise ArgumentError, "Invalid Type #{type_name}; sorry"
    end    
  end




 
  def raise_variable_type_error(literal)
    ## change to typeerror or such - why? why not?
    raise ArgumentError, "Invalid #{self}: #{literal.inspect}"
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
    if is_a?(Address)
      unless literal.is_a?(::String) && literal.match?(/^0x[a-f0-9]{40}$/i)
        raise_variable_type_error(literal)
      end
      
      return literal.downcase
    elsif is_a?(Uint256)
      if literal.is_a?(::String)
        literal = parse_integer(literal)
      end
        
      if literal.is_a?(::Integer) && literal.between?(0, 2 ** 256 - 1)
        return literal
      end
      
      raise_variable_type_error(literal)
    elsif is_a?( Int256 )
      if literal.is_a?(::String)
        literal = parse_integer(literal)
      end
        
      if literal.is_a?(::Integer) && literal.between?(-2 ** 255, 2 ** 255 - 1)
        return literal
      end
      
      raise_variable_type_error(literal)
    elsif is_a?( String )
      unless literal.is_a?(::String)
        raise_variable_type_error(literal)
      end
      
      return literal.freeze
    elsif is_a?( Bool )
      unless literal == true || literal == false
        raise_variable_type_error(literal)
      end
      
      return literal
    elsif is_a?( DumbContract ) || is_a?( EthscriptionId )
      unless literal.is_a?(::String) && literal.match?(/^0x[a-f0-9]{64}$/i)
        raise_variable_type_error(literal)
      end
      
      return literal.downcase
    elsif is_a?( AddressOrDumbContract )
      unless literal.is_a?(::String) && (literal.match?(/^0x[a-f0-9]{64}$/i) || literal.match?(/^0x[a-f0-9]{40}$/i))
        raise_variable_type_error(literal)
      end
      
      return literal.downcase
    elsif is_a?( Datetime )
      dummy_uint = Uint256.instance
      
      begin
        return dummy_uint.check_and_normalize_literal(literal)
      rescue VariableTypeError => e
        raise_variable_type_error(literal)
      end
    elsif is_a?( Mapping )
      if literal.is_a?(MappingVar::Proxy)
        return literal
      end
      
      unless literal.is_a?(::Hash)
        raise ArgumentError, "invalid #{literal}"
      end
      
      data = literal.map do |key, value|
        [
          Typed::Var.create( keytype,   key),
          Typed::Var.create( valuetype, value)
        ]
      end.to_h
    
      proxy = MappingVar::Proxy.new(data, keytype: keytype, valuetype: valuetype)
      
      return proxy
    elsif is_a?( Array )
      if literal.is_a?(ArrayVar::Proxy)
        return literal
      end
      
      unless literal.is_a?(::Array)
        raise_variable_type_error(literal)
      end
      
      data = literal.map do |value|
        Typed::Var.create( subtype, value )
      end
    
      proxy = ArrayVar::Proxy.new(data, subtype: subtype)
      
      return proxy
    end
    
    raise ArgumentError, "Unknown type #{self.inspect}: #{literal.inspect}"
  end
end  # class Type




class String < Type
    def format() 'string'; end
    def ==(another_type)  another_type.kind_of?( String ); end
    def default_value()  ''; end
    def self.instance()  @instance ||= new; end
end


class Address < Type
    def format() 'address'; end
    def ==(another_type)  another_type.kind_of?( Address ); end
    def default_value()   '0x'+'0'*40; end
    def self.instance()  @instance ||= new; end
end

class DumbContract < Type
    def format() 'dumbContract'; end
    def ==(another_type)  another_type.kind_of?( DumbContract ); end
    def default_value()   '0x'+'0'*64; end
    def self.instance()  @instance ||= new; end
end

class AddressOrDumbContract < Type  ## note: use "generic" "union" type???
    def format() 'addressOrDumbContract'; end
    def ==(another_type)  another_type.kind_of?( Address ) || another_type.kind_of?( DumbContract ); end
    def default_value()   '0x'+'0'*40; end  # note: default is address(0)
    def self.instance()  @instance ||= new; end
end

class EthscriptionId < Type      ## todo/check: rename to inscripeId or inscriptionId
    def format() 'ethscriptionId'; end
    def ==(another_type)  another_type.kind_of?( EthscriptionId ); end
    def default_value()   '0x'+'0'*64; end
    def self.instance()  @instance ||= new; end
end


class Bool < Type
    def format() 'bool'; end
    def ==(another_type)  another_type.kind_of?( Bool ); end
    def default_value()   false; end
    def self.instance()  @instance ||= new; end
end

class Uint256 < Type
    def format() 'uint256'; end
    def ==(another_type)  another_type.kind_of?( Uint256 ); end
    def default_value()   0; end
    def self.instance()  @instance ||= new; end
end

class Int256 < Type
    def format() 'int256'; end
    def ==(another_type)  another_type.kind_of?( Int256 ); end
    def default_value()   0; end
    def self.instance()  @instance ||= new; end
end

class Datetime < Type   ## note: datetime is int (epoch time since 1970 in seconds in utc)
    def format() 'datetime'; end
    def ==(another_type)  another_type.kind_of?( Datetime ); end
    def default_value()   0; end
    def self.instance()  @instance ||= new; end
end 


class Array < Type   ## note: dynamic array for now (NOT fixed!!!! - add FixedArray - why? why not?)
    attr_reader :subtype
    def initialize( subtype )
      @subtype = subtype
    end
    def format() "#{@subtype.format}[]"; end
    def ==(another_type)
      another_type.kind_of?( Array ) && @subtype == another_type.subtype
    end
    def default_value
        ArrayVar::Proxy.new( subtype: @subtype )  
    end
    def self.instance( subtype ) 
       @instances ||= {}
       @instances[ subtype.format ] ||= new(subtype) 
    end
end # class Array


class Mapping < Type
    attr_reader :keytype
    attr_reader :valuetype
     def initialize( keytype, valuetype )
       @keytype   = keytype
       @valuetype = valuetype
     end
     def format() "mapping(#{@keytype.format}=>#{@valuetype.format})"; end
     def ==(another_type)
       another_type.kind_of?( Mapping ) && 
       @keytype   == another_type.keytype &&
       @valuetype == another_type.valuetype 
     end
     def default_value 
        MappingVar::Proxy.new( keytype: @keytype, 
                               valuetype: @valuetype ) 
     end
     def self.instance( keytype, valuetype ) 
        @instances ||= {}
        @instances[ keytype.format+"=>"+valuetype.format ] ||= new(keytype, valuetype) 
     end
     end # class Mapping
end  # module Typed




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