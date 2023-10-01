##
# to run use:
#   $ ruby sandbox/arrays.rb



$LOAD_PATH.unshift( "./lib" )
require 'rubidity/typed'



TypedArray‹TypedString› = TypedArray.build_class( TypedString )
pp TypedArray‹TypedString›.type

ary = TypedArray‹TypedString›.new
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


puts "bye"