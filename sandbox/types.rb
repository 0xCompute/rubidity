##
# to runu use:
#   $ ruby sandbox/types.rb



## require_relative '../lang/rubidity'
require_relative '../rubidity/lib/rubidity'


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


str  =  TypedVariable.create(:string, 'hello, world!')
pp str

addr =  TypedVariable.create(:address)  ## zero(0) / default address
pp addr


t = Type.new( :string )
pp t
t = Type.new( :string )
pp t
t = Type.new( :string )
pp t

t = Type.new( :address )
pp t

pp t.name
pp t.metadata 
pp t.key_type 
pp t.value_type
  
puts "bye"
