###
# to run use
#  $ ruby  sandbox/types.rb

require_relative '../types'
require_relative '../typed_vars'


string       =  Typed::String.new
address      =  Typed::Address.new 
dumbContract =  Typed::DumbContract.new 

addressOrDumbContract =  Typed::AddressOrDumbContract.new
ethscriptionId   =  Typed::EthscriptionId.new 
bool    =   Typed::Bool.new 
uint256 =   Typed::Uint256.new
int256  =   Typed::Int256.new 
datetime =  Typed::Datetime.new 

pp string
pp address
pp dumbContract

pp string.format
pp address.format
pp dumbContract.format
pp dumbContract.is_value_type?

#=>     mapping ({ addressOrDumbContract: :uint256 }), :public, :balanceOf
mapping = Typed::Mapping.new( addressOrDumbContract, uint256 )
pp mapping
pp mapping.format
pp mapping.is_value_type?


t = Typed::Type.create( :string )
pp t

t = Typed::Type.create( t )
pp t

t = Typed::Type.create( :uint256 )
pp t
pp t.format
pp t.is_value_type?


t = Typed::Type.create( :array, subtype: :string )
pp t
pp t.format
pp t.is_value_type?

t = Typed::Type.create( :mapping, keytype:   :addressOrDumbContract,
                                  valuetype: :uint256 )
pp t
pp t.format
pp t.is_value_type?


###
# try typed vars

var =  Typed::Var.create( :string, 'Hello, World!')
pp var
puts "serialize:"
pp var.serialize

var =  Typed::Var.create( :string )
pp var
puts "serialize:"
pp var.serialize

var =  Typed::Var.create( :array, ['one', 'two' ], subtype: :string )
pp var
puts "serialize:"
pp var.serialize

var =  Typed::Var.create( :array, subtype: :uint256 )
pp var
puts "serialize:"
pp var.serialize

var =  Typed::Var.create( :mapping, {'one'=> 'two' }, keytype: :string,
                                                      valuetype: :string )
pp var
puts "serialize:"
pp var.serialize



var =  Typed::Var.create( :mapping,  keytype: :string,
                                     valuetype: :string )
pp var
puts "serialize:"
pp var.serialize




pp Typed::Type.value_types

puts "bye"