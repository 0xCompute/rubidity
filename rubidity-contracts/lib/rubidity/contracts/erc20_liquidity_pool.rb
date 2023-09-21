class ERC20LiquidityPool < ContractImplementation

  storage token0: :dumbContract,
          token1: :dumbContract

  sig :constructor, [:dumbContract, :dumbContract]           
  def constructor( token0:, 
                   token1: ) 
    @token0 = token0
    @token1 = token1
  end
  
  sig :addLiquidity, [:uint256, :uint256]
  def addLiquidity( token0Amount:, 
                    token1Amount: )
    DumbContract(@token0).transferFrom(
      from: msg.sender,
      to: dumbContractId( this ),   ## note: add support for this (alias for self ??)
      amount: token0Amount
    )
    
    DumbContract(@token1).transferFrom(
      from: msg.sender,
      to: dumbContractId(this),
      amount: token1Amount
    )
  end
  

  sig :reserves, [], :view, returns: :string
  def reserves
    jsonData = {
      token0: DumbContract(@token0).balanceOf(dumbContractId(this)),
      token1: DumbContract(@token1).balanceOf(dumbContractId(this))
    }.to_json
    
    "data:application/json,#{jsonData}"
  end
 
  sig :calculateOutputAmount, [:dumbContract, :dumbContract, :uint256], :view, returns: :uint256
  def calculateOutputAmount( inputToken:,
                             outputToken:,
                             inputAmount: )
    inputReserve  = DumbContract(inputToken).balanceOf(dumbContractId(this))
    outputReserve = DumbContract(outputToken).balanceOf(dumbContractId(this))
    
    ((inputAmount * outputReserve) / (inputReserve + inputAmount)).to_i
  end


  sig :swap, [:dumbContract, :dumbContract, :uint256], returns: :uint256
  def swap(
    inputToken:,
    outputToken:,
    inputAmount: )
    assert [@token0, @token1].include?(inputToken), "Invalid input token"
    assert [@token0, @token1].include?(outputToken), "Invalid output token"
    
    assert inputToken != outputToken, "Input and output tokens can't be the same"
    
    outputAmount = calculateOutputAmount(
      inputToken: inputToken,
      outputToken: outputToken,
      inputAmount: inputAmount
    )
    
    outputReserve = DumbContract(outputToken).balanceOf(dumbContractId(this))
    
    assert outputAmount <= outputReserve, "Insufficient output reserve"
  
    DumbContract(inputToken).transferFrom(
      from: msg.sender,
      to: dumbContractId(this),
      amount: inputAmount
    )
  
    DumbContract(outputToken).transfer(
      msg.sender,
      outputAmount
    )
  
    outputAmount
  end
end
