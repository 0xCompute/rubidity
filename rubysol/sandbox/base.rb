require_relative 'helper'



class TestBase < Contract    
    storage name:   String, 
            symbol: String, 
            decimals: UInt,    
            totalSupply: UInt, 
            balanceOf: mapping( Address, UInt )
end  # class TestBase
  


pp TestBase.state_variable_definitions
pp TestBase.parent_contracts 
pp TestBase.events 
pp TestBase.is_abstract_contract

abi = TestBase.abi

pp TestBase.public_abi
  

puts "bye"
