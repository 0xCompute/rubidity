# Rubysol Contracts

 rubysol-contracts - standard contracts (incl. erc20, erc721, etc) for ruby for layer 1 (l1) with "off-chain" indexer
 
* home  :: [github.com/s6ruby/rubidity](https://github.com/s6ruby/rubidity)
* bugs  :: [github.com/s6ruby/rubidity/issues](https://github.com/s6ruby/rubidity/issues)
* gem   :: [rubygems.org/gems/rubysol-contracts](https://rubygems.org/gems/rubysol-contracts)
* rdoc  :: [rubydoc.info/gems/rubysol-contracts](http://rubydoc.info/gems/rubysol-contracts)




## What's Solidity?! What's Rubidity?! What's Rubysol?!

See [**Solidity - Contract Application Binary Interface (ABI) Specification** »](https://docs.soliditylang.org/en/latest/abi-spec.html)

See [**Rubidity - Ruby for Layer 1 (L1) Contracts / Protocols with "Off-Chain" Indexer**  »](https://github.com/s6ruby/rubidity)

See [**Rubysol - Ruby for Layer 1 (L1) Contracts / Protocols with "Off-Chain" Indexer**  »](https://github.com/s6ruby/rubidity/tree/master/rubysol)




## Usage

Let's try the PublicMintERC20 contract...

<details>
<summary markdown="1">Show Source</summary>

[contracts/public_mint_erc20.rb](lib/rubysol/contracts/public_mint_erc20.rb):

```ruby
class PublicMintERC20 < ERC20
  
  storage maxSupply:    UInt,
          perMintLimit: UInt 
  
  sig [String, String, UInt, UInt, UInt]
  def constructor(
    name:,
    symbol:,
    maxSupply:,
    perMintLimit:,
    decimals:
  ) 
    super( name: name, 
           symbol: symbol, 
           decimals: decimals)
 
    @maxSupply    = maxSupply
    @perMintLimit = perMintLimit
  end
 

  sig  [UInt]
  def mint( amount: )
    assert(amount > 0, 'Amount must be positive')
    assert(amount <= @perMintLimit, 'Exceeded mint limit')
    
    assert( @totalSupply + amount <= @maxSupply, 'Exceeded max supply')
    
    _mint(to: msg.sender, amount: amount)
  end
  
  sig [Address, UInt]
  def airdrop( to:, amount: ) 
    assert(amount > 0, 'Amount must be positive')
    assert(amount <= @perMintLimit, 'Exceeded mint limit')
    
    assert(@totalSupply + amount <= @maxSupply, 'Exceeded max supply')
    
    _mint(to: to, amount: amount)
  end
end
```

</details>

that builds on the ERC20 (base) contract.

<details>
<summary markdown="1">Show Source</summary>

[contracts/erc20.rb](lib/rubysol/contracts/erc20.rb):

```ruby
class ERC20 < Contract
  
  event :Transfer, from:    Address, 
                   to:      Address, 
                   amount:  UInt
  event :Approval, owner:   Address, 
                   spender: Address, 
                   amount:  UInt

  storage name:        String, 
          symbol:      String,  
          decimals:    UInt, 
          totalSupply: UInt, 
          balanceOf:   mapping( Address, UInt ), 
          allowance:   mapping( Address, mapping( Address, UInt ))
          

  sig [String, String, UInt] 
  def constructor(name:, 
                  symbol:, 
                  decimals:) 
    @name = name
    @symbol = symbol
    @decimals = decimals
  end


  sig [Address, UInt], returns: Bool
  def approve( spender:, 
               amount: ) 
    @allowance[msg.sender][spender] = amount
    
    log Approval, owner: msg.sender, spender: spender, amount: amount
    
    true
  end
  

  sig [Address, UInt],  returns: Bool
  def decreaseAllowanceUntilZero( spender:, 
                                  difference: )
    allowed = @allowance[msg.sender][spender]
    
    newAllowed = allowed > difference ? allowed - difference : 0
    
    approve(spender: spender, amount: newAllowed)
    
    true
  end


  sig [Address, UInt],  returns: Bool
  def transfer( to:, 
                amount: )
    assert @balanceOf[msg.sender] >= amount, 'Insufficient balance'
    
    @balanceOf[msg.sender] -= amount
    @balanceOf[to] += amount

    log Transfer, from: msg.sender, to: to, amount: amount
    
    true
  end
  
  sig [Address, Address, UInt], returns: Bool
  def transferFrom( 
       from:,
       to:,
       amount:)
    allowed = @allowance[from][msg.sender]
    
    assert @balanceOf[from] >= amount, 'Insufficient balance'
    assert allowed >= amount, 'Insufficient allowance'
    
    @allowance[from][msg.sender] = allowed - amount
    
    @balanceOf[from] -= amount
    @balanceOf[to] += amount
    
    log Transfer, from: from, to: to, amount: amount
    
    true
  end
  
  sig [Address, UInt]
  def _mint( to:,
             amount: )
    @totalSupply += amount
    @balanceOf[to] += amount
    
    log Transfer, from: address(0), to: to, amount: amount
  end
  
  sig [Address, UInt]
  def _burn( from:, 
             amount: )
     @balanceOf[from] -= amount
     @totalSupply -= amount
    
     log Transfer, from: from, to: address(0), amount: amount
  end
end
```

</details>



Let's go.

``` ruby
require 'rubysol/contracts'

contract = PublicMintERC20.construct(
    name: 'My Fun Token',  # String,
    symbol: 'FUN',         # String,
    maxSupply:  21000000,  #  UInt,
    perMintLimit: 1000,    #  UInt,
    decimals:     18,      #  UInt
  ) 


contract.serialize
# {:name=>"My Fun Token",
#   :symbol=>"FUN",
#   :decimals=>18,
#   :totalSupply=>0,
#   :balanceOf=>{},
#   :allowance=>{},
#   :maxSupply=>21000000,
# :perMintLimit=>1000}

alice   = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
bob     = '0x'+'b'*40 # e.g. '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
charlie = '0x'+'c'*40 # e.g. '0xcccccccccccccccccccccccccccccccccccccccc'


#  sig [UInt]
#  def mint( amount: )
contract.msg.sender = alice

contract.mint( 100 )
contract.mint( 200 )

contract.msg.sender = bob

contract.mint( 300 )
contract.mint( 400 )

#  sig [Address, UInt]
#  def airdrop( to:, amount: ) 
contract.airdrop( alice, 500 )
contract.airdrop( charlie, 600  )

contract.serialize
# {:name=>"My Fun Token",
#  :symbol=>"FUN",
#  :decimals=>18,
#  :totalSupply=>2100,
#  :balanceOf=>
#  {"0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"=>800,
#   "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"=>700,
#   "0xcccccccccccccccccccccccccccccccccccccccc"=>600},
# :allowance=>{},
# :maxSupply=>21000000,
# :perMintLimit=>1000}


#  sig [Address, UInt],  returns: Bool
#  def transfer( to:, amount: )
contract.transfer( alice, 1  )
contract.transfer( charlie, 2  )

#  sig [Address, UInt], returns: Bool
#  def approve( spender:, amount: ) 
contract.approve( alice, 11 )
contract.approve( charlie, 22 )


# sig [Address, Address, UInt], returns: Bool
# def transferFrom( from:, to:, amount:)
contract.msg.sender = alice

contract.approve( bob, 33 )

contract.transferFrom( bob, charlie, 3 )
contract.transferFrom( bob, alice, 4 )

contract.serialize
# {:name=>"My Fun Token",
#  :symbol=>"FUN",
#  :decimals=>18,
#  :totalSupply=>2100,
#  :balanceOf=> 
#  {"0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"=>805,
#   "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"=>690,
#   "0xcccccccccccccccccccccccccccccccccccccccc"=>605},
#  :allowance=>
#  {"0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"=> {
#      "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"=>4, 
#      "0xcccccccccccccccccccccccccccccccccccccccc"=>22},
#   "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"=> {
#      "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"=>33}},
# :maxSupply=>21000000,
# :perMintLimit=>1000}
```

And so on. That's it for now.



## Bonus - More Blockchain (Crypto) Tools, Libraries & Scripts In Ruby

See [**/blockchain**](https://github.com/rubycocos/blockchain) 
at the ruby code commons (rubycocos) org.





## Questions? Comments?

Join us in the [Rubidity & Rubysol (community) discord (chat server)](https://discord.gg/3JRnDUap6y). Yes you can.
Your questions and commentary welcome.

Or post them over at the [Help & Support](https://github.com/geraldb/help) page. Thanks.


