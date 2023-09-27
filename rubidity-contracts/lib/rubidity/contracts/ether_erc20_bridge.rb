class EtherERC20Bridge < ERC20
 
  event :InitiateWithdrawal, { from: :address, amount: :uint256 }
  event :WithdrawalComplete, { to: :address, amount: :uint256 }

  storage trustedSmartContract: :address, 
         pendingWithdrawals:     mapping( :address, :uint256 ) 
  
  sig :constructor, [:string, :string, :address]
  def constructor(
    name:,
    symbol:,
    trustedSmartContract:) 
    ERC20(name: name, symbol: symbol, decimals: 18)
    
    @trustedSmartContract = trustedSmartContract
  end
  
  sig :bridgeIn, [:address, :uint256]
  def bridgeIn( to:, amount: )
    assert(
      address(msg.sender) == @trustedSmartContract,
      "Only the trusted smart contract can bridge in tokens"
    )
    
    _mint(to: to, amount: amount)
  end
  
  sig :bridgeOut, [:uint256]
  def bridgeOut( amount: )
    _burn(from: msg.sender, amount: amount)
    
    @pendingWithdrawals[address(msg.sender)] += amount
    
    log :InitiateWithdrawal, from: address(msg.sender), amount: amount
  end
  
  sig :markWithdrawalComplete, [:address, :uint256] 
  def markWithdrawalComplete( to:, amount: )
    assert(
      address(msg.sender) == @trustedSmartContract,
      'Only the trusted smart contract can mark withdrawals as complete'
    )
    
    assert(
      @pendingWithdrawals[to] >= amount,
      'Insufficient pending withdrawal'
    )
    
    @pendingWithdrawals[to] -= amount
    
    log :WithdrawalComplete, to: to, amount: amount
  end
end
