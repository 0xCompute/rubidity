##
# to runu use:
#   $ ruby sandbox/types.rb



## require_relative '../lang/rubidity'
## require_relative '../rubidity/lib/rubidity'

require_relative '../types'
# require_relative '../typed_vars'


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


__END__

str  =  TypedVariable.create(:string, 'hello, world!')
pp str

addr =  TypedVariable.create(:address)  ## zero(0) / default address
pp addr


puts "bye"
