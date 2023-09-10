##
# to runu use:
#   $ ruby sandbox/types.rb



## require_relative '../lang/rubidity'
## require_relative '../rubidity/lib/rubidity'

require_relative '../types'
require_relative '../typed_vars'


pp Type::TYPES
#=> [:string,
#    :mapping,
#    :address,
#    :dumbContract,
#    :addressOrDumbContract,
#    :ethscriptionId,
#    :bool,
#    :address,
#    :uint256,
#    :int256,
#    :array,
#    :datetime]


pp Type.value_types   ## excludes mapping & array
#=> [:string,
#    :address,
#    :dumbContract,
#    :addressOrDumbContract,
#    :ethscriptionId,
#    :bool,
#    :address,
#    :uint256,
#    :int256,
#    :datetime]




t = Type.create( :string )
pp t
t = Type.create( :string )
pp t
t = Type.create( :string )
pp t

t = Type.create( :address )
pp t
pp t.default_value
pp t.zero


pp t.name

t = Type.create( :mapping, key_type: :addressOrDumbContract,
                           value_type: :uint256 )
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


t = StringType.instance 
pp t
pp t.format
pp t.to_s
pp t.name
pp t.inspect

t = BoolType.instance
pp t    ## uses t.pretty_print_inspect
p  t    ## uses t.inspect
pp t.format
pp t.to_s
pp t.name
pp t.zero
pp t.default_value

puts "hash:"
pp t.hash
pp t.hash
pp t.hash
pp t.inspect
pp t.is_value_type?
pp t.bool?
pp t.uint256?

pp BoolType.instance == BoolType.instance
pp BoolType.instance == Uint256Type.instance



str  =  TypedVariable.create(:string, 'hello, world!')
pp str
pp str.type
pp str.value
pp str.value.frozen?

str  =  TypedVariable.create(:string )
pp str
pp str.type
pp str.value
pp str.value.frozen?

addr =  TypedVariable.create(:address)  ## zero(0) / default address
pp addr
pp addr.type
pp addr.value
pp addr.value.frozen?

pp ADDRESS_ZERO
pp ADDRESS_ZERO.frozen?



name   = TypedVariable.create( :string ) 
symbol = TypedVariable.create( :string ) 

pp name
pp name.type
pp name.value
pp name.downcase
pp name.index( 'hello' )


puts
pp symbol
pp symbol.type
pp symbol.value

name.value = 'hello'
pp name
pp name.value
pp name.value.frozen?

puts "symbol:<" + symbol + ">- name:<" + name + ">"
puts "symbol:<#{symbol}>- name:<#{name}>"



## name.value = 123

decimals     = TypedVariable.create( :uint256 )
totalSupply  = TypedVariable.create( :uint256 )
pp decimals
pp totalSupply

decimals.value = 18
totalSupply.value = 21000000


pp decimals
pp totalSupply
pp totalSupply.serialize


balanceOf = TypedVariable.create :mapping, key_type:   :addressOrDumbContract,
                                           value_type: :uint256


pp balanceOf



balanceOf.value['0xC2172a6315c1D7f6855768F843c420EbB36eDa97'] = 21000000
balanceOf['0xC2172a6315c1D7f6855768F843c420EbB36eDa97'] = 21000000

pp balanceOf


old_state = balanceOf.serialize
puts old_state.class.name  
#=> Hash


balanceOf['0xC2172a6315c1D7f6855768F843c420EbB36eDa97'] = 0
pp balanceOf.serialize

puts "old_state:"
pp old_state

balanceOf.value = old_state


pp balanceOf.serialize


balanceOf.deserialize( {} )
pp balanceOf.serialize





puts "bye"