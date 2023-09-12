##
# to run use:
#   $ ruby sandbox/hello2.rb


$LOAD_PATH.unshift( '../rubidity-typed/lib' )
$LOAD_PATH.unshift( './lib' )

require 'rubidity/typed'
require 'rubidity'



class TestToken < ContractImplementation    
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
        puts "hello from contructor"
      }

    function :transfer, { to: :addressOrDumbContract, amount: :uint256 }, :public, :virtual, returns: :bool do
        require(s.balanceOf[msg.sender] >= amount, 'Insufficient balance')
        
        s.balanceOf[msg.sender] -= amount
        s.balanceOf[to] += amount

        puts "hello from transfer"
    
        ## emit :Transfer, from: msg.sender, to: to, amount: amount
        
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
contract.msg.sender = '0xC2172a6315c1D7f6855768F843c420EbB36eDa97'
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

pp contract.balanceOf( '0xC2172a6315c1D7f6855768F843c420EbB36eDa97')



pp contract.transfer( '0xB2172a6315c1D7f6855768F843c420EbB36eDa98', 
                    10000 )

state = contract.state_proxy.serialize
pp state

pp contract.balanceOf( '0xC2172a6315c1D7f6855768F843c420EbB36eDa97')
pp contract.balanceOf( '0xB2172a6315c1D7f6855768F843c420EbB36eDa98')


puts "bye"