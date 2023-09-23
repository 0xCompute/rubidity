
$LOAD_PATH.unshift( '../rubidity-typed/lib' )
$LOAD_PATH.unshift( '../rubidity/lib' )
$LOAD_PATH.unshift( '../rubidity-contracts/lib' )
require 'rubidity'
require 'rubidity/contracts'


require_relative 'contract_implementation'


alice   = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
bob     = '0x'+'b'*40 # e.g. '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
charlie = '0x'+'c'*40 # e.g. '0xcccccccccccccccccccccccccccccccccccccccc'

pp alice
pp bob
pp charlie



c = ERC20Receiver.create 
c.constructor
pp c.serialize


c = ERC20Minimal.create
c.constructor( name: 'minimal', symbol: 'MIN', decimals: '9' )
pp c.serialize 
               





c = AddressArg.create
c.constructor( testAddress: alice )
c.respond( greeting: 'hello' )
pp c.serialize




c.msg.sender = alice


c = Receiver.create
c.constructor
pp c.sayHi
pp c.name
pp c._internalCall   ### FIX: mark as private with ruby too!!! why? why not?



## FIX: receiveCall uses/returns block.number!!!!!!
##  undefined method `block' 

## pp c.receiveCall     
pp c.serialize

pp AbiProxy.contract_classes


puts "bye"