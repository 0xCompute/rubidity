##
# to run use:
#   $ ruby sandbox/hello.rb



$LOAD_PATH.unshift( "./lib" )
require 'rubidity/typed'


name   = TypedString.new 
symbol = TypedString.new 


pp name
pp name.type
pp name.value
pp name.downcase
pp name.index( 'hello' )


puts
pp symbol
pp symbol.type
pp symbol.value

name.replace( 'hello' )
pp name
pp name.value

## name.replace( 123 )


decimals     = TypedUint256.new
totalSupply  = TypedUint256.new
pp decimals
pp totalSupply

decimals.replace( 18 )
totalSupply.replace( 21000000 )


pp decimals
pp totalSupply
pp totalSupply.serialize



balanceOf = TypedMapping.new key_type: :address,
                             value_type: :uint256



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

balanceOf.replace( old_state )


pp balanceOf.serialize


balanceOf.deserialize( {} )
pp balanceOf.serialize



b = TypedBytes.new
pp b

b = TypedBytes.new( '0x00AABB')
pp b

b = TypedBytes32.new
pp b



puts "bye"
