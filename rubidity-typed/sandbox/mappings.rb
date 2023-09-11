##
# to run use:
#   $ ruby sandbox/mappings.rb



$LOAD_PATH.unshift( "./lib" )
require 'rubidity/typed'


balanceOf  = TypedMapping.new( key_type: :addressOrDumbContract,
                               value_type: :uint256 )

t = balanceOf.type                      
# pp t.metadata 
pp t.name
pp t.format
pp t.key_type 
pp t.value_type

pp t.address?
pp t.array?
pp t.mapping?
pp t.uint256?
pp t.string?

pp t.zero



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



puts "bye"