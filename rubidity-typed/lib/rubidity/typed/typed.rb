
=begin
class Object   ### move to core_ext/object - why? why not?
  ## check -  add ContractBase here too - why? why not?
  ##           e.g. is_a?( Typed ) || is_a?( ContractBase )
  ##             or add a TypedContract delagate class or such - why? why not?
  ##    fix - check for class has singelton method type - why? why not?
  def typed?() is_a?( Typed ); end
end
=end



module Types

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



class TypedReference < Typed

    def ==(other)
        other.is_a?(self.class) &&
        type == other.type &&
        data == other.data 
    end
      
    def hash()       [data, type].hash; end
    ## todo/check - hash == other.hash is default any way??
    def eql?(other)  hash == other.hash;  end
end 

end  # module Types  
