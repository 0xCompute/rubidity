################
#  to run use:
#    $ ruby sandbox/test_hello.rb


$LOAD_PATH.unshift( '../solidity-typed/lib' )
$LOAD_PATH.unshift( '../rubysol/lib' )
$LOAD_PATH.unshift( './lib' )
require 'rubidity'



####################
# load (parse) and generate contract classes

Contract.load( 'HelloWorld' )



#############
#  try out contract classes

pp HelloWorld

pp HelloWorld.name


contract = HelloWorld.new
pp contract

pp contract.getHelloWorld
#=> "Hello, world!"


puts "bye"