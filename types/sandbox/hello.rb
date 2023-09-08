###
# to run use
#  $ ruby  sandbox/types.rb

require_relative '../types'
require_relative '../typed_vars'


name   = Typed.var :string 
symbol = Typed.var :string 


pp name
pp name.type
pp name.value

puts
pp symbol
pp symbol.type
pp symbol.value

name.value = 'hello'
pp name
pp name.value

## name.value = 123

decimals     = Typed.var :uint256
totalSupply  = Typed.var :uint256
pp decimals
pp totalSupply

decimals.value = 18
totalSupply.value = 21000000
pp decimals
pp totalSupply
pp totalSupply.serialize


balanceOf = Typed.var :mapping, keytype: :addressOrDumbContract,
                                valuetype: :uint256
pp balanceOf

balanceOf.value['0xC2172a6315c1D7f6855768F843c420EbB36eDa97'] = 21000000
pp balanceOf
old_state = balanceOf.serialize
puts old_state.class.name  
#=> Hash


balanceOf.value['0xC2172a6315c1D7f6855768F843c420EbB36eDa97'] = 0
pp balanceOf.serialize

puts "old_state:"
pp old_state
balanceOf.value = old_state
pp balanceOf.serialize


balanceOf.deserialize( {} )
pp balanceOf.serialize



puts "bye"
