##
# use numeric for UInt, Int and such - why? why not?

# Numeric should be used when defining other numeric classes.
#
# Classes which inherit from Numeric must implement coerce, 
# which returns a two-member Array containing an object that has been coerced 
# into an instance of the new class and self (see coerce).
#
# Inheriting classes should also implement 
# arithmetic operator methods (+, -, * and /) and 
# the <=> operator (see Comparable). 
# These methods may rely on coerce to ensure interoperability
#  with instances of other numeric classes.
#
#  see https://ruby-doc.org/core-2.5.1/Numeric.html


##
## todo: try UInt2  without Number base
##    works the same??? - why? why not?
##  what's the benefit of derivation from Numeric???

# coerce(numeric) → array
# If numeric is the same type as num, returns an array [numeric, num].
#  Otherwise, returns an array with both numeric and num represented as Float objects.
#
# This coercion mechanism is used by Ruby to handle mixed-type numeric operations:
#  it is intended to find a compatible common type between the two operands of the operator.
# 
# 1.coerce(2.5)   #=> [2.5, 1.0]
# 1.2.coerce(3)   #=> [3.0, 1.2]
# 1.coerce(2)     #=> [2, 1]


class UInt < Numeric

  def initialize( initial_value )
     @value = initial_value
  end
    
  def to_i() @value; end
  def to_s() @value.to_s(10); end

  def coerce(other)
    puts "calling UInt#coerce other=#{other}:#{other.class.name}"
    [UInt.new( other.to_i ), self]
  end

  def <=>(other)
    puts "calling UInt#<=>" 
    to_i <=> other.to_i
  end

  def +(other) UInt.new( to_i + other.to_i); end
  def -(other) UInt.new( to_i - other.to_i); end
  def *(other) UInt.new( to_i * other.to_i); end
  def /(other) UInt.new( to_i / other.to_i); end
end



one = UInt.new( 1 )

pp one
pp one.integer?   #=> false - not working - how to make it an integer!!!
pp one.positive?  #=> true

pp one + 1
pp 1 + one   #=> calling UInt#coerce other=1:Integer


pp 1.coerce(2.5)   #=> [2.5, 1.0]
pp 1.2.coerce(3)   #=> [3.0, 1.2]
pp 1.coerce(2)     #=> [2, 1]


pp one.coerce( 1 )
## pp 1.coerce( one ) #=> TypeError - can't convert UInt into Float



a = UInt.new( 1 )
b = UInt.new( 1 )
pp a == b
pp a.object_id == b.object_id
pp [a.object_id, b.object_id]
pp [a.hash, b.hash]

c = UInt.new( 2 )
d = UInt.new( 3 )
pp c == d
pp c.object_id == d.object_id
pp [c.object_id, d.object_id]
pp [c.hash, d.hash]

puts "bye"