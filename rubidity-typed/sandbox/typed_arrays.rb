##
# to run use:
#   $ ruby sandbox/typed_arrays.rb



$LOAD_PATH.unshift( "./lib" )
require 'rubidity/typed'


module Sandbox

typedclass = Array.new( String )
pp typedclass

## sames as
typedclass2 = Array‹String›
pp typedclass2


ary = typedclass.new
pp ary
pp ary.zero?

pp ary.push( 'one' )
pp ary.push( 'two' )
pp ary

ary.push( 'three' )
pp ary[0]
pp ary[1]
pp ary[2]
pp ary.size
pp ary

pp ary.serialize
## pp ary.deserialize( ary.serialize )



typedclass = Array.new( UInt )
pp typedclass

## sames as
typedclass2 = Array‹UInt›
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
pp a.push( 4 )
pp a[4]
pp a.length
pp a.serialize


puts "bye"

end  # module Sandbox
