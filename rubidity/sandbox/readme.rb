require_relative 'helper'



class TestToken < ContractImplementation    
 
    event :Transfer, { from: :addressOrDumbContract, 
                       to: :addressOrDumbContract, 
                       amount: :uint256 }
 
    string :public, :name
    string :public, :symbol
    uint256 :public, :decimals    
    uint256 :public, :totalSupply
  
    mapping ({ addressOrDumbContract: :uint256 }), :public, :balanceOf


    constructor(name: :string, 
                symbol: :string, 
                decimals: :uint256,
                totalSupply: :uint256) {
        s.name = name
        s.symbol = symbol
        s.decimals = decimals
        s.totalSupply = totalSupply

        s.balanceOf[msg.sender] = totalSupply
      }

    function :transfer, { to: :addressOrDumbContract, amount: :uint256 }, :public, :virtual, returns: :bool do
        assert(s.balanceOf[msg.sender] >= amount, 'Insufficient balance')
        
        s.balanceOf[msg.sender] -= amount
        s.balanceOf[to] += amount
   
        emit :Transfer, from: msg.sender, to: to, amount: amount        
        return true
    end
end  # class TestToken  
  


pp TestToken.state_variable_definitions
pp TestToken.parent_contracts 
pp TestToken.events 
pp TestToken.is_abstract_contract

abi = TestToken.abi

pp TestToken.public_abi
  

contract = TestToken.create
pp contract


## test globals (context)
pp contract.msg
pp contract.msg.sender
contract.msg.sender = '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'   # a(lice)
pp contract.msg.sender



pp contract.serialize
#=> {:name=>"", :symbol=>"", :decimals=>0, :totalSupply=>0, :balanceOf=>{}}
      

contract.constructor(
               'My Fun Token',
               'FUN',
               18,
               21000000 )

pp contract.serialize

#=> {:name=>"My Fun Token",
#    :symbol=>"FUN",
#    :decimals=>18,
#    :totalSupply=>21000000,
#    :balanceOf=>{'0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"=>21000000}}

pp contract.name
#=> "My Fun Token"
pp contract.symbol
#=> "FUN"
pp contract.decimals    
#=> 18
pp contract.totalSupply
#=> 21000000

pp contract.balanceOf( '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')
#=> 21000000


pp contract.transfer( '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb', 
                    10000 )

pp contract.serialize
#=> {:name=>"My Fun Token",
#    :symbol=>"FUN",
#    :decimals=>18,
#    :totalSupply=>21000000,
#    :balanceOf=>
#    {"0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"=>20990000, 
#     "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"=>10000}}

pp contract.balanceOf( '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')
#=> 20990000 
pp contract.balanceOf( '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb')
#=> 10000

puts "bye"
