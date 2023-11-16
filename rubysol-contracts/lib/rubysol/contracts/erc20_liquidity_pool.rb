class ERC20LiquidityPool < Contract

  storage token0: Address,
          token1: Address

  sig [Address, Address]           
  def constructor( token0:, 
                   token1: ) 
    @token0 = token0
    @token1 = token1
  end
  
  sig [UInt, UInt]
  def addLiquidity( token0Amount:, 
                    token1Amount: )
    ERC20(@token0).transferFrom(
      from: msg.sender,
      to: address( this ),   ## note: add support for this (alias for self ??)
      amount: token0Amount
    )
    
    ERC20(@token1).transferFrom(
      from: msg.sender,
      to: address(this),
      amount: token1Amount
    )
  end
  

  sig [], :view   ### fix- support multiple, returns: [UInt, UInt]
  def reserves
    {
      token0: ERC20(@token0).balanceOf(address(this)),
      token1: ERC20(@token1).balanceOf(address(this))
    }
  end

 

  sig [Address, Address, UInt], :view, returns: UInt
  def calculateOutputAmount( inputToken:,
                             outputToken:,
                             inputAmount: )
    inputReserve  = ERC20(inputToken).balanceOf(address(this))
    outputReserve = ERC20(outputToken).balanceOf(address(this))
    
    ((inputAmount * outputReserve) / (inputReserve + inputAmount)).to_i
  end


  sig [Address, Address, UInt], returns: UInt
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
    
    outputReserve = ERC20(outputToken).balanceOf( address(this))
    
    assert outputAmount <= outputReserve, "Insufficient output reserve"
  
    ERC20(inputToken).transferFrom(
      from: msg.sender,
      to: dumbContractId(this),
      amount: inputAmount
    )
  
    ERC20(outputToken).transfer(
      msg.sender,
      outputAmount
    )
  
    outputAmount
  end
end
