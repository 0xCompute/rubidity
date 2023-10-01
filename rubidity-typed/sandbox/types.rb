##
# to run use:
#   $ ruby sandbox/types2.rb



$LOAD_PATH.unshift( "./lib" )
require 'rubidity/typed'



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

var =  TypedString.new( 'Hello, World!')
pp var
puts "serialize:"
pp var.serialize

var =  TypedString.new
pp var
puts "serialize:"
pp var.serialize


TypedArray‹TypedString› = TypedArray.build_class( TypedString )
TypedArray‹TypedUInt›   = TypedArray.build_class( TypedUInt )
TypedMapping‹TypedString→TypedString› = TypedMapping.build_class( TypedString, TypedString )



var =  TypedArray‹TypedString›.new( ['one', 'two' ] )
pp var
puts "serialize:"
pp var.serialize


var =  TypedArray‹TypedUInt›.new
pp var
puts "serialize:"
pp var.serialize


var =  TypedMapping‹TypedString→TypedString›.new( {'one'=> 'two' } )
pp var
puts "serialize:"
pp var.serialize


var =  TypedMapping‹TypedString→TypedString›.new
pp var
puts "serialize:"
pp var.serialize


puts "bye"