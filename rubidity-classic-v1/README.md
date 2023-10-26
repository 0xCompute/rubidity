# Rubidity Classic


## What's Rubidity?!

See [**Rubidity - Ruby for Layer 1 (L1) Contracts / Protocols with "Off-Chain" Indexer**  »](https://github.com/s6ruby/rubidity)




## Classic vs "More Ruby-ish" - Why!?

Why? Why? Why?  

In the original rubidity "classic" version inheritance 
"models" solidity with the is class-macro "keyword" e.g.:

``` ruby
class PublicMintERC20 < Contract
  is :ERC20 
  # ...
end
```

Why not (re)use the ruby machinery and inheritance model 
and get everything for free - the idea (design philosophy) of the (alternate) rubidity (syntax) is - 
it is just ruby (yes, with 100%-compatibility for solidity for api / abi and storage  / state). the updated version reads:

``` ruby
class PublicMintERC20 < ERC20 
  # ...
end
```


while aligning rubidity more with ruby itself - let's rename `require()`  - 
which has a special meaning in ruby (it's the import machinery for package / module / gem / library reuse) to `assert()` so you can (continue to) use ruby's 
require in rubidity.

one more biggie. in rubidity classic a typed method / function 
looks like:

``` ruby
function :airdrop, { to: :addressOrDumbContract, amount: :uint256 }, :public do
  # ...
end
```

to align rubidity more with ruby itself - lets use "plain" methods 
and add an (optional) type sig(nature) annotation resulting in:

``` ruby
sig [Address, Uint], 
def airdrop( to:, amount: ) 
  # ...
end
```

while this may look like hair-splitting about syntax. 
the new way is ruby all the way down (using an "alias method chain" for the typed and untyped methods). no need to (re)generate methods from super classes and such and because it's ruby the rdoc (documentation) works too. 
see here how classic looks like (hint: you see nothing) -> <https://www.rubydoc.info/gems/rubidity-contracts/0.2.0/PublicMintERC20> 
and compare to the update (v.0.2.1) -> <https://www.rubydoc.info/gems/rubidity-contracts/0.2.1/PublicMintERC20> 




## What's different?


Before (Classic)

```ruby
class ERC20 < Contract
  pragma :rubidity, "1.0.0"
  
  abstract
  
  event :Transfer, { from: :address, to: :address, amount: :uint256 }
  event :Approval, { owner: :address, spender: :address, amount: :uint256 }

  string :public, :name
  string :public, :symbol
  uint8 :public, :decimals
  
  uint256 :public, :totalSupply

  mapping ({ address: :uint256 }), :public, :balanceOf
  mapping ({ address: mapping(address: :uint256) }), :public, :allowance
  
  constructor(name: :string, symbol: :string, decimals: :uint8) {
    s.name = name
    s.symbol = symbol
    s.decimals = decimals
  }

  function :approve, { spender: :address, amount: :uint256 }, :public, :virtual, returns: :bool do
    s.allowance[msg.sender][spender] = amount
    
    emit :Approval, owner: msg.sender, spender: spender, amount: amount
    
    return true
  end
  
  function :decreaseAllowanceUntilZero, { spender: :address, difference: :uint256 }, :public, :virtual, returns: :bool do
    allowed = s.allowance[msg.sender][spender]
    
    newAllowed = allowed > difference ? allowed - difference : 0
    
    approve(spender: spender, amount: newAllowed)
    
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

class PublicMintERC20 < Contract
  is :ERC20
  
  uint256 :public, :maxSupply
  uint256 :public, :perMintLimit
  
  constructor(
    name: :string,
    symbol: :string,
    maxSupply: :uint256,
    perMintLimit: :uint256,
    decimals: :uint8
  ) {
    ERC20.constructor(name: name, symbol: symbol, decimals: decimals)
    s.maxSupply = maxSupply
    s.perMintLimit = perMintLimit
  }
  
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


After (More Ruby-ish)

```ruby
class ERC20 < Contract
  
  event :Transfer, { from: Address, 
                     to:  Address, 
                     amount: Uint }
  event :Approval, { owner: Address, 
                     spender: Address, 
                     amount: Uint }

  storage  name:   String,
           symbol: String,
           decimals: Uint,
           totalSupply: Uint,
           balanceOf:  Mapping.of( Address, Uint ),
           allowance:  Mapping.of( Address, Mapping.of( Address, Uint )) 
  
  sig [String, String, Uint],
  def constructor(name:, 
                  symbol:,
                  decimals: ) 
    @name = name
    @symbol = symbol
    @decimals = decimals
  end

  sig [Address, Uint], returns: Bool,
  def approve( spender:, 
               amount: )
    @allowance[msg.sender][spender] = amount
    
    log :Approval, owner: msg.sender, spender: spender, amount: amount
    
    true
  end
  
  sig [Address, Uint], returns: Bool, 
  def decreaseAllowanceUntilZero( spender:,
                                  difference: )
    allowed = @allowance[msg.sender][spender]
    
    newAllowed = allowed > difference ? allowed - difference : 0
    
    approve( spender: spender, amount: newAllowed )
    
    true
  end
  
  sig [Address, Uint], returns: Bool,
  def transfer( to:, 
                amount: ) 
    assert @balanceOf[msg.sender] >= amount, 'Insufficient balance'
    
    @balanceOf[msg.sender] -= amount
    @balanceOf[to] += amount

    log :Transfer, from: msg.sender, to: to, amount: amount
    
    true
  end
  
  sig  [Address, Address, Uint], returns: Bool, 
  def transferFrom( from:,
                    to:,
                    amount: )
    allowed = @allowance[from][msg.sender]
    
    assert @balanceOf[from] >= amount, 'Insufficient balance'
    assert allowed >= amount, 'Insufficient allowance'
    
    @allowance[from][msg.sender] = allowed - amount
    
    @balanceOf[from] -= amount
    @balanceOf[to] += amount
    
    log :Transfer, from: from, to: to, amount: amount
    
    true
  end
  
  sig  [Address, Uint],
  def _mint( to:, 
             amount:  )
    @totalSupply += amount
    @balanceOf[to] += amount
    
    log :Transfer, from: address(0), to: to, amount: amount
  end
  
  sig  [Address, Uint], 
  def _burn( from:,
             amount: )
    @balanceOf[from] -= amount
    @totalSupply -= amount
    
    log :Transfer, from: from, to: address(0), amount: amount
  end
end

class PublicMintERC20 < ERC20
  
  storage  maxSupply:    Uint,
           perMintLimit: Uint
  
  sig [String, String, Uint, Uint, Uint],
  def constructor(
    name:,
    symbol:,
    maxSupply:,
    perMintLimit:,
    decimals:
  ) 
    ERC20(name: name, symbol: symbol, decimals: decimals)
    @maxSupply = maxSupply
    @perMintLimit = perMintLimit
  end
 

  sig [Uint],
  def mint( amount: )
    assert amount > 0, 'Amount must be positive'
    assert amount <= @perMintLimit, 'Exceeded mint limit'
    
    assert @totalSupply + amount <= @maxSupply, 'Exceeded max supply'
    
    _mint( to: msg.sender, amount: amount )
  end
  
  sig [Address, Uint256],
  def airdrop( to:, amount: ) 
    assert amount > 0, 'Amount must be positive'
    assert amount <= @perMintLimit, 'Exceeded mint limit'
    
    assert @totalSupply + amount <= @maxSupply, 'Exceeded max supply'
    
    _mint( to: to, amount: amount )
  end
end
```


Better? More Ruby-ish? You decide.




### Inheritance via `is( *symbols )` changed to ruby "native".

```
```


Note: If you MUST model "multiple inheritance" you use ruby's "single inheritance" PLUS
module includes.



### Public is the Default for Storage / State Variables and Functions and Internal is the Default (if the Name Starts with Underscore (`_`))

the idea / proposal to make the contract code easier to read.   
let's make all functions public by default and all functions starting with underscore (`_`) internal by default and same for storage / state variables.  
in the standard contracts this convention is already used (but without the defaults). why not make it part of the rubidity language?  big benefit - less code and easier to read example: 

``` ruby
string  :public, :name
string  :public, :symbol
uint256 :public, :decimals
```

becomes

``` ruby
string  :name
string  :symbol
uint256 :decimals
```

and

``` ruby
function :_mint, { to: :addressOrDumbContract, amount: :uint256 }, :internal, :virtual
function :_mint, { to: :addressOrDumbContract, amount: :uint256 }, :virtual
```

or

``` ruby
function :transfer, { to: :addressOrDumbContract, amount: :uint256 }, :public, :virtual, returns: :bool
function :transfer, { to: :addressOrDumbContract, amount: :uint256 }, :virtual, returns: :bool
```

in functions the differance looks little 
but if you look at dozens of functions that will all add up . 



##  Design Comments / Discussion / Philosophy


### on `is` class-macro and multiple inheritance

middlemarch writes:

Q: Why not use default ruby inheritance? 

> Because Ruby doesn't have multiple inheritance like Solidity does so to port over the "is ERC20, Ownable" type thing you need a custom system anyway. Also Solidity has things like ERC20.transfer() which is nice to bring over. Finally, the way I'm doing functions with metaprogramming isn't compatible with Ruby's super anyway so you lose that.


comments:

good point. the reason for the change has two points: 1) multiple inheritance is a design flaw in solidity - let's simplify - it is not needed   2)  to reuse code / methods close to "multiple-inheritance" style without the "diamonds problem" you CAN use module includes  (that will "model" to solidity contract classes WITHOUT constructors).  i think that will cover 99.99% of all use (happy to be shown an example where this doesn't work). 



###  on `function` class-macro and (typed) method definition 

middlemarch writes:

Q: Why doing functions like this versus normal ruby methods? 

> I started out taking the approach you're using, but as the "sig" method got more complicated I felt like it would just be "less code" (which we both like!) for the "sig" to just define the method itself in addition to "annotating" it. Also my approach makes it easier to type check the method return value, but there's probably another way of doing that.

comments:

you can use the best of both worlds ;-) - in ruby you define the typeless / untyped / unsafe function / method  BUT thanks to ruby meta-programming magic/fu you can rename the method to  `<name>_unsafe` 
or such and than auto-add a new method (wrapper) with the orginal name handling the input (arguments) and output (returns) to type check (and auto-convert/cast) "automagically".   



### on keeping it rubish / closer to ruby

middlemarch writes:

> Overall I definitely started from the approach of "keep it closer to ruby," but I just kept running into places where I couldn't quite get what I wanted, so eventually I decided to just basically start from scratch. Plus I thought it would be funnier to take it this far.

comments:

the rewrite tries to support the "classic" original function-style 
in a rubidity classic version  (the only thing that cannot get supported / backported / monkey patched is the classic inheritance with the "is class-macro"  otherwise  - 
the idea is that you can pick "classic" style or the more rubish-style.


### misc / more commentary

middlemarch writes:

> a few thoughts:
>
> I will add uint = uint256 support. I left it off initially because I thought that nerds would like it if I forced people to spell the whole thing out, but in the end it's annoying and also fundamentally against the ethos which is "line-for-line translations should be possible."
>
> With the internal thing I think it's good to extend and not restrict ourselves to Solidity, but I think we should focus on being a super set that doesn't conflict with Solidity. And here Solidity's default behavior is internal, so changing it to be public in some cases could be too conflict-y.
>
> addressOrDumbContract is dead! Everything is now just address. I thought it would be cool to force this distinction, but now I feel like it was just my insecurity. Solidity "lives in its own world" and doesn't differentiate between addresses on L2s and Ethereum, and we are analogous in this case. I've changed several other things about these contracts like how constructors work ERC20.constructor etc. Take a look!


comments:

making public the default AND internal EXPLICIT with leading underscores i guess we must agree to disagree.   in ruby methods are public by default but the real biggie in my opinion is that shorter code is better. anyways,  no harm since in all your contract code you always add :public or :internal and that will continue to work in the (alternate) rubidity  (with the new option of using shortcuts to make the code shorter and easier to read).    and i am with you 100% the interface and storage / state MUST be 100% compatible with solidity. but again i am in favor of making (rubidity) code easier / simpler to read / write.  
