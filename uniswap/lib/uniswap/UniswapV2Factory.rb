
class UniswapV2Factory < Contract

  event :PairCreated, token0:     Address, 
                      token1:     Address, 
                      pair:       Address, 
                      pairLength: UInt

  storage feeTo:       Address,
          feeToSetter: Address,
          getPair:     mapping( Address, mapping( Address, Address)),
          allPairs:    array( Address )

  sig [Address]
  def constructor( feeToSetter: ) 
    @feeToSetter = feeToSetter
  end

  sig [], :view, returns: UInt
  def allPairsLength
    @allPairs.length
  end

  sig [], :view, returns: array(Address)
  def getAllPairs
    @allPairs
  end

  sig [Address, Address], returns: Address
  def createPair( tokenA:, tokenB: )
    assert  tokenA != tokenB, 'Scribeswap: IDENTICAL_ADDRESSES'
    
    token0, token1 = uint( tokenA ) < uint( tokenB ) ? [tokenA, tokenB] : [tokenB, tokenA]
    
    assert token0 != address(0), "Scribeswap: ZERO_ADDRESS"
    assert @getPair[token0][token1] == address(0), "Scribeswap: PAIR_EXISTS"

=begin    
    salt = keccak256(abi.encodePacked(token0, token1))
    
    pair = new UniswapV2Pair({ salt: salt })
    pair.init(token0, token1)
    
    s.getPair[token0][token1] = pair
    s.getPair[token1][token0] = pair
    
    s.allPairs.push(pair)
    emit(:PairCreated, { token0: token0, token1: token1, pair: pair, pairLength: s.allPairs.length })
    
    return pair
=end

    ## fix-fix-fix - auto set call stack/msg.sender
    Runtime.msg.sender = __address__
    pair = UniswapV2Pair.construct
    pair.init( token0, token1 )

    @getPair[token0][token1] = pair.__address__
    @getPair[token1][token0] = pair.__address__

    @allPairs.push( pair.__address__ )
    log PairCreated, token0: token0, token1: token1, pair: pair.__address__, pairLength: @allPairs.length

    pair.__address__
  end
  
  sig [Address]
  def setFeeTo( feeTo: )
    assert msg.sender == @feeToSetter, "Scribeswap: FORBIDDEN"
    
    @feeTo = feeTo
  end

  sig [Address]
  def setFeeToSetter( feeToSetter: )
    assert msg.sender == @feeToSetter, "Scribeswap: FORBIDDEN"
    
    @feeToSetter = feeToSetter
  end
end   # class UniswapV2Factory
