
require 'forwardable'  ## def_delegate


module Typed

def self.var( type, value = nil, **kwargs )
     Var.create( type, value, **kwargs )
end




class Var
  extend Forwardable   ## pulls in def_delegator


  attr_accessor :type, :value

  def initialize( type, value = nil)
    @type        = type
    self.value   = value || type.default_value
  end
 

  
  def self.create( type, value = nil, **kwargs)
    type = Type.create( type, **kwargs )
    
    if type.is_a?( String )
      StringVar.new( type, value ) 
    elsif type.is_a?( Mapping )
      MappingVar.new( type, value )
    elsif type.is_a?( Array )
      ArrayVar.new(type, value )
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
    @value = if new_value.is_a?(Var)
               if new_value.type != @type
                 if @type.is_a?( AddressOrDumbContract) &&
                     (new_value.type.is_a?( Address) ||
                      new_value.type.is_a?( DumbContract))           
                   new_value.value
                 else
                  ## fix: raise typeerror - if exists!!!
                   raise ArgumentError, "invalid #{type}: #{new_value.value}"
                 end
               end
               new_value.value
            else
               @type.check_and_normalize_literal(new_value)
            end
  end
end # class Var



class StringVar < Var

  ## add more String forwards here!!!!
  def_delegators :@value, :downcase, 
                          :index, :include?
end




class SafeArray

  attr_reader :data   

   def initialize( initial_value=[], subtype: )
      @subtype = subtype
      @data    = initial_value
   end

  ## add more Array forwards here!!!!
  extend Forwardable   ## pulls in def_delegator
  def_delegators :@data, :size, :empty?, :clear,
                          :map, :reduce 


  def []( index )
    ## fix: use index out of bounds error - why? why not?
    raise ArgumentError, "Index out of bounds"   if index >= @data.size

    @data[ index ] || @subtype.default_value
  end

  def []=(index, new_value) 
    raise ArgumentError, "Sparse arrays are not supported"   if index > @data.size

    @data[ index ] = _typecast( @subtype, new_value )
  end
  
  def push( new_value )
     @data.push( _typecast( @subtype, new_value ) )
  end

  def _typecast( type, obj )
    if obj.is_a?( Var )
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



class ArrayVar < Var  
  def initialize( type, value = nil)
    unless type.subtype.is_value_type?
      raise ArgumentError, "Only value types for array elements supported; sorry" 
    end

    @type        = type
    self.value   = value || type.default_value
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

  def initialize( initial_value={}, keytype:, valuetype: )
    @keytype   = keytype
    @valuetype = valuetype
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
    key_var = _typecast( @keytype, key )
    obj = @data[key_var]

    if @valuetype.is_a?( Mapping ) && obj.nil?
      obj = @valuetype.default_value
      @data[key_var] = obj
    end

    obj || @valuetype.default_value 
  end

  def []=(key, new_value)
    puts "[debug] []=( #{key}, #{new_value}})"
    key_var = _typecast( @keytype, key )
    obj     = _typecast( @valuetype, new_value )

    if @valuetype.is_a?( Mapping )
      ## val_var = Proxy.new(keytype: valuetype.keytype, valuetype: valuetype.valuetype)
      raise "What?"
    end

    @data[key_var] = obj
  end


  def _typecast( type, obj )
    if obj.is_a?( Var )
      if obj.type != type
         ## fix: raise typeerror - if exists!!!
          raise ArgumentError, "type error - expected #{@subtype}; got #{obj.type} with value >#{obj.value}<"
      end
      obj.value
    else 
       type.check_and_normalize_literal( obj )
    end
  end
end  # class SafeMapping



class MappingVar < Var
  def initialize( type, value = nil)
    puts
    puts "[debug] MappingVar#initialize - #{type.inspect}, #{value.inspect}"
    @type        = type
    self.value   = value || type.default_value

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

end # class MappingVar

end  #  module Typed




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
