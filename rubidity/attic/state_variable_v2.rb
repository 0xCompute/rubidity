

class StateVariable
  
  attr_accessor :typed_variable, 
                :name, 
                :visibility,    # internal|private|public
                :immutable,    ## fix: change to immutable? - why? why not?
                :constant      ## fix: change to constant? - why? why not?
  
  def immutable?() @immutable; end
  def constant?()  @constant; end

  def initialize(name, typed_variable, args)
    visibility = :internal
    
    args.each do |arg|
      case arg
      when :public, :private
        visibility = arg
      end
    end
    
    @visibility = visibility
    @immutable = args.include?(:immutable)
    @constant = args.include?(:constant)
    @name = name
    @typed_variable = typed_variable
  end
  
  def self.create(name, type, args)
    var = TypedVariable.create(type)
    new(name, var, args)
  end
  

  def type() @typed_variable.type; end

 
=begin  
  def serialize
    typed_variable.serialize
  end
  
  def deserialize(value)
    typed_variable.deserialize(value)
  end
=end
  

  def ==(other)
    other.is_a?(StateVariable) &&
      typed_variable == other.typed_variable &&
      name == other.name &&
      visibility == other.visibility &&
      immutable == other.immutable &&
      constant == other.constant
  end
   
  def hash
    [typed_variable, name, visibility, immutable, constant].hash
  end
  def eql?(other) hash == other.hash; end
end
