class EtherERC20Bridge < ERC20
 
  event :InitiateWithdrawal, from: Address, amount: UInt
  event :WithdrawalComplete, to: Address, amount: UInt

  storage trustedSmartContract: Address, 
         pendingWithdrawals:     mapping( Address, UInt ) 
  
  sig [String, String, Address]
  def constructor(
    name:,
    symbol:,
    trustedSmartContract:) 
    super(name: name, symbol: symbol, decimals: 18)
    
    @trustedSmartContract = trustedSmartContract
  end
  
  sig [Address, UInt]
  def bridgeIn( to:, amount: )
    assert(
      address(msg.sender) == @trustedSmartContract,
      "Only the trusted smart contract can bridge in tokens"
    )
    
    _mint(to: to, amount: amount)
  end
  
  sig  [UInt]
  def bridgeOut( amount: )
    _burn(from: msg.sender, amount: amount)
    
    @pendingWithdrawals[address(msg.sender)] += amount
    
    log InitiateWithdrawal, from: address(msg.sender), amount: amount
  end
  
  sig  [Address, UInt] 
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
    
    log WithdrawalComplete, to: to, amount: amount
  end
end
