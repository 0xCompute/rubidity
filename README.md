# Rubidity  -  Ruby for Layer 1 (L1) Contracts with "Off-Chain" Indexer

The idea -  only store ("serialized") method calls "on-chain" - 
the "state" and "transaction receipts" and so on are handled "off-chain" with indexers.

Why?  Way cheaper (> 4x!) only call data (no storage fees) 
and simpler than "classic" ethereum solidity contract, for example.



## What's Rubidity?

middlemarch (a.k.a. Tom Lehman) 
introduced dumb contracts on ethscriptions with the production code written in a dialect of Ruby called "Rubidity". 

Q: Why do you choose ruby for dump contracts? 

A: Because you can create a mini-language that's very similar to Solidity and will be easier for Solidity devs to use. 

For official doc(ument)s and sources see:

- <https://github.com/ethscriptions-protocol/ethscriptions-vm-server> - Source
- <https://docs.ethscriptions.com/v/ethscriptions-vm/rubidity/rubidity-by-example> - Documentation 
- <https://goerli.ethscriptionsvm.com/contracts> - Test Chain - Live!



## What's Happening Here?

This is a rubidity sandbox by [Gerald Bauer](https://github.com/geraldb) - not (yet) affiliated with 
ethscriptions or middlemarch (a.k.a. Tom Lehman).

The idea here is to experiment with rubidity "off-chain"
and if time permits break the "majestic rails rubidity monolith"
also known as "ethscriptions vm"
up into easier to (re)use modules.

For example, why not bundle up a "core" language "rubidity" gem with 
no dependencies on any blockchain.

Next, break out "core" contracts samples  and database (SQL) 
and runtime modules or such.



### Token Contract - Rubidity "Off-Chain" Example


Let's try a "off-chain" token contract with 
the "core" rubidity language  (only dependency is the active_support gem for delegate, Array#exclude? and such).

To run use:

$ ruby sandbox/hello.rb


``` ruby
require_relative '../lang/rubidity'


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
  

class ContractRecord    ## activerecord model class dummy 
    def initialize( type ) @type = type.name; end
    def type() @type;  end
end


rec = ContractRecord.new( TestToken )
pp rec.type               ## TestToken (string)
pp rec.type.constantize   ## TestToken (class) 


contract = TestToken.new( rec )
pp contract


## test globals (context)
pp contract.msg
pp contract.msg.sender
contract.msg.sender = '0xC2172a6315c1D7f6855768F843c420EbB36eDa97'
pp contract.msg.sender



initial_state = contract.state_proxy.serialize
pp initial_state  
#=> {"name"=>"", "symbol"=>"", "decimals"=>0, "totalSupply"=>0, "balanceOf"=>{}}
      

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
#=> {"name"=>"My Fun Token",
#    "symbol"=>"FUN",
#    "decimals"=>18,
#    "totalSupply"=>21000000,
#    "balanceOf"=>{"0xc2172a6315c1d7f6855768f843c420ebb36eda97"=>21000000}}

pp contract.name
#=> "My Fun Token"
pp contract.symbol
#=> "FUN"
pp contract.decimals    
#=> 18
pp contract.totalSupply
#=> 21000000

pp contract.balanceOf( '0xC2172a6315c1D7f6855768F843c420EbB36eDa97')
#=> 21000000


pp contract.transfer( '0xB2172a6315c1D7f6855768F843c420EbB36eDa98', 
                    10000 )

state = contract.state_proxy.serialize
pp state
#=> {"name"=>"My Fun Token",
#    "symbol"=>"FUN",
#    "decimals"=>18,
#    "totalSupply"=>21000000,
#    "balanceOf"=>
#    {"0xc2172a6315c1d7f6855768f843c420ebb36eda97"=>20990000, 
#     "0xb2172a6315c1d7f6855768f843c420ebb36eda98"=>10000}}

pp contract.balanceOf( '0xC2172a6315c1D7f6855768F843c420EbB36eDa97')
#=> 20990000 
pp contract.balanceOf( '0xB2172a6315c1D7f6855768F843c420EbB36eDa98')
#=> 10000

puts "bye"
```


And so on.  To be continued ...




## Bonus - More Blockchain (Crypto) Tools, Libraries & Scripts In Ruby

See [**/blockchain**](https://github.com/rubycocos/blockchain) 
at the ruby code commons (rubycocos) org.


