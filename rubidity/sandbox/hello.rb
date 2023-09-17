##
# to runu use:
#   $ ruby sandbox/hello.rb


require_relative 'helper'


pp Type.value_types


require_relative 'testtoken'



pp TestToken.state_variable_definitions
pp TestToken.parent_contracts 
pp TestToken.events 


pp TestToken.is_abstract_contract

abi = TestToken.abi

pp TestToken.public_abi


contract = TestToken.create
pp contract


alice   = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
bob     = '0x'+'b'*40 # e.g. '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'


## test globals (context)
pp contract.msg
pp contract.msg.sender
contract.msg.sender = alice
pp contract.msg.sender



initial_state = contract.state_proxy.serialize
pp initial_state  

      

contract.constructor(
               'My Fun Token',
               'FUN',
               18,
               21000000 )

state = contract.state_proxy.serialize

if state != initial_state
    puts "STATE CHANGE:"
    pp state
end

pp contract.name
pp contract.symbol
pp contract.decimals    
pp contract.totalSupply

pp contract.balanceOf( alice )



pp contract.transfer( bob, 
                    10000 )

state = contract.state_proxy.serialize
pp state



pp contract.balanceOf( alice )
pp contract.balanceOf( bob )


puts "bye"