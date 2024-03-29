
=begin
class Object   ### move to core_ext/object - why? why not?
  ## check -  add scoped class here too - why? why not?
  ##           e.g. is_a?( Typed ) 
  ##             or add a TypedContract delagate class or such - why? why not?
  ##    fix - check for class has singelton method type - why? why not?
  def typed?() is_a?( Typed ); end
end
=end



module Types


##
# note:
#  use class Typed as namespace  for metatypes e.g. Type, StringType, AddressType,
#     the idea is to avoid confusion about metatypes and typed classes
#           by "hiding" metatypes from top-level (inside typed)

class Typed 


  ### use like:
  ##    Typed.serialize( obj ) or
  ##    Typed.dump( obj )
  ##  keep serialize/dump here in Typed - why? why not?
  def self.serialize( obj )
     obj.as_data
  end
  class << self
      alias_method :dump, :serialize
  end



  def self.type      
    raise "no required typed class accessor/ getter method defined for Typed subclass #{self.class.name}; sorry"
  end
  def type() self.class.type; end

  def as_data   ## kind of like as_json (in rails/ActiveModel/Serializers/JSON/as_json)
    raise "no required as_data method defined for Typed subclass #{self.class.name}; sorry"
  end

  
  ## keep serialize and/or as_json - why? why not?
  def serialize() as_data; end
  def as_json()   as_data; end

=begin
  def as_json( args={} )  serialize; end
  def serialize      
    raise "no required serialize method defined for Typed subclass #{self.class.name}; sorry"
  end  

  def deserialize( serialized_value )  replace( serialized_value ); end
  def replace( new_value )      
    raise "no required replace method defined for Typed subclass #{self.class.name}; sorry"
  end 
=end 
end  # class Typed


## add value & reference type base - why? why not?
class TypedValue < Typed
    
  ## todo/check: make "internal" value (string/integer) available? why? why not?
  ##  attr_reader :value   

  ## todo/check -- use self.zero or such - why? why not?
  def as_data() @value; end  

  def pretty_print( printer ) printer.text( "<val #{type}:#{@value.inspect}>" ); end

  def to_s
    if @value.is_a?(::String) || @value.is_a?(::Integer)
      @value.to_s
    else
      raise "no string conversion of value possible; sorry"
    end
  end

      def ==(other)
        other.is_a?(self.class) &&
        type   == other.type &&     ## note: type for no redundant (always the same if same class AND TypedValue)
        @value == other.instance_variable_get( :@value )    ## compare value via as_data!!!
      end
      
      def hash()       [@value, type].hash; end
      ## todo/check - hash == other.hash is default any way??
      def eql?(other)  hash == other.hash;  end
end  # TypedValue



class TypedReference < Typed

  
    def ==(other)
        other.is_a?(self.class) &&
        type  == other.type &&
        @data == other.instance_variable_get( :@data ) 
    end
      
    def hash()       [@data, type].hash; end
    ## todo/check - hash == other.hash is default any way??
    ##                 or is it object_id == other.object_id ????
    def eql?(other)  hash == other.hash;  end
end 

end  # module Types  
