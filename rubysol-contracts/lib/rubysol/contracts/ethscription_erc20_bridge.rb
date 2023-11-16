class EthscriptionERC20Bridge < ERC20
  
  event :InitiateWithdrawal, from: Address, escrowedId: InscriptionId 
  event :WithdrawalComplete, to:   Address, escrowedId: InscriptionId 

  storage ethscriptionsTicker:     String, 
          ethscriptionMintAmount:  UInt, 
          ethscriptionMaxSupply:   UInt, 
          ethscriptionDeployId:    InscriptionId, 
          trustedSmartContract:    Address, 
          pendingWithdrawalEthscriptionToOwner: mapping( InscriptionId, Address ),
          bridgedEthscriptionToOwner:   mapping( InscriptionId, Address )
          
  sig  [String, String, Address, InscriptionId]           
  def constructor(
    name:,
    symbol:,
    trustedSmartContract:,
    ethscriptionDeployId:) 
    super(name: name, symbol: symbol, decimals: 18)
    
    @trustedSmartContract = trustedSmartContract
    @ethscriptionDeployId = ethscriptionDeployId
    
    deploy = esc.findEthscriptionById( ethscriptionDeployId )
    uri = deploy.contentUri
    parsed = JSON.parse(uri.split("data:,").last)
    
    assert(parsed['op'] == 'deploy', "Invalid ethscription deploy id")
    assert(parsed['p'] == 'erc-20', "Invalid protocol")
    
    @ethscriptionsTicker = parsed['tick']
    @ethscriptionMintAmount = parsed['lim']
    @ethscriptionMaxSupply = parsed['max']
  end

  
  sig  [Address, InscriptionId]
  def bridgeIn( to:, escrowedId: )
    assert(
      address(msg.sender) == @trustedSmartContract,
      "Only the trusted smart contract can bridge in tokens"
    )
    
    assert(
      @bridgedEthscriptionToOwner[escrowedId] == address(0),
      "Ethscription already bridged in"
    )
    
    assert(
      @pendingWithdrawalEthscriptionToOwner[escrowedId] == address(0),
      "Ethscription withdrawal initiated"
    )
    
    ethscription = esc.findEthscriptionById(escrowedId)
    uri = ethscription.contentUri
    
    match_data = uri.match(/data:,{"p":"erc-20","op":"mint","tick":"([a-z]+)","id":"([1-9]+\d*)","amt":"([1-9]+\d*)"}/)
    
    assert(match_data.present?, "Invalid ethscription content uri")
    
    tick, id, amt = match_data.captures
    
    tick = tick.cast(:string)
    id = id.cast(:uint256)
    amt = amt.cast(:uint256)
    
    assert(tick == @ethscriptionsTicker, "Invalid ethscription ticker")
    assert(amt == @ethscriptionMintAmount, "Invalid ethscription mint amount")

    maxId = @ethscriptionMaxSupply / @ethscriptionMintAmount
    
    assert(id > 0 && id <= maxId, "Invalid token id")
    
    assert(
      ethscription.currentOwner == @trustedSmartContract,
      "Ethscription not owned by recipient. Observed owner: #{ethscription.currentOwner}, expected owner: #{@trustedSmartContract}"
    )
    
    assert(
      ethscription.previousOwner == to,
      "Ethscription not previously owned by to. Observed previous owner: #{ethscription.previousOwner}, expected previous owner: #{to}"
    )
    
    @bridgedEthscriptionToOwner[escrowedId] = to
    _mint(to: to, amount: @ethscriptionMintAmount * (10 ** decimals))
  end
  

  sig  [InscriptionId]    
  def bridgeOut( escrowedId )
    assert( @bridgedEthscriptionToOwner[escrowedId] == address(msg.sender), "Ethscription not owned by sender")
    
    _burn(from: msg.sender, amount: @ethscriptionMintAmount * (10 ** decimals))
    
    @bridgedEthscriptionToOwner[escrowedId] = address(0)
    @pendingWithdrawalEthscriptionToOwner[escrowedId] = address(msg.sender)
    
    log InitiateWithdrawal, from: address(msg.sender), escrowedId: :ethscriptionId
  end
  

  sig [Address, InscriptionId] 
  def markWithdrawalComplete( to:, escrowedId: )
    assert(
      address(msg.sender) == @trustedSmartContract,
      'Only the trusted smart contract can mark withdrawals as complete'
    )
    
    assert(
      @pendingWithdrawalEthscriptionToOwner[escrowedId] == to,
      "Withdrawal not initiated"
    )
    
    @pendingWithdrawalEthscriptionToOwner[escrowedId] = address(0)
    
    log WithdrawalComplete, to: to, escrowedId: :ethscriptionId
  end
end
