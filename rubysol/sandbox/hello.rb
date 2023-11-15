##
# to runu use:
#   $ ruby sandbox/hello.rb


require_relative 'helper'



require_relative 'testtoken'



pp TestToken.state_variable_definitions
pp TestToken.parent_contracts 
pp TestToken.events 

sigs = TestToken.sigs 
puts
puts "#{sigs.size} sigs:"
pp sigs


pp TestToken.is_abstract_contract

abi = TestToken.abi

pp TestToken.public_abi



##
## creates "empty" contract
##   use TestToken#constructor for new "deploy" or
##   use TestToken#deserialize/load for  restore (state) from storage
contract = TestToken.new
pp contract




alice   = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
bob     = '0x'+'b'*40 # e.g. '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'


## test globals (context)
pp contract.msg
pp contract.msg.sender
contract.msg.sender = alice
pp contract.msg.sender



initial_state = contract.serialize
pp initial_state  




contract.constructor(
               'My Fun Token',
               'FUN',
               18,
               21000000 )

state = contract.serialize

if state != initial_state
    puts "STATE CHANGE:"
    pp state
end





pp contract.name
pp contract.symbol
pp contract.decimals    
pp contract.totalSupply

## pp contract.balanceOf
pp contract.balanceOf( alice )





pp contract.transfer( bob, 
                    10000 )

state = contract.serialize
pp state



pp contract.balanceOf( alice )
pp contract.balanceOf( bob )



###
#  try another "deploy" of contract
contract2 = TestToken.construct(
                       'My Doge Token',
                       'DOG',
                       9,
                       42000000 )
pp contract2
pp contract2.serialize

contract2

pp contract2.serialize

##
# check old state
pp contract.serialize



puts "bye"