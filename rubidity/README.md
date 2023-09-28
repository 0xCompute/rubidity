# Rubidity 

rubidity - ruby for (blockchain) layer 1 (l1) contracts / protocols with "off-chain" indexer; 100% compatible with solidity datatypes and abis


* home  :: [github.com/s6ruby/rubidity](https://github.com/s6ruby/rubidity)
* bugs  :: [github.com/s6ruby/rubidity/issues](https://github.com/s6ruby/rubidity/issues)
* gem   :: [rubygems.org/gems/rubidity](https://rubygems.org/gems/rubidity)
* rdoc  :: [rubydoc.info/gems/rubidity](http://rubydoc.info/gems/rubidity)




## What's Rubidity?!

See [**Rubidity - Ruby for Layer 1 (L1) Contracts / Protocols with "Off-Chain" Indexer**  »](https://github.com/s6ruby/rubidity)


## Usage

### Token Contract - Rubidity "Off-Chain" Example

Let's try an "off-chain" token contract with 
the "core" rubidity language.


``` ruby
require 'rubidity'


class TestToken < Contract    

    event :Transfer, { from:   Address, 
                       to:     Address, 
                       amount: UInt }

    storage  name:        String, 
             symbol:      String, 
             decimals:    UInt,       
             totalSupply: UInt,
             balanceOf:   mapping( Address, UInt) 


    sig :constructor, [String, String, UInt, UInt] 
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

    sig :transfer, [Address, UInt], returns: Bool 
    def transfer( to:, amount: )
        assert @balanceOf[msg.sender] >= amount, 'Insufficient balance'
        
        @balanceOf[msg.sender] -= amount
        @balanceOf[to] += amount
   
        log :Transfer, from: msg.sender, to: to, amount: amount        
        true
    end
end  # class TestToken  
```


and let's test run the contract ....

``` ruby
pp TestToken.state_variable_definitions
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
#=> {:name=>"", 
#    :symbol=>"", 
#    :decimals=>0, 
#    :totalSupply=>0, 
#    :balanceOf=>{}}
      

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
```


And so on.  To be continued ...



## Bonus - More Blockchain (Crypto) Tools, Libraries & Scripts In Ruby

See [**/blockchain**](https://github.com/rubycocos/blockchain) 
at the ruby code commons (rubycocos) org.





