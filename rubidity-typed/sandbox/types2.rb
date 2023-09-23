##
# to run use:
#   $ ruby sandbox/types2.rb



$LOAD_PATH.unshift( "./lib" )
require 'rubidity/typed'



string       =  Type.create( :string )
address      =  Type.create( :address ) 
ethscriptionId   =  Type.create( :ethscriptionId ) 
bytes32      =  Type.create( :bytes32 )
bytes      =  Type.create( :bytes )
bool    =   Type.create( :bool ) 
uint256 =   Type.create( :uint256 )
int256  =   Type.create( :int256 )
datetime =  Type.create( :datetime )

pp string
pp address
pp bytes32
pp bytes

pp string.format
pp address.format
pp bytes32.format
pp bytes32.is_value_type?



#=>     mapping ({ address: :uint256 }), :public, :balanceOf
mapping = Type.create( :mapping, key_type: :address, 
                                 value_type: :uint256 )
pp mapping
pp mapping.format
pp mapping.is_value_type?


t = Type.create( :string )
pp t

t = Type.create( t )
pp t

t = Type.create( :uint256 )
pp t
pp t.format
pp t.is_value_type?


t = Type.create( :array, sub_type: :string )
pp t
pp t.format
pp t.is_value_type?

t = Type.create( :mapping, key_type:   :address,
                           value_type: :uint256 )
pp t
pp t.format
pp t.is_value_type?


##########
# try typed vars

var =  TypedVariable.create( :string, 'Hello, World!')
pp var
puts "serialize:"
pp var.serialize

var =  TypedVariable.create( :string )
pp var
puts "serialize:"
pp var.serialize

var =  TypedVariable.create( :array, ['one', 'two' ], 
                              sub_type: :string )
pp var
puts "serialize:"
pp var.serialize


var =  TypedVariable.create( :array, 
                             sub_type: :uint256 )
pp var
puts "serialize:"
pp var.serialize

var =  TypedVariable.create( :mapping, {'one'=> 'two' }, 
                              key_type: :string,
                              value_type: :string )
pp var
puts "serialize:"
pp var.serialize


var =  TypedVariable.create( :mapping,  key_type: :string,
                                        value_type: :string )
pp var
puts "serialize:"
pp var.serialize


pp Type.value_types

puts "bye"