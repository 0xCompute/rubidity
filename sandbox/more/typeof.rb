###
#  check if typeof is available

pp defined?( typeof )
pp defined?( type )
pp defined?( main )
pp defined?( Bool )
pp defined?( TrueClass )    #=> "constant"
pp defined?( FalseClass )   #=> "constant"
pp defined?( true )         #=> "true"
pp defined?( false )        #=> "false"

pp true.class
pp false.class

pp TrueClass
pp FalseClass

pp TrueClass.ancestors
pp FalseClass.ancestors

## TrueClass.new  #  undefined method `new' for TrueClass:Class (NoMethodError)

pp TrueClass.instance_methods
puts "---"
pp TrueClass.instance_methods( false )
pp FalseClass.instance_methods( false )

## pp true.is_a?( Bool )  uninitialized constant Bool (NameError)




class BoolType
  def self.instance() @instance ||= new; end

  def format() 'bool'; end
  alias_method :to_s, :format 

  def ==(other)  other.is_a?( BoolType ); end

  def zero()  false; end

  def new_zero() false; end
  def new( initial_value )   ## check - add default zero value - why? why not?
     if initial_value.instance_of?( TrueClass )
        true
     elsif initial_value.instance_of?( FalseClass )
        false
     else
        ## use value error?
        raise ArgumentError, "BoolType.new - true or false arg expected; got: #{initial_value}"
     end
  end
end  # class BoolType



module Bool
  def type()     self.class.type; end
  def as_data()  self;  end  ## that is, return true or false
  ## note:
  ##  self.type or such WILL not get included  
  ##   via module include in TrueClass & FalseClass
  ##   add in TrueClass & FalseClass
  ##   TrueClass.type will NOT work via "inheritance" like a "true" superclass - why? why not?

  def self.type() BoolType.instance; end 
  ## note: lets you use Bool.type
end  # module Bool

class FalseClass
    include Bool     ## "hack" - enables false.is_a?(Bool)
  
    def self.type()  BoolType.instance; end
    def zero?() true; end
end

class TrueClass
    include Bool    ## "hack" - enables true.is_a?(Bool)
  
    def self.type()  BoolType.instance; end
    def zero?() false; end
end
  



pp defined?( Bool )

pp TrueClass.ancestors
pp FalseClass.ancestors

pp false.zero?
pp true.zero?

pp false.is_a?( Bool )
pp true.is_a?( Bool )

pp false.type
pp true.type

## same as
pp false.class.type
pp true.class.type

pp TrueClass.type
pp FalseClass.type

pp false.as_data
pp true.as_data


pp false.type.new_zero
pp true.type.new_zero

pp false.type.new( true )
pp false.type.new( false )

pp true.type.new( true )
pp true.type.new( false )

pp Bool.type
pp Bool.respond_to?( :type )


pp Bool.type.new( true )
pp Bool.type.new( false )
pp Bool.type.new_zero

puts 'bye'