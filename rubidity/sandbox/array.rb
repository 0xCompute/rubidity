require_relative 'helper'



class TestArray < Contract   

    storage names:   array( :string ), 
            numbers: array( :uint256 ) 
  
    sig :constructor, []        
    def constructor
    end  
end  # class TestArray  
  


pp TestArray.state_variable_definitions
pp TestArray.parent_contracts 
pp TestArray.events 
pp TestArray.is_abstract_contract

abi = TestArray.abi

pp TestArray.public_abi
  

contract = TestArray.new
pp contract


## test globals (context)
pp contract.msg
pp contract.msg.sender
contract.msg.sender = '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'   # a(lice)
pp contract.msg.sender



initial_state = contract.serialize
pp initial_state  

contract.constructor()

pp contract.serialize

names = contract.instance_variable_get( :@names )
names[0] = 'hello'
pp contract.serialize

names.push( 'world' )
pp contract.serialize


pp contract.names( index: 0 )
pp contract.names( index: 1 )
pp contract.names( 0 )
pp contract.names( 1 )


numbers = contract.instance_variable_get( :@numbers )

numbers.push( 1 )
numbers.push( 2 )
numbers.push( 3 )

pp contract.numbers( index: 0 )
pp contract.numbers( index: 1 )
pp contract.numbers( 0 )
pp contract.numbers( 1 )


pp contract.serialize


puts "bye"
