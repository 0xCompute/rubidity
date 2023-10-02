##
# to run use:
#   $ ruby sandbox/hello.rb



$LOAD_PATH.unshift( "./lib" )
require 'rubidity/typed'


module Sandbox

name   = String.new 
symbol = String.new 


pp name
pp name.type
pp name.as_data
pp name.downcase
pp name.index( 'hello' )


puts
pp symbol
pp symbol.type
pp symbol.as_data

# name.replace( 'hello' )
pp name
pp name.as_data

## name.replace( 123 )


decimals     = UInt.new
totalSupply  = UInt.new
pp decimals
pp totalSupply

decimals = UInt.new( 18 )
totalSupply = UInt.new( 21000000 )


pp decimals
pp totalSupply
pp totalSupply.serialize


Mapping‹Address→UInt› = Mapping.build_class( Address, UInt )

balanceOf = Mapping‹Address→UInt›.new
pp balanceOf


balanceOf['0xC2172a6315c1D7f6855768F843c420EbB36eDa97'] = 21000000

pp balanceOf


old_state = balanceOf.serialize
puts old_state.class.name  
#=> Hash


balanceOf['0xC2172a6315c1D7f6855768F843c420EbB36eDa97'] = 0
pp balanceOf.serialize

puts "old_state:"
pp old_state

# balanceOf.replace( old_state )


pp balanceOf.serialize


# balanceOf.deserialize( {} )
pp balanceOf.serialize



b = Bytes.new
pp b

b = Bytes.new( '0x00AABB')
pp b

b = Bytes32.new
pp b



puts "bye"

end # module Sandbox
