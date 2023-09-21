require_relative 'helper'



class TestBase < ContractBase    
    storage name: :string, 
            symbol: :string, 
            decimals: :uint256,    
            totalSupply: :uint256, 
            balanceOf: mapping( :addressOrDumbContract, :uint256 )
end  # class TestBase
  


pp TestBase.state_variable_definitions
pp TestBase.parent_contracts 
pp TestBase.events 
pp TestBase.is_abstract_contract

abi = TestBase.abi

pp TestBase.public_abi
  

puts "bye"
