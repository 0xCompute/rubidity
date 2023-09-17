# Rubidity Contracts

 rubidity-contracts - standard contracts (incl. erc20, erc721, etc) for ruby for layer 1 (l1) with "off-chain" indexer
 
* home  :: [github.com/s6ruby/rubidity](https://github.com/s6ruby/rubidity)
* bugs  :: [github.com/s6ruby/rubidity/issues](https://github.com/s6ruby/rubidity/issues)
* gem   :: [rubygems.org/gems/rubidity-contracts](https://rubygems.org/gems/rubidity-contracts)
* rdoc  :: [rubydoc.info/gems/rubidity-contracts](http://rubydoc.info/gems/rubidity-contracts)



## What's Rubidity?!

See [**Rubidity - Ruby for Layer 1 (L1) Contracts / Protocols with "Off-Chain" Indexer**  »](https://github.com/s6ruby/rubidity)




## Usage

Let's try the PublicMintERC20 contract...

<details>
<summary markdown="1">Show Source</summary>

[contracts/public_mint_erc20.rb](lib/rubidity/contracts/public_mint_erc20.rb):

```ruby
class PublicMintERC20 < ContractImplementation
  is ERC20
  
  uint256 :public, :maxSupply
  uint256 :public, :perMintLimit
  
  constructor(
    name: :string,
    symbol: :string,
    maxSupply: :uint256,
    perMintLimit: :uint256,
    decimals: :uint256
  ) {
    ERC20(name: name, symbol: symbol, decimals: decimals)
    s.maxSupply = maxSupply
    s.perMintLimit = perMintLimit
  }
  
  function :mint, { amount: :uint256 }, :public do
    require(amount > 0, 'Amount must be positive')
    require(amount <= s.perMintLimit, 'Exceeded mint limit')
    
    require(s.totalSupply + amount <= s.maxSupply, 'Exceeded max supply')
    
    _mint(to: msg.sender, amount: amount)
  end
  
  function :airdrop, { to: :addressOrDumbContract, amount: :uint256 }, :public do
    require(amount > 0, 'Amount must be positive')
    require(amount <= s.perMintLimit, 'Exceeded mint limit')
    
    require(s.totalSupply + amount <= s.maxSupply, 'Exceeded max supply')
    
    _mint(to: to, amount: amount)
  end
end
```

</details>

that builds on the ERC20 (base) contract.

<details>
<summary markdown="1">Show Source</summary>

[contracts/erc20.rb](lib/rubidity/contracts/erc20.rb):

```ruby
class ERC20 < ContractImplementation
  pragma :rubidity, "1.0.0"
  
  abstract
  
  event :Transfer, { from: :addressOrDumbContract, to: :addressOrDumbContract, amount: :uint256 }
  event :Approval, { owner: :addressOrDumbContract, spender: :addressOrDumbContract, amount: :uint256 }

  string :public, :name
  string :public, :symbol
  uint256 :public, :decimals
  
  uint256 :public, :totalSupply

  mapping ({ addressOrDumbContract: :uint256 }), :public, :balanceOf
  mapping ({ addressOrDumbContract: mapping(addressOrDumbContract: :uint256) }), :public, :allowance
  
  constructor(name: :string, symbol: :string, decimals: :uint256) {
    s.name = name
    s.symbol = symbol
    s.decimals = decimals
  }

  function :approve, { spender: :addressOrDumbContract, amount: :uint256 }, :public, :virtual, returns: :bool do
    s.allowance[msg.sender][spender] = amount
    
    emit :Approval, owner: msg.sender, spender: spender, amount: amount
    
    return true
  end
  
  function :decreaseAllowanceUntilZero, { spender: :addressOrDumbContract, difference: :uint256 }, :public, :virtual, returns: :bool do
    allowed = s.allowance[msg.sender][spender]
    
    newAllowed = allowed > difference ? allowed - difference : 0
    
    approve(spender: spender, amount: newAllowed)
    
    return true
  end
  
  function :transfer, { to: :addressOrDumbContract, amount: :uint256 }, :public, :virtual, returns: :bool do
    require(s.balanceOf[msg.sender] >= amount, 'Insufficient balance')
    
    s.balanceOf[msg.sender] -= amount
    s.balanceOf[to] += amount

    # emit :Transfer, from: msg.sender, to: to, amount: amount
    
    return true
  end
  
  function :transferFrom, {
    from: :addressOrDumbContract,
    to: :addressOrDumbContract,
    amount: :uint256
  }, :public, :virtual, returns: :bool do
    allowed = s.allowance[from][msg.sender]
    
    require(s.balanceOf[from] >= amount, 'Insufficient balance')
    require(allowed >= amount, 'Insufficient allowance')
    
    s.allowance[from][msg.sender] = allowed - amount
    
    s.balanceOf[from] -= amount
    s.balanceOf[to] += amount
    
    emit :Transfer, from: from, to: to, amount: amount
    
    return true
  end
  
  function :_mint, { to: :addressOrDumbContract, amount: :uint256 }, :internal, :virtual do
    s.totalSupply += amount
    s.balanceOf[to] += amount
    
    # emit :Transfer, from: address(0), to: to, amount: amount
  end
  
  function :_burn, { from: :addressOrDumbContract, amount: :uint256 }, :internal, :virtual do
    s.balanceOf[from] -= amount
    s.totalSupply -= amount
    
    emit :Transfer, from: from, to: address(0), amount: amount
  end
end
```

</details>



Let's go.

``` ruby
require 'rubidity/contracts'

contract = PublicMintERC20.create

contract.constructor(
    name: 'My Fun Token', # :string,
    symbol: 'FUN',        # :string,
    maxSupply:  21000000,  #  :uint256,
    perMintLimit: 1000,    #  :uint256,
    decimals:     18,      #  :uint256
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

#  function :mint, { amount: :uint256 }, :public  
contract.msg.sender = alice

contract.mint( 100 )
contract.mint( 200 )

contract.msg.sender = bob

contract.mint( 300 )
contract.mint( 400 )

#  function :airdrop, { to: :addressOrDumbContract, amount: :uint256 }, :public
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


#   function :transfer, { to: :addressOrDumbContract, amount: :uint256 }, :public, :virtual, returns: :bool
contract.transfer( alice, 1  )
contract.transfer( charlie, 2  )

#   function :approve, { spender: :addressOrDumbContract, amount: :uint256 }, :public, :virtual, returns: :bool do
contract.approve( alice, 11 )
contract.approve( charlie, 22 )

# function :transferFrom, {
#  from: :addressOrDumbContract,
#  to: :addressOrDumbContract,
#  amount: :uint256
# }, :public, :virtual, returns: :bool

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

