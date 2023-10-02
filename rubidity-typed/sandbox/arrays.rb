##
# to run use:
#   $ ruby sandbox/arrays.rb



$LOAD_PATH.unshift( "./lib" )
require 'rubidity/typed'


module Sandbox

Array‹String› = Array.build_class( String )
pp Array‹String›.type

ary = Array‹String›.new
pp ary
pp ary.zero?

## pp ary.replace( ['one', 'two'] )
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

puts "bye"

end # module Sandbox
