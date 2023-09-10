
require 'forwardable'  ## def_delegate



class TypedVariable
  extend Forwardable   ## pulls in def_delegator


  attr_accessor :type, :value


 ## todo/fix: make initialize "private" - always use create!!! 
  def initialize( type, value = nil)
    @type        = type
    self.value   = value || type.zero
  end
 

  
  def self.create( type, value = nil, **kwargs)
    type = Type.create( type, **kwargs )
    
    if type.is_a?( StringType )
      TypedString.new( type, value ) 
    elsif type.is_a?( MappingType )
      TypedMapping.new( type, value )
    elsif type.is_a?( ArrayType )
      TypedArray.new(type, value )
    else
      new( type, value )
    end
  end


  def as_json(args = {}) 
     serialize
  end
  def serialize() @value; end

  def to_s
    if @value.is_a?(String) || @value.is_a?(Integer)
      @value.to_s
    else
      raise "No string conversion"
    end
  end
  
  def deserialize( serialized_value )
    self.value = serialized_value
  end

 
  def value=(new_value)
    @value = if new_value.is_a?(TypedVariable)
               if new_value.type != @type
                 if @type.is_a?( AddressOrDumbContractType ) &&
                     (new_value.type.is_a?( AddressType ) ||
                      new_value.type.is_a?( DumbContractType ))           
                   new_value.value
                 else
                   raise TypeError, "expected type #{type}; got #{new_value.type} : #{new_value.value}"
                 end
               end
               new_value.value
            else
               @type.check_and_normalize_literal(new_value)
            end
  end
end # class Var



class TypedString < TypedVariable

  ## add more String forwards here!!!!
  def_delegators :@value, :downcase, 
                          :index, :include?,
                          :+

  def to_str() @value; end  ## "automagilally" support implicit string conversion - why? why not?


  def pretty_print( printer ) printer.text( "<var string:#{@value.inspect}>" ); end
end




class SafeArray

  attr_reader :data   

   def initialize( initial_value=[], sub_type: )
      @sub_type = sub_type
      @data    = initial_value
   end

  ## add more Array forwards here!!!!
  extend Forwardable   ## pulls in def_delegator
  def_delegators :@data, :size, :empty?, :clear,
                          :map, :reduce 


  def []( index )
    ## fix: use index out of bounds error - why? why not?
    raise ArgumentError, "Index out of bounds"   if index >= @data.size

    @data[ index ] || @sub_type.zero
  end

  def []=(index, new_value) 
    raise ArgumentError, "Sparse arrays are not supported"   if index > @data.size

    @data[ index ] = _typecast( @sub_type, new_value )
  end
  
  def push( new_value )
     @data.push( _typecast( @sub_type, new_value ) )
  end


  def _typecast( type, obj )
    if obj.is_a?( TypedVariable )
      if obj.type != type
         ## fix: raise typeerror - if exists!!!
          raise ArgumentError, "type error - expected #{type}; got #{obj.type} with value >#{obj.value}<"
      end
      obj.value
    else 
       type.check_and_normalize_literal( obj )
    end
  end
end  # class SafeArray



class TypedArray < TypedVariable  
  def initialize( type, value = nil)
    unless type.sub_type.is_value_type?
      raise ArgumentError, "Only value types for array elements supported; sorry" 
    end

    @type        = type
    self.value   = value || type.zero
  end
 
  
  ## note: pass through value!!!!
  ##   in new scheme - only "plain" ruby arrays/hash/string/integer/bool used!!!!
  ##    no wrappers!!! - no need to convert!!!
   
  ## fix later: now only supporting/holding primitives (always serialized as is)
  def _serialize_array( ary )
    ary.map {|item| item }
  end

  def serialize()  _serialize_array( @value ); end
  
  ## add more Array forwards here!!!!
  def_delegators :@value, :[], :[]=, :push,
                          :size, :empty?, :clear 

end # class ArrayVar


class SafeMapping     ## change/rename  to SafeHash or such - why? why not?

  attr_reader :data   

  def initialize( initial_value={}, key_type:, value_type: )
    @key_type   = key_type
    @value_type = value_type
    @data      = initial_value   ## todo: add check here - why? why not?
 end



  ## add more Array forwards here!!!!
  extend Forwardable   ## pulls in def_delegator
  def_delegators :@data, :size, :empty?, :clear, 
                         :map, :reduce 

  ##
   ### todo/fix: do NOT store typed keys and values in hash!!!!
   ##   (maybe only if array or mapping but NOT for primitivies!!!!)

   def [](key)
    puts "[debug] []( #{key} )"
    key_var = _typecast( @key_type, key )
    obj = @data[key_var]

    if @value_type.is_a?( MappingType ) && obj.nil?
      obj = @value_type.zero
      @data[key_var] = obj
    end

    obj || @value_type.zero 
  end

  def []=(key, new_value)
    puts "[debug] []=( #{key}, #{new_value}})"
    key_var = _typecast( @key_type, key )
    obj     = _typecast( @value_type, new_value )

    if @value_type.is_a?( MappingType )
      ## val_var = Proxy.new(keytype: valuetype.keytype, valuetype: valuetype.valuetype)
      raise "What?"
    end

    @data[key_var] = obj
  end


  def _typecast( type, obj )
    if obj.is_a?( TypedVariable )
      if obj.type != type
         ## fix: raise typeerror - if exists!!!
          raise ArgumentError, "type error - expected #{type}; got #{obj.type} with value >#{obj.value}<"
      end
      obj.value
    else 
       type.check_and_normalize_literal( obj )
    end
  end
end  # class SafeMapping



class TypedMapping < TypedVariable
  def initialize( type, value = nil)
    puts
    puts "[debug] MappingVar#initialize - #{type.inspect}, #{value.inspect}"
    @type        = type
    self.value   = value || type.zero

    puts "[debug] value: #{@value.inspect}"
  end


  ## todo: add support for array too??
  def _serialize_mapping( mapping )
    mapping.reduce({}) do |h, (k, v)|
      h[k] = v.is_a?( Hash ) ? _serialize_mapping( v ) : v
      h
    end
  end

  ## note: pass through value!!!!
  ##   in new scheme - only "plain" ruby arrays/hash/string/integer/bool used!!!!
  ##    no wrappers!!! - no need to convert!!!
  def serialize
    puts "[debug] MappingVar#serialize"
    pp @value
    _serialize_mapping( @value )
  end


  ## add more Hash forwards here!!!!
  def_delegators :@value, :[], :[]=, 
                        :size, :empty?, :clear

end # class TypedMapping




__END__
  
  def value=(new_value)
    @value = if new_value.is_a?(TypedVariable)
      if new_value.type != type
        if type == Type.create(:addressOrDumbContract) &&
           [Type.create(:address), Type.create(:dumbContract)].include?(new_value.type)
           
          new_value.value
        else
          raise VariableTypeError.new("invalid #{type}: #{new_value.value}")
        end
      end
      
      new_value.value
    else
      type.check_and_normalize_literal(new_value)
    end
  end
  
  def method_missing(name, *args, &block)
    if value.respond_to?(name)
      result = value.send(name, *args, &block)
      
      if result.class == value.class
        result = type.check_and_normalize_literal(result)
      end
      
      if name.to_s.end_with?("=") && !%w[>= <=].include?(name.to_s[-2..])
        self.value = result if type.is_value_type?
        self
      else
        result
      end
    else
      binding.pry
      super
    end
  end

  def respond_to_missing?(name, include_private = false)
    value.respond_to?(name, include_private) || super
  end
  
  def !=(other)
    !(self == other)
  end
  
  def ==(other)
    other.is_a?(self.class) &&
    value == other.value &&
    type == other.type
  end
  
  def hash
    [value, type].hash
  end

  def eql?(other)
    hash == other.hash
  end
end
