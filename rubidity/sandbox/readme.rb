require_relative 'helper'



class TestToken < Contract    
 
    event :Transfer, { from:   :address, 
                       to:     :address, 
                       amount: :uint256 }
 
    storage  name:        :string, 
             symbol:      :string, 
             decimals:    :uint256,      
             totalSupply: :uint256, 
             balanceOf:    mapping( :address, :uint256 )


    sig :constructor, [:string, :string, :uint256, :uint256]
    def constructor(name:, 
                symbol:, 
                decimals:,
                totalSupply:) 
        @name = name
        @symbol = symbol
        @decimals = decimals
        @totalSupply = totalSupply

        @balanceOf[msg.sender] = totalSupply
    end

    sig :transfer, [:address, :uint256], :public, :virtual, returns: :bool 
    def transfer( to:, 
                  amount: )
        assert @balanceOf[msg.sender] >= amount, 'Insufficient balance'
        
        @balanceOf[msg.sender] -= amount
        @balanceOf[to] += amount
   
        log :Transfer, from: msg.sender, to: to, amount: amount        
        true
    end
end  # class TestToken  
  


pp TestToken.state_variable_definitions
pp TestToken.parent_contracts 
pp TestToken.events 
pp TestToken.is_abstract_contract

abi = TestToken.abi

pp TestToken.public_abi
  

contract = TestToken.new
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
