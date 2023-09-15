require_relative 'helper'



class TestArray < ContractImplementation    

     array :string,  :public, :names
     array :uint256, :public, :numbers
  
    constructor() { }
end  # class TestArray  
  


pp TestArray.state_variable_definitions
pp TestArray.parent_contracts 
pp TestArray.events 
pp TestArray.is_abstract_contract

abi = TestArray.abi

pp TestArray.public_abi
  

contract = TestArray.create
pp contract


## test globals (context)
pp contract.msg
pp contract.msg.sender
contract.msg.sender = '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'   # a(lice)
pp contract.msg.sender



initial_state = contract.state_proxy.serialize
pp initial_state  

contract.constructor()

pp contract.state_proxy.serialize

contract.s.names[0] = 'hello'
pp contract.s.serialize

contract.s.names.push( 'world' )
pp contract.s.serialize


pp contract.names( index: 0 )
pp contract.names( index: 1 )
pp contract.names( 0 )
pp contract.names( 1 )


contract.s.numbers.push( 1 )
contract.s.numbers.push( 2 )
contract.s.numbers.push( 3 )

pp contract.numbers( index: 0 )
pp contract.numbers( index: 1 )
pp contract.numbers( 0 )
pp contract.numbers( 1 )


pp contract.state_proxy.serialize


puts "bye"
