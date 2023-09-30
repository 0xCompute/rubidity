##
# to run use:
#   $ ruby sandbox/typed_arrays.rb



$LOAD_PATH.unshift( "./lib" )
require 'rubidity/typed'



typedclass = TypedArray.build_class( sub_type: :string )
pp typedclass

## sames as
typedclass2 = TypedArray::TypedArray‹TypedString›
pp typedclass2


ary = typedclass.new
pp ary
pp ary.zero?

pp ary.replace( ['one', 'two'] )
pp ary

ary.push( 'three' )
pp ary[0]
pp ary[1]
pp ary[2]
pp ary.size
pp ary

pp ary.serialize
pp ary.deserialize( ary.serialize )



typedclass = TypedArray.build_class( sub_type: :uint )
pp typedclass

## sames as
typedclass2 = TypedArray::TypedArray‹TypedUInt›
pp typedclass2


pp a = typedclass.new
pp a.type
pp a = typedclass.new( [0,1,2] )
pp a[0]
pp a[1]
pp a[2]
pp a.length
pp a.push( 3 )
pp a[3]
pp a[4] = 4
pp a[4]
pp a.length
pp a.serialize


puts "bye"