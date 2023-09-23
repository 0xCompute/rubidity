## move to rubidity-contracts (or is uniswap only?)



class UnsafeNoApprovalERC20 <  ERC20
  
  sig :constructor, [:string, :string]
  def constructor( name:, symbol: ) 
    ERC20( name: name, symbol: symbol, decimals: 18 )
  end

  sig :mint, [:uint256]
  def mint( amount: )
    assert  amount > 0, 'Amount must be positive'
    
    _mint( to: msg.sender, amount: amount )
  end

  sig :airdrop, [:address, :uint256]
  def airdrop( to:,  amount: )
    assert amount > 0, 'Amount must be positive'
    
    _mint(to: to, amount: amount)
  end

  sig :transferFrom, [:address, :address, :uint256], :override, returns: :bool
  def transferFrom( from:,
                    to:,
                    amount: )
    assert @balanceOf[from] >= amount, 'Insufficient balance'
    
    @balanceOf[from] -= amount
    @balanceOf[to] += amount
    
    log :Transfer, from: from, to: to, amount: amount
    
    true
  end
end
