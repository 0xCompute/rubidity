pragma :rubidity, "1.0.0"

import 'ERC20'

contract :EthscriptionERC20Bridge, is: :ERC20 do
  event :InitiateWithdrawal, { from: :address, escrowedIds: [:bytes32], withdrawalId: :bytes32 }
  event :WithdrawalComplete, { to: :address, escrowedIds: [:bytes32], withdrawalId: :bytes32 }
  event :BridgedIn, { to: :address, escrowedIds: [:bytes32] }

  string :public, :ethscriptionsTicker
  uint256 :public, :ethscriptionMintAmount
  uint256 :public, :ethscriptionMaxSupply
  bytes32 :public, :ethscriptionDeployId
  
  address :public, :trustedSmartContract

  uint8 :internal, :NOT_BRIDGED_IN
  uint8 :internal, :BRIDGED_IN
  uint8 :internal, :PENDING_WITHDRAWAL
  mapping ({ bytes32: :uint8 }), :public, :ethscriptionStatus
  
  mapping ({ address: array(:bytes32) }), :public, :pendingUserWithdrawalIds
  mapping ({ bytes32: array(:bytes32) }), :public, :withdrawalIdToEscrowedIds
  mapping ({ bytes32: :address }), :public, :bridgedEthscriptionToOwner
  
  constructor(
    name: :string,
    symbol: :string,
    trustedSmartContract: :address,
    ethscriptionDeployId: :bytes32
  ) {
    ERC20.constructor(name: name, symbol: symbol, decimals: 18)
    
    s.trustedSmartContract = trustedSmartContract
    s.ethscriptionDeployId = ethscriptionDeployId
    
    deploy = esc.findEthscriptionById(ethscriptionDeployId)
    uri = deploy.contentUri
    parsed = ::JSON.parse(uri.split("data:,").last)
    
    require(parsed['op'] == 'deploy', "Invalid ethscription deploy id")
    require(parsed['p'] == 'erc-20', "Invalid protocol")
    
    s.ethscriptionsTicker = parsed['tick']
    s.ethscriptionMintAmount = parsed['lim']
    s.ethscriptionMaxSupply = parsed['max']
    s.NOT_BRIDGED_IN = 0
    s.BRIDGED_IN = 1
    s.PENDING_WITHDRAWAL = 2
  }
  
  function :bridgeIn, { to: :address, escrowedIds: [:bytes32] }, :public do
    require(
      msg.sender == s.trustedSmartContract,
      "Only the trusted smart contract can bridge in tokens"
    )
    
    for i in 0...escrowedIds.length
      escrowedId = escrowedIds[i]

      require(s.ethscriptionStatus[escrowedId] == s.NOT_BRIDGED_IN, 'Already bridged in')
            
      ethscription = esc.findEthscriptionById(escrowedId)
      uri = ethscription.contentUri
      
      match_data = uri.match(/data:,{"p":"erc-20","op":"mint","tick":"([a-z]+)","id":"([1-9]+\d*)","amt":"([1-9]+\d*)"}/)
      
      require(match_data.present?, "Invalid ethscription content uri")
      
      tick, id, amt = match_data.captures
      
      tick = tick.cast(:string)
      id = id.cast(:uint256)
      amt = amt.cast(:uint256)
      
      require(tick == s.ethscriptionsTicker, "Invalid ethscription ticker")
      require(amt == s.ethscriptionMintAmount, "Invalid ethscription mint amount")

      maxId = s.ethscriptionMaxSupply.div(s.ethscriptionMintAmount)
      
      require(id > 0 && id <= maxId, "Invalid token id")
      
      require(
        ethscription.currentOwner == s.trustedSmartContract,
        "Ethscription not owned by recipient. Observed owner: #{ethscription.currentOwner}, expected owner: #{s.trustedSmartContract}"
      )
      
      require(
        ethscription.previousOwner == to,
        "Ethscription not previously owned by to. Observed previous owner: #{ethscription.previousOwner}, expected previous owner: #{to}"
      )
      
      s.bridgedEthscriptionToOwner[escrowedId] = to
      s.ethscriptionStatus[escrowedId] = s.BRIDGED_IN
    end
    
    _mint(to: to, amount: s.ethscriptionMintAmount * escrowedIds.length * (10 ** decimals))
    emit :BridgedIn, to: to, escrowedIds: escrowedIds
  end
  
  function :bridgeOut, { escrowedIds: [:bytes32] }, :public do
    withdrawalId = esc.currentTransactionHash
    
    require(
      s.withdrawalIdToEscrowedIds[withdrawalId].length == 0,
      "Withdrawal already started"
    )

    s.withdrawalIdToEscrowedIds[withdrawalId] = escrowedIds
    s.pendingUserWithdrawalIds[msg.sender].push(withdrawalId)

    for i in 0...escrowedIds.length
      escrowedId = escrowedIds[i]
      
      require(s.ethscriptionStatus[escrowedId] == s.BRIDGED_IN, "Not bridged in")
      
      require(
        s.bridgedEthscriptionToOwner[escrowedId] == msg.sender,
        "Ethscription not owned by sender"
      )
      
      s.ethscriptionStatus[escrowedId] = s.PENDING_WITHDRAWAL
    end
      
    _burn(from: msg.sender, amount: s.ethscriptionMintAmount * escrowedIds.length * (10 ** decimals))
    emit :InitiateWithdrawal, from: msg.sender, escrowedIds: escrowedIds, withdrawalId: withdrawalId
  end
  
  function :markWithdrawalComplete, {
    to: :address,
    withdrawalIds: [:bytes32]
  }, :public do
    require(
      msg.sender == s.trustedSmartContract,
      'Only the trusted smart contract can mark withdrawals as complete'
    )

    for wi in 0...withdrawalIds.length
      withdrawalId = withdrawalIds[wi]
      escrowedIds = s.withdrawalIdToEscrowedIds[withdrawalId]

      for ei in 0...escrowedIds.length
        escrowedId = escrowedIds[ei]

        require(s.ethscriptionStatus[escrowedId] == s.PENDING_WITHDRAWAL, "Not pending withdrawal")
        
        require(
          s.bridgedEthscriptionToOwner[escrowedId] == to,
          "Recipient is not the owner"
        )

        s.bridgedEthscriptionToOwner[escrowedId] = address(0)
        s.ethscriptionStatus[escrowedId] = s.NOT_BRIDGED_IN
      end

      require(
        _removeFirstOccurenceOfValueFromArray(
          s.pendingUserWithdrawalIds[to],
          withdrawalId
        ),
        "Withdrawal id not found"
      )
      
      s.withdrawalIdToEscrowedIds[withdrawalId] = []
        
      emit :WithdrawalComplete, to: to, escrowedIds: escrowedIds, withdrawalId: withdrawalId
    end
    
    return nil
  end
  
  function :getPendingWithdrawalsForUser, { user: :address }, :public, :view, returns: [:bytes32] do
    return s.pendingUserWithdrawalIds[user]
  end
  
  function :getWithdrawalIdToEscrowedIds, { withdrawalId: :bytes32 }, :public, :view, returns: [:bytes32] do
    return s.withdrawalIdToEscrowedIds[withdrawalId]
  end
  
  function :_removeFirstOccurenceOfValueFromArray, { arr: array(:bytes32), value: :bytes32 }, :internal, returns: :bool do
    for i in 0...arr.length
      if arr[i] == value
        return _removeItemAtIndex(arr: arr, indexToRemove: i)
      end
    end
    
    return false
  end
  
  function :_removeItemAtIndex, { arr: array(:bytes32), indexToRemove: :uint256 }, :internal, returns: :bool do
    lastIndex = arr.length - 1
    
    if lastIndex != indexToRemove
      lastItem = arr[lastIndex]
      arr[indexToRemove] = lastItem
    end
    
    arr.pop
    
    return true
  end
end
