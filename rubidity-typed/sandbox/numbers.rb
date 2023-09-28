
$LOAD_PATH.unshift( "./lib" )
require 'rubidity/typed'


## check if += or -= is type checked??

a = TypedUInt.new( 100 )
pp a

a = a + 10
pp a

a += 10
pp a

## a -= 200
## pp a
## => expected type uint256; got -80 (TypeError)


## assign literal (wipes out typed var)
a = 100
pp a





b = TypedUInt.new( 200 )
pp b

puts "bye"