# Rubidity Classic / O.G. Contract Builder


rubidity-classic gem - rubidity classic / o.g. contract builder; trying the impossible and square the circle, that is, a rubidity "classic / o.g." dsl builder generating rubidity "more ruby-ish" contract classes. 


* home  :: [github.com/s6ruby/rubidity](https://github.com/s6ruby/rubidity)
* bugs  :: [github.com/s6ruby/rubidity/issues](https://github.com/s6ruby/rubidity/issues)
* gem   :: [rubygems.org/gems/rubidity-classic](https://rubygems.org/gems/rubidity-classic)
* rdoc  :: [rubydoc.info/gems/rubidity-classic](http://rubydoc.info/gems/rubidity-classic)



## What's Solidity?! What's Rubidity?!

See [**Solidity - Contract Application Binary Interface (ABI) Specification** »](https://docs.soliditylang.org/en/latest/abi-spec.html)

See [**Rubidity - Ruby for Layer 1 (L1) Contracts / Protocols with "Off-Chain" Indexer**  »](https://github.com/s6ruby/rubidity)






## Usage

[Contract Sample №1 - HelloWorld](#contract-sample-1---helloworld) •
[Contract Sample №2 - PublicMintERC20](#contract-sample-2---publicminterc20) •
[Contract Sample №3 - SupplyChain](#contract-sample-3---supplychain)


### Contract Sample №1 - HelloWorld 

Let's try the HelloWorld contract.

[HelloWorld](contracts/HelloWorld.rb) - main contract in rubidity classic / o.g. style

``` ruby
pragma :rubidity, "1.0.0"

contract :HelloWorld do
  function :getHelloWorld, {}, :public, :pure, returns: :string do
    return "Hello, world!"
  end
end
```

Now let's square the circle and try the impossible.
Let's run the HelloWorld contract.


``` ruby
require 'rubidity/classic'

# load (parse) and generate contract classes
Contract.load( 'HelloWorld' )


#  try out contract classes
pp HelloWorld
pp HelloWorld.name

contract = HelloWorld.new
pp contract

pp contract.getHelloWorld
#=> "Hello, world!"
```




### Contract Sample №2 - PublicMintERC20 

Let's try the PublicMintERC20 contract.


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



Now let's square the circle and try the impossible.
Let's run the PublicMintERC20 contract.


``` ruby
require 'rubidity/classic'

# load (parse) and generate contract classes
Contract.load( 'PublicMintERC20' )


# try out contract classes
pp ERC20
pp PublicMintERC20

pp ERC20.name
pp PublicMintERC20.name

pp ERC20::Transfer   # "scoped" (typed) Event class
pp ERC20::Approval   # "scoped" (typed) Event class
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


contract = PublicMintERC20.new
pp contract
contract.constructor( name: 'My Fun Token',
                      symbol: 'FUN',
                      maxSupply: 21000000,
                      perMintLimit: 10000,
                      decimals: 18 )
pp contract
pp contract.serialize


# test drive with alice, bob & charlie address

alice   = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
bob     = '0x'+'b'*40 # e.g. '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
charlie = '0x'+'c'*40 # e.g. '0xcccccccccccccccccccccccccccccccccccccccc'

pp alice
pp bob
pp charlie


# try mint  
Runtime.msg.sender = alice

contract.mint( 1000 )   
contract.mint( 100 )   

pp contract.serialize



Runtime.msg.sender = bob

contract.mint( 500 )   
contract.mint( 10 )   

pp contract.serialize


pp contract.totalSupply
pp contract.balanceOf( alice )
pp contract.balanceOf( bob )
pp contract.serialize



# try transfer
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
#=> {:name=>"My Fun Token",
#    :symbol=>"FUN",
#    :decimals=>18,
#    :totalSupply=>1610,
#    :balanceOf=>
#     {"0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"=>989,
#      "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"=>499,
#      "0xcccccccccccccccccccccccccccccccccccccccc"=>122},
#    :allowance=>{},
#    :maxSupply=>21000000,
#    :perMintLimit=>10000}

# and so on.
```

that's it.



### Contract Sample №3 - SupplyChain 

Let's try the SupplyChain contract.

[SupplyChain](contracts/SupplyChain.rb) - main contract in rubidity classic / o.g. style


``` ruby
pragma :rubidity, "1.0.0"

contract :SupplyChain do

  event :Transfer, { productId: :uint32 }

  struct :Product, { modelNumber:  :string,
                     partNumber:   :string,
                     serialNumber: :string,
                     productOwner: :address,
                     cost:         :uint32,
                     mfgTimestamp: :timestamp }

  struct :Participant, { userName: :string,
                         password: :string,
                         participantType: :string,
                         participantAddress: :address }

  struct :Registration, { productId:    :uint32,  
                          ownerId:      :uint32, 
                          productOwner: :address,
                          trxTimestamp: :timestamp }                    
 
  uint32 :public, :p_id    # (last) product id 
  uint32 :public, :u_id    # (last) participant id
  uint32 :public, :r_id    # (last) registration id

  mapping ({ uint32: :Product }),      :public, :products
  mapping ({ uint32: :Participant }),  :public, :participants
  mapping ({ uint32: :Registration }), :public, :registrations

  # movement track for a product
  mapping ({ uint32: array( :uint32 ) }), :public, :productTrack  


  function :createParticipant, { name: :string, 
                                 pass: :string, 
                                 addr: :address, 
                                 type: :string }, :public, returns: :uint32 do
      userId = s.u_id += 1
      s.participants[ userId ].userName = name
      s.participants[ userId ].password = pass
      s.participants[ userId ].participantAddress = addr
      s.participants[ userId ].participantType = type
      return userId
  end

  function :getParticipantDetails, { id: :uint32 }, :public, :view, returns: [:string,:address,:string] do
    return [s.participants[ id ].userName,
            s.participants[ id ].participantAddress,
            s.participants[ id ].participantType]
  end

  function :createProduct, { ownerId: :uint32,
                             modelNumber: :string,
                             partNumber: :string,
                             serialNumber: :string,
                             productCost: :uint32 }, :public, returns: :uint32 do     
      require( s.participants[ ownerId ].participantType == "manufacturer",  "must be manufacturer" ) 
      
      productId = s.p_id += 1
      s.products[ productId ].modelNumber  = modelNumber
      s.products[ productId ].partNumber   = partNumber
      s.products[ productId ].serialNumber = serialNumber
      s.products[ productId ].cost         = productCost
      s.products[ productId ].productOwner = s.participants[ownerId].participantAddress
      s.products[ productId ].mfgTimestamp = block.timestamp
      return productId
  end

  function :getProductDetails, { id: :uint32 }, :public, :view, returns: [:string,:string,:string,:uint32,:address,:timestamp] do
      return [s.products[ id ].modelNumber,
              s.products[ id ].partNumber,
              s.products[ id ].serialNumber,
              s.products[ id ].cost,
              s.products[ id ].productOwner,
              s.products[ id ].mfgTimestamp]
  end
   
  function :transferToOwner, { user1Id: :uint32,
                               user2Id: :uint32, 
                               prodId: :uint32 }, :public, returns: :bool do
        require( msg.sender == s.products[prodId].productOwner, "only owner" )

        p1 = s.participants[ user1Id ]
        p2 = s.participants[ user2Id ]
        registrationId = s.r_id += 1
        
        s.registrations[ registrationId ].productId    = prodId
        s.registrations[ registrationId ].productOwner = p2.participantAddress 
        s.registrations[ registrationId ].ownerId      = user2Id
        s.registrations[ registrationId ].trxTimestamp = block.timestamp

        s.products[ prodId ].productOwner = p2.participantAddress
        s.productTrack[ prodId ].push( registrationId )

        emit :Transfer, prodId

        return true
  end
  
  function :getProductTrack, { prodId: :uint32 }, :public, :view, returns: array(:uint32) do 
      return s.productTrack[ prodId ]
  end

  function :getRegistrationDetails, { regId: :uint32 }, :public, :view, returns: [:uint32, :uint32, :address, :timestamp] do
      r = s.registrations[ regId ]

      return [r.productId,
              r.ownerId,
              r.productOwner,
              r.trxTimestamp]
  end
end
```

Now let's square the circle and try the impossible.
Let's run the SupplyChain contract.


``` ruby
require 'rubidity/classic'

# load (parse) and generate contract classes
Contract.load( 'SupplyChain' )

#  try out contract classes
pp SupplyChain
pp SupplyChain.name

pp SupplyChain::Transfer
pp SupplyChain::Transfer.name

pp SupplyChain::Transfer.new( productId: 111 )

pp SupplyChain::Product
pp SupplyChain::Participant
pp SupplyChain::Registration
pp SupplyChain::Product.name
pp SupplyChain::Participant.name
pp SupplyChain::Registration.name


alice   = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
bob     = '0x'+'b'*40 # e.g. '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
charlie = '0x'+'c'*40 # e.g. '0xcccccccccccccccccccccccccccccccccccccccc'

pp alice
pp bob
pp charlie

pp SupplyChain::Product.new( modelNumber: 'model1',
                             partNumber:  'part1',
                             serialNumber: 'serial1',
                             productOwner: alice,
                             cost:         1000,
                             mfgTimestamp: 1698756267 )
                   
pp SupplyChain::Participant.new( userName: 'alice',
                                 password: 'passa',
                                 participantType: 'manufacturer',
                                 participantAddress: alice )

pp SupplyChain::Registration.new( productId:  1,  
                                   ownerId:   1, 
                                   productOwner: alice,
                                   trxTimestamp: 1698756267 )                    


contract = SupplyChain.new
pp contract

pp contract.p_id
pp contract.u_id
pp contract.r_id

pp contract.serialize
#=>
# {:p_id=>0, :u_id=>0, :r_id=>0,
#  :products=>{}, 
#  :participants=>{}, 
#  :registrations=>{}, 
#  :productTrack=>{}}


pp contract.createParticipant( name: 'alice', 
                               pass: 'passa', 
                               addr: alice, 
                               type: 'manufacturer' )

pp contract.createParticipant( name: 'bob', 
                               pass: 'passb', 
                               addr: bob, 
                               type: 'supplier' )

pp contract.createParticipant( name: 'charlie', 
                               pass: 'passc', 
                               addr: charlie, 
                               type: 'consumer' )

pp contract.getParticipantDetails( 1 )
pp contract.getParticipantDetails( 2 )
pp contract.getParticipantDetails( 3 )



Runtime.block.timestamp = 1698846375

pp contract.createProduct( ownerId: 1,
                             modelNumber: 'prod1',
                             partNumber: '100',
                             serialNumber: '123',
                             productCost: 11 )

pp contract.getProductDetails( 1 )


Runtime.msg.sender = alice
Runtime.block.timestamp = 1698847541

pp contract.transferToOwner( user1Id: 1,
                             user2Id: 2, 
                             prodId: 1 )

Runtime.msg.sender = bob
Runtime.block.timestamp = 1698848314

pp contract.transferToOwner( user1Id: 2,
                             user2Id: 3, 
                             prodId: 1 )


pp contract.getRegistrationDetails( 1 )
pp contract.getRegistrationDetails( 2 )

pp contract.getProductTrack( 1 )

pp contract.serialize
#=> {:p_id=>1,
#    :u_id=>3,
#    :r_id=>2,
#    :products=>{1=>["prod1", "100", "123", "0xcccccccccccccccccccccccccccccccccccccccc", 11, 1698846375]},
#   :participants=>
#    {1=>["alice", "passa", "manufacturer", "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"],
#     2=>["bob", "passb", "supplier", "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"],
#     3=>["charlie", "passc", "consumer", "0xcccccccccccccccccccccccccccccccccccccccc"]},
#   :registrations=>
#    {1=>[1, 2, "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb", 1698847541],
#     2=>[1, 3, "0xcccccccccccccccccccccccccccccccccccccccc", 1698848314]},
#   :productTrack=>{1=>[1, 2]}}
```

that's it.




## Questions? Comments?

Join us in the [Rubidity (community) discord (chat server)](https://discord.gg/3JRnDUap6y). Yes you can.
Your questions and commentary welcome.

Or post them over at the [Help & Support](https://github.com/geraldb/help) page. Thanks.

