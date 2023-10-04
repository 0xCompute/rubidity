# Rubidity "Classic" V2

## What's Rubidity?!

See [**Rubidity - Ruby for Layer 1 (L1) Contracts / Protocols with "Off-Chain" Indexer**  »](https://github.com/s6ruby/rubidity)


## Ideas / Proposals 

Let's try this ERC20 contract:


``` ruby
pragma :rubidity, "1.0.0"

contract :ERC20V2 do
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


## Idea / Proposal No. 1 - Use Typed Classes for (Rubidity) Types (NOT Symbols)


Let's use typed classed for (rubidity types).  For example, `:address` becomes `Address`, `:uint256` becomes `UInt`, and so on.
See the [rubidity-typed gem / library](https://www.rubydoc.info/gems/rubidity-typed) for a 1:1 mapping of rubidity / solidity types to ruby typed classes.

Let's try to update the "classic" syntax v2:


``` ruby
pragma :rubidity, "1.0.0"

contract :ERC20V2 do
  abstract

  event :Transfer, { from: Address, to: Address, amount: UInt }
  event :Approval, { owner: Address, spender: Address, amount: UInt }

  storage name: String,
          symbol: String,
          decimals: UInt,     # uint8
          totalSupply: UInt,
          balanceOf: Mapping( Address, UInt ),
          allowance: Mapping( Address, Mapping( Address, UInt ))


  constructor(name: String, symbol: String, decimals: UInt) {
    s.name = name
    s.symbol = symbol
    s.decimals = decimals
  }

  function :approve, { spender: Address, amount: UInt }, :virtual, returns: Bool do
    s.allowance[msg.sender][spender] = amount

    emit :Approval, owner: msg.sender, spender: spender, amount: amount

    return true
  end

  function :transfer, { to: Address, amount: UInt },  :virtual, returns: Bool do
    require(s.balanceOf[msg.sender] >= amount, 'Insufficient balance')

    s.balanceOf[msg.sender] -= amount
    s.balanceOf[to] += amount

    emit :Transfer, from: msg.sender, to: to, amount: amount

    return true
  end

  function :transferFrom, {
    from: Address,
    to: Address,
    amount: UInt
  }, :virtual, returns: Bool do
    allowed = s.allowance[from][msg.sender]

    require(s.balanceOf[from] >= amount, 'Insufficient balance')
    require(allowed >= amount, 'Insufficient allowance')

    s.allowance[from][msg.sender] = allowed - amount

    s.balanceOf[from] -= amount
    s.balanceOf[to] += amount

    emit :Transfer, from: from, to: to, amount: amount

    return true
  end

  function :_mint, { to: Address, amount: UInt }, :virtual do
    s.totalSupply += amount
    s.balanceOf[to] += amount

    emit :Transfer, from: address(0), to: to, amount: amount
  end

  function :_burn, { from: Address, amount: UInt }, :virtual do
    s.balanceOf[from] -= amount
    s.totalSupply -= amount

    emit :Transfer, from: from, to: address(0), amount: amount
  end
end
```




