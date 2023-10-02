##
# to run use:
#   $ ruby sandbox/types2.rb



$LOAD_PATH.unshift( "./lib" )
require 'rubidity/typed'


module Sandbox


string       =  Typed::StringType.instance
address      =  Typed::AddressType.instance 
inscriptionId   =  Typed::InscriptionIdType.instance 
bytes32      =  Typed::Bytes32Type.instance
bytes      =  Typed::BytesType.instance
bool    =   Typed::BoolType.instance 
uint  =   Typed::UIntType.instance
int   =   Typed::IntType.instance
timestamp =  Typed::TimestampType.instance

pp string
pp address
pp bytes32
pp bytes

pp string.format
pp address.format
pp bytes32.format
pp bytes32.is_value_type?


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


Array‹String› = Array.build_class( String )
Array‹UInt›   = Array.build_class( UInt )
Mapping‹String→String› = Mapping.build_class( String, String )



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
