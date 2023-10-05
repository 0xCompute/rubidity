#########
### monkey patch built-in FalseClass & TrueClass
##   move to core-ext directory or such - why? why not?


## note. Bool is a module (NOT a class)
##         adding a new superclass in ruby NOT possible
##                still waiting for common base clase for bools in ruby!!!
##   see  https://github.com/geraldb/talks/blob/master/bool.md
##    or  https://github.com/rubycocos/core/tree/master/safebool 


module Bool
  def type()     self.class.type; end
  def as_data()  self;  end  ## that is, return true or false
 
  ## note:
  ##  self.type or such WILL not get included  
  ##   via module include in TrueClass & FalseClass
  ##   add in TrueClass & FalseClass
  ##   TrueClass.type will NOT work via "inheritance" like a "true" superclass - why? why not?
  def self.type() Types::Typed::BoolType.instance; end 
  ## note: lets you use Bool.type
end  # module Bool



class FalseClass
    include Bool     ## "hack" - enables false.is_a?(Bool)
                     ##             and false.type 
                     ##             and false.as_data
  
    def self.type()  Types::Typed::BoolType.instance; end
    def zero?() true; end
end

class TrueClass
    include Bool    ## "hack" - enables true.is_a?(Bool)
                    ##             and true.type 
                    ##             and true.as_data

    def self.type()  Types::Typed::BoolType.instance; end
    def zero?() false; end
end
  