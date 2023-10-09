##
# to run use:
#   $ ruby sandbox/types.rb



$LOAD_PATH.unshift( "./lib" )
require 'solidity/typed'


module Sandbox


string          =  Typed::StringType.instance
address         =  Typed::AddressType.instance 
inscriptionId   =  Typed::InscriptionIdType.instance 
bytes32         =  Typed::Bytes32Type.instance
bytes           =  Typed::BytesType.instance
bool            =  Typed::BoolType.instance 
uint            =  Typed::UIntType.instance
int             =  Typed::IntType.instance
timestamp       =  Typed::TimestampType.instance

pp string
pp address
pp bytes32
pp bytes

pp string.format
pp address.format
pp bytes32.format


##########
# try typed

var =  String.new( 'Hello, World!')
pp var
puts "serialize:"
pp var.serialize

var =  String.new
pp var
puts "serialize:"
pp var.serialize


Array‹String› = Array.new( String )
Array‹UInt›   = Array.new( UInt )
Mapping‹String→String› = Mapping.new( String, String )



var =  Array‹String›.new( ['one', 'two' ] )
pp var
puts "serialize:"
pp var.serialize


var =  Array‹UInt›.new
pp var
puts "serialize:"
pp var.serialize


var =  Mapping‹String→String›.new( {'one'=> 'two' } )
pp var
puts "serialize:"
pp var.serialize


var =  Mapping‹String→String›.new
pp var
puts "serialize:"
pp var.serialize


puts "bye"

end    # module Sandbox
