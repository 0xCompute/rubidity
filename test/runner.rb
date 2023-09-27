
$LOAD_PATH.unshift( '../rubidity-typed/lib' )
$LOAD_PATH.unshift( '../rubidity/lib' )
$LOAD_PATH.unshift( '../rubidity-contracts/lib' )
require 'rubidity'
require 'rubidity/contracts'


require_relative 'contract_implementation'


alice   = '0x'+'aa'*20 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
bob     = '0x'+'bb'*20 # e.g. '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
charlie = '0x'+'cc'*20 # e.g. '0xcccccccccccccccccccccccccccccccccccccccc'

pp alice
pp bob
pp charlie



erc20receiver = ERC20Receiver.construct
pp erc20receiver.serialize


c = ERC20Minimal.construct( name: 'minimal', symbol: 'MIN', decimals: '9' )
pp c.serialize 
               





c = AddressArg.construct( testAddress: alice )
c.respond( greeting: 'hello' )
pp c.serialize




c.msg.sender = alice


receiver = Receiver.construct
pp receiver.sayHi
pp receiver.name
pp receiver._internalCall   ### FIX: mark as private with ruby too!!! why? why not?



## FIX: receiveCall uses/returns block.number!!!!!!
##  undefined method `block' 
pp receiver.receiveCall     
pp receiver.serialize


caller = Caller.construct 
pp caller

caller.makeCall( receiver.__address__ )
caller.callInternal( receiver.__address__ )
caller.testImplements( erc20receiver.__address__ )


deployer = Deployer.construct
erc20 = deployer.createReceiver( name: 'Yet Another Token', 
                                 symbol: 'YET',
                                 decimals: 18 )
pp erc20



puts "contracts registry:"
pp ContractImplementation.registry

puts "contract classes:"
pp AbiProxy.contract_classes


puts "bye"