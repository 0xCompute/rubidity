
# import 'UniswapV2Callee'
# import 'UniswapV2ERC20'

## add for now too
# import 'UnsafeNoApprovalERC20'
# import 'PublicMintERC20'


# contract :IUniswapV2Factory, abstract: true do
#   function :feeTo, {}, :external, :view, returns: :address do
#   end
# end

class UniswapV2Pair < UniswapV2ERC20

  event :Mint, sender:  Address, 
               amount0: UInt, 
               amount1: UInt 
  event :Burn, sender:  Address, 
               amount0: UInt, 
               amount1: UInt, 
               to:      Address 
  event :Swap, sender:     Address, 
               amount0In:  UInt, 
               amount1In:  UInt, 
               amount0Out: UInt, 
               amount1Out: UInt, 
               to:         Address 
  event :Sync, reserve0:  UInt,  # :uint112, 
               reserve1:  UInt  # :uint112 
  event :PreSwapReserves, reserve0: UInt, # :uint112, 
                          reserve1: UInt  # :uint112 


  MINIMUM_LIQUIDITY =  10 ** 3     #=> 1000

  storage factory:   Address,
          token0:    Address, 
          token1:    Address,
          _reserve0: UInt,   # uint112 ??
          _reserve1: UInt,   # uint112 ??
          _blockTimestampLast:  Timestamp,  # uint32 - why?  
          price0CumulativeLast: UInt,
          price1CumulativeLast: UInt,
          kLast:                UInt,
          _unlocked:            UInt  ## use bool or is counter more than 0/1 e.g. 0/1/2?
 

  sig []
  def constructor
    super
    @factory   = msg.sender
    @_unlocked = uint( 1 )
  end
        
  # note: can't name method initialize because of ruby
  sig [Address, Address], :external
  def init( token0:, token1: )
    assert msg.sender == @factory, 'ScribeSwap: FORBIDDEN'

    @token0 = token0
    @token1 = token1    
  end
  
  sig [], :view, returns: [UInt, UInt, Timestamp]        
  def getReserves
    return [@_reserve0,
            @_reserve1,
            @_blockTimestampLast]
  end
  
  sig [Address, Address, UInt]
  def _safeTransfer( token:, to:, value:)
    result = ERC20.at( token ).transfer(to: to, amount: value)
    
    assert result, "ScribeSwap: TRANSFER_FAILED"
  end
  

  sig [UInt, UInt, UInt, UInt]
  def _update(
    balance0:,
    balance1:,
    reserve0:,
    reserve1: )
    assert balance0 <= (2 ** 112 - 1) && balance1 <= (2 ** 112 - 1), 'ScribeSwap: OVERFLOW'
    
    # blockTimestamp = uint32(block.timestamp % 2 ** 32)
    # overflow is desired  - why??
    timeElapsed = block.timestamp - @_blockTimestampLast   
    
    if timeElapsed > 0 && reserve0 != 0 && reserve1 != 0
      # * never overflows, and + overflow is desired
      #   up reserve1 from 112 to 224 bit (shift by 112bit)
      #   up reserve2 from 112 to 224 bit (shift by 112bit)
      @price0CumulativeLast +=  (reserve1*(2 ** 112)) / reserve0  * timeElapsed
      @price1CumulativeLast +=  (reserve0*(2 ** 112)) / reserve1  * timeElapsed
    end
    
    log PreSwapReserves, reserve0: @_reserve0, reserve1: @_reserve1
    
    @_reserve0 = balance0   ## was uint112()
    @_reserve1 = balance1
    
    @_blockTimestampLast = block.timestamp
    log Sync, reserve0: @_reserve0, reserve1: @_reserve1
  end
  
 
  sig [UInt, UInt], returns: Bool  ## was uint112, uint112
  def _mintFee( reserve0:, reserve1: )
    feeTo = UniswapV2Factory.at( @factory ).feeTo
    feeOn = feeTo != address(0)
    kLast = @kLast
    
    if feeOn
      if kLast != 0
        ## note: sqrt NOT built-in - double check
        rootK = Integer.sqrt( reserve0 * reserve1 )
        rootKLast = Integer.sqrt( kLast )
        if rootK > rootKLast
          numerator = @totalSupply * (rootK - rootKLast)
          denominator = rootK * 5 + rootKLast
          liquidity = numerator.div(denominator)
          _mint( feeTo, liquidity )   if liquidity > 0
        end
      end
    elsif kLast != 0
      @kLast = 0
    end
    feeOn
  end
  
  sig [Address], returns: UInt
  def mint( to: )
    assert @_unlocked == 1, 'ScribeSwap: LOCKED'
    
    reserve0, reserve1, _ = getReserves
    
    balance0 = ERC20.at( @token0 ).balanceOf( __address__ ) ## address(this)
    balance1 = ERC20.at( @token1 ).balanceOf( __address__ ) ## address(this)
 
    amount0 = balance0 - reserve0
    amount1 = balance1 - reserve1
    
    feeOn = _mintFee( reserve0, reserve1)
    totalSupply = @totalSupply

 
    if totalSupply == 0
      ## note: sqrt NOT built-in - double check
      ##  move "upstream" into contract base (for all) - why? why not?
      liquidity = uint( Integer.sqrt(amount0 * amount1)) - MINIMUM_LIQUIDITY
      _mint( address(0), MINIMUM_LIQUIDITY )
    else
      liquidity = [
        (amount0 * totalSupply).div(reserve0),
        (amount1 * totalSupply).div(reserve1)
      ].min
    end

    assert liquidity > 0, 'ScribeSwap: INSUFFICIENT_LIQUIDITY_MINTED'
    _mint( to, liquidity )
 
  
    _update( balance0, balance1, reserve0, reserve1 )
    @kLast = @_reserve0 * @_reserve1    if feeOn
    
    log Mint, sender: msg.sender, amount0: amount0, amount1: amount1
    
    liquidity
  end
end  # class UniswapV2Pair

__END__

  


  function :burn, { to: :address }, :external, :lock, returns: { amount0: :uint256, amount1: :uint256 } do
    require(s.unlocked == 1, 'ScribeSwap: LOCKED')

    _reserve0, _reserve1, _ = getReserves
    _token0 = s.token0
    _token1 = s.token1
    balance0 = ERC20.at(_token0).balanceOf( __address__ )  ## address(this)
    balance1 = ERC20.at(_token1).balanceOf( __address__ )
    liquidity = s.balanceOf[ __address__ ]
  
    feeOn = _mintFee(_reserve0, _reserve1)
    _totalSupply = s.totalSupply
    amount0 = (liquidity * balance0).div(_totalSupply)
    amount1 = (liquidity * balance1).div(_totalSupply)
    
    require(amount0 > 0 && amount1 > 0, 'ScribeSwap: INSUFFICIENT_LIQUIDITY_BURNED')
    _burn( __address__, liquidity)
    _safeTransfer(_token0, to, amount0)
    _safeTransfer(_token1, to, amount1)
    balance0 = ERC20.at(_token0).balanceOf( __address__ )
    balance1 = ERC20.at(_token1).balanceOf( __address__ )
  
    _update(balance0, balance1, _reserve0, _reserve1)
    s.kLast = s.reserve0 * s.reserve1   if feeOn
    
    emit :Burn, sender: msg.sender, amount0: amount0, amount1: amount1, to: to
    
    ## return { amount0: amount0, amount1: amount1 }
    return [amount0, amount1]
  end
  

  function :swap, { amount0Out: :uint256, amount1Out: :uint256, to: :address, data: :bytes }, :external do
    require(s.unlocked == 1, 'ScribeSwap: LOCKED')
    
    require(amount0Out > 0 || amount1Out > 0, 'ScribeSwap: INSUFFICIENT_OUTPUT_AMOUNT')
    _reserve0, _reserve1, _ = getReserves
    require(amount0Out < _reserve0 && amount1Out < _reserve1, 'ScribeSwap: INSUFFICIENT_LIQUIDITY')
  
    balance0 = 0
    balance1 = 0
    _token0 = s.token0
    _token1 = s.token1
    
    require(to != _token0 && to != _token1, 'ScribeSwap: INVALID_TO')
    
    _safeTransfer(_token0, to, amount0Out) if amount0Out > 0 # optimistically transfer tokens
    _safeTransfer(_token1, to, amount1Out) if amount1Out > 0 # optimistically transfer tokens
    
    UniswapV2Callee(to).uniswapV2Call(msg.sender, amount0Out, amount1Out, data) if data.length > 0
    
    balance0 = ERC20(_token0).balanceOf(address(this))
    balance1 = ERC20(_token1).balanceOf(address(this))

    amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0
    amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0

    require(amount0In > 0 || amount1In > 0, 'ScribeSwap: INSUFFICIENT_INPUT_AMOUNT')
  
    balance0Adjusted = balance0 * 1000 - amount0In * 3
    balance1Adjusted = balance1 * 1000 - amount1In * 3
    
    require(
      balance0Adjusted * balance1Adjusted >= uint256(_reserve0) * _reserve1 * (1000 ** 2),
      'ScribeSwap: K'
    )
  
    _update(balance0, balance1, _reserve0, _reserve1)
    emit :Swap, sender: msg.sender, amount0In: amount0In, amount1In: amount1In, amount0Out: amount0Out, amount1Out: amount1Out, to: to
  end
  
  function :skim, { to: :address }, :external do
    require(s.unlocked == 1, 'ScribeSwap: LOCKED')
    
    _token0 = s.token0
    _token1 = s.token1
    
    _safeTransfer(_token0, to, ERC20(_token0).balanceOf(address(this)) - s.reserve0)
    _safeTransfer(_token1, to, ERC20(_token1).balanceOf(address(this)) - s.reserve1)
  end
  
  function :sync, {}, :external do
    require(s.unlocked == 1, 'ScribeSwap: LOCKED')
    
    _update(
      ERC20(s.token0).balanceOf(address(this)),
      ERC20(s.token1).balanceOf(address(this)),
      s.reserve0,
      s.reserve1
    )
  end
end
