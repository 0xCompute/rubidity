require_relative 'helper'



class TestBase < ContractBase    
    string :public, :name
    string :public, :symbol
    uint256 :public, :decimals    
    uint256 :public, :totalSupply
  
    mapping ({ addressOrDumbContract: :uint256 }), :public, :balanceOf


end  # class TestBase
  


pp TestBase.state_variable_definitions
pp TestBase.parent_contracts 
pp TestBase.events 
pp TestBase.is_abstract_contract

abi = TestBase.abi

pp TestBase.public_abi
  

puts "bye"
