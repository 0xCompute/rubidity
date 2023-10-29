# Rubidity Classic / O.G. Builder


a new experiment trying the impossible and square the circle, that is, a rubidity "classic / o.g. dsl" builder 
generating rubidity "ruby-ish contract classes". 


let's try the PublicMintERC20 contract.


[ERC20](contracts/ERC20.rb) - base contract in rubidity classic / o.g. style

``` ruby
pragma :rubidity, "1.0.0"

contract :ERC20, abstract: true do
  event :Transfer, { from: :address, to: :address, amount: :uint256 }
  event :Approval, { owner: :address, spender: :address, amount: :uint256 }

  string :public, :name
  string :public, :symbol
  uint8 :public, :decimals
  
  uint256 :public, :totalSupply

  mapping ({ address: :uint256 }), :public, :balanceOf
  mapping ({ address: mapping(address: :uint256) }), :public, :allowance
  
  
  constructor(name: :string, symbol: :string, decimals: :uint8) do 
    s.name = name
    s.symbol = symbol
    s.decimals = decimals
  end


  function :approve, { spender: :address, amount: :uint256 }, :public, :virtual, returns: :bool do
    s.allowance[msg.sender][spender] = amount
    
    emit :Approval, owner: msg.sender, spender: spender, amount: amount
    
    return true
  end
  
  function :transfer, { to: :address, amount: :uint256 }, :public, :virtual, returns: :bool do
    require(s.balanceOf[msg.sender] >= amount, 'Insufficient balance')
    
    s.balanceOf[msg.sender] -= amount
    s.balanceOf[to] += amount

    emit :Transfer, from: msg.sender, to: to, amount: amount
    
    return true
  end
  
  function :transferFrom, {
    from: :address,
    to: :address,
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
  
  function :_mint, { to: :address, amount: :uint256 }, :internal, :virtual do
    s.totalSupply += amount
    s.balanceOf[to] += amount
    
    emit :Transfer, from: address(0), to: to, amount: amount
  end
  
  function :_burn, { from: :address, amount: :uint256 }, :internal, :virtual do
    s.balanceOf[from] -= amount
    s.totalSupply -= amount
    
    emit :Transfer, from: from, to: address(0), amount: amount
  end
end
```


[PublicMintERC20](contracts/PublicMintERC20.rb) - main contract in rubidity classic / o.g. style

``` ruby
pragma :rubidity, "1.0.0"

import './ERC20'

contract :PublicMintERC20, is: :ERC20 do
  uint256 :public, :maxSupply
  uint256 :public, :perMintLimit
  
  constructor(
    name: :string,
    symbol: :string,
    maxSupply: :uint256,
    perMintLimit: :uint256,
    decimals: :uint8
  ) do 
    super( name: name, symbol: symbol, decimals: decimals )
    s.maxSupply = maxSupply
    s.perMintLimit = perMintLimit
  end
  
  function :mint, { amount: :uint256 }, :public do
    require(amount > 0, 'Amount must be positive')
    require(amount <= s.perMintLimit, 'Exceeded mint limit')
    
    require(s.totalSupply + amount <= s.maxSupply, 'Exceeded max supply')
    
    _mint(to: msg.sender, amount: amount)
  end
  
  function :airdrop, { to: :address, amount: :uint256 }, :public do
    require(amount > 0, 'Amount must be positive')
    require(amount <= s.perMintLimit, 'Exceeded mint limit')
    
    require(s.totalSupply + amount <= s.maxSupply, 'Exceeded max supply')
    
    _mint(to: to, amount: amount)
  end
end
```



and now let's square the circle and try the impossible.
let's run the PublicMintERC20 contract.

``` ruby
require_relative 'builder'

source = Builder.load_file( 'PublicMintERC20' ).source
pp source
pp source.contracts

puts "  #{source.contracts.size} contract(s):"
source.contracts.each do |contract|
    print "   #{contract.name}"
    print " is #{contract.is.inspect}"   unless contract.is.empty?
    print "\n"
end

####################
#  generate contract classes
source.generate


#############
#  try out contract classes

pp ERC20
pp PublicMintERC20

pp ERC20.name
pp PublicMintERC20.name


pp ERC20::Transfer   ## {:from=>:address,  :to=>:address,      :amount=>:uint256}
pp ERC20::Approval   ## {:owner=>:address, :spender=>:address, :amount=>:uint256}
pp ERC20::Transfer.name 
pp ERC20::Approval.name

pp ERC20::Transfer.new( from: address(0), to: address(0), amount: 0)
pp ERC20::Approval.new( owner: address(0), spender: address(0), amount: 0)




contract = ERC20.new
pp contract
contract.constructor( name: 'My Fun Token',
                      symbol: 'FUN',
                      decimals: 18 )

pp contract

contract.__ERC20__constructor( name: 'My Fun Token',
                               symbol: 'FUN',
                               decimals: 18 )
pp contract



contract = PublicMintERC20.new
pp contract
## pp PublicMintERC20.instance_methods( :false )


contract.__ERC20__constructor( name: 'My Fun Token',
                               symbol: 'FUN',
                               decimals: 18 )
pp contract



## try call constructor
##  [debug] add sig args: [Types::String, Types::String, Types::UInt, Types::UInt, Types::UInt], opti

puts
puts "==========="

contract.constructor( name: 'My Fun Token',
                      symbol: 'FUN',
                      maxSupply: 21000000,
                      perMintLimit: 10000,
                      decimals: 18 )
pp contract
pp contract.serialize



### test drive

alice   = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
bob     = '0x'+'b'*40 # e.g. '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
charlie = '0x'+'c'*40 # e.g. '0xcccccccccccccccccccccccccccccccccccccccc'

pp alice
pp bob
pp charlie


## 
#   function :mint, { amount: :uint256 }, :public  
Runtime.msg.sender = alice

contract.mint( 1000 )   
contract.mint( 100 )   

pp contract.serialize



Runtime.msg.sender = bob

contract.mint( 500 )   
contract.mint( 10 )   
# contract.mint( 2000 )   

pp contract.serialize


pp contract.totalSupply
pp contract.balanceOf( alice )
pp contract.balanceOf( bob )
pp contract.serialize


##
# function :transfer, { to: :address, amount: :uint256 }, :public
Runtime.msg.sender = alice

contract.transfer( to: bob, amount: 111 )
contract.transfer( to: charlie, amount: 11 )


Runtime.msg.sender = bob

contract.transfer( to: alice, amount: 11 )
contract.transfer( to: charlie, amount: 111 )



pp contract.totalSupply
pp contract.balanceOf( alice )
pp contract.balanceOf( bob )
pp contract.balanceOf( charlie )
pp contract.serialize


# and so on
```

that's it.






## Questions? Comments?

Join us in the [Rubidity (community) discord (chat server)](https://discord.gg/3JRnDUap6y). Yes you can.
Your questions and commentary welcome.

Or post them over at the [Help & Support](https://github.com/geraldb/help) page. Thanks.

