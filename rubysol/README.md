# Rubysol  

rubysol - ruby for (blockchain) layer 1 (l1) contracts / protocols with "off-chain" indexer; 100% compatible with solidity datatypes and abis


* home  :: [github.com/s6ruby/rubidity](https://github.com/s6ruby/rubidity)
* bugs  :: [github.com/s6ruby/rubidity/issues](https://github.com/s6ruby/rubidity/issues)
* gem   :: [rubygems.org/gems/rubysol](https://rubygems.org/gems/rubysol)
* rdoc  :: [rubydoc.info/gems/rubysol](http://rubydoc.info/gems/rubysol)



## What's Solidity?! What's Rubidity?! What's Rubysol?!

See [**Solidity - Contract Application Binary Interface (ABI) Specification** »](https://docs.soliditylang.org/en/latest/abi-spec.html)

See [**Rubidity - Ruby for Layer 1 (L1) Contracts / Protocols with "Off-Chain" Indexer**  »](https://github.com/s6ruby/rubidity)




## Usage

### Token Contract - Rubysol "Off-Chain" Example

Let's try an "off-chain" token contract with 
the "core" rubysol language.


``` ruby
require 'rubysol'


class TestToken < Contract    

    event :Transfer, from:   Address, 
                     to:     Address, 
                     amount: UInt 

    storage  name:        String, 
             symbol:      String, 
             decimals:    UInt,       
             totalSupply: UInt,
             balanceOf:   mapping( Address, UInt ) 


    sig [String, String, UInt, UInt] 
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

    sig [Address, UInt], returns: Bool 
    def transfer( to:, amount: )
        assert @balanceOf[msg.sender] >= amount, 'Insufficient balance'
        
        @balanceOf[msg.sender] -= amount
        @balanceOf[to] += amount
   
        log Transfer, from: msg.sender, to: to, amount: amount        
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




## Questions? Comments?

Join us in the [Rubidity & Rubysol (community) discord (chat server)](https://discord.gg/3JRnDUap6y). Yes you can.
Your questions and commentary welcome.

Or post them over at the [Help & Support](https://github.com/geraldb/help) page. Thanks.



