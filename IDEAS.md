# Ideas (Big, Small, Blue Sky, ...)




## events as types / constants

``` ruby
  event :Transfer, from:    :address, 
                   to:      :address, 
                   amount:  :uint
  event :Approval, owner:   :address, 
                   spender: :address, 
                   amount:  :uint 

```

change or offer an alternate syntax e.g:

defines an event type in the future (for now may only assign a hash) to constant - why? why not?

``` ruby
 Transfer = event from:    Address, 
                  to:      Address, 
                  amount:  Uint  
 Approval = event  owner:   Address, 
                   spender: Address, 
                   amount:  Uint

## same as ..
  event :Transfer, from:    Address, 
                   to:      Address, 
                   amount:  Uint  
  event :Approval, owner:   Address, 
                   spender: Address, 
                   amount:  Uint



## and than to log ...
  log Transfer, from:, to:, ammount: 
  log Approval, owner:, spender:, amount: 


## and maybe later add structs using same style

Proposal = struct voter: Address,
                  text:  String

struct :Proposal, voter: Address,
                  text:  String
```



### allow / use  @ instead of s. - why? why not ? e.g.

``` ruby
constructor(name: :string, symbol: :string, decimals: :uint256) {
    s.name = name
    s.symbol = symbol
    s.decimals = decimals
  }
```
to

``` ruby
sig :constructor, [:string, :string, :uint256]
def constructor(name:, symbol:, decimals:)
    @name = name
    @symbol = symbol
    @decimals = decimals
end
```

auto-add ivars with zero values  - why? why not?


### allow / use   self. instead of s.  - why? why not?  e.g.

``` ruby
constructor(name: :string, symbol: :string, decimals: :uint256) {
    s.name = name
    s.symbol = symbol
    s.decimals = decimals
  }
```
to

```
constructor(name: :string, symbol: :string, decimals: :uint256) {
    self.name = name
    self.symbol = symbol
    self.decimals = decimals
  }
```

public accessor might / will conflict with public generated accessors?
different for public mapping or array access
e.g.  balanceOf( 0 )  vs balanceOf[ 0 ] !!!!

### new style for state vars?

``` ruby
pub :name, :type
pub :name, :string 
string :name
unit  :decimals
```

### change emit (event)  to log (event)


### change  mapping types hash to array  

change

``` ruby
mapping ({ addressOrDumbContract: :uint256 }), :balanceOf
mapping ({ addressOrDumbContract: mapping(addressOrDumbContract: :uint256) }), :allowance
```

to

``` ruby
mapping [:addressOrDumbContract, :uint256],  :balanceOf 
mapping [:addressOrDumbContract, mapping[:addressOrDumbContract, :uint256]], :allowance
```

why? why not?   or allow / support both for now?

