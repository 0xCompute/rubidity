pragma :rubidity, "1.0.0"

import 'UniswapV2Pair'


contract :UniswapV2Factory do
  address :public, :feeTo
  address :public, :feeToSetter

  mapping ({ address: mapping({ address: :address })}), :public, :getPair
  array :address, :public, :allPairs

  event :PairCreated, { token0: :address, token1: :address, pair: :address, pairLength: :uint256 }

  constructor(_feeToSetter: :address) do
    s.feeToSetter = _feeToSetter
  end

  function :allPairsLength, {}, :public, :view, returns: :uint256 do
    return s.allPairs.length
  end
  
  function :getAllPairs, {}, :public, :view, returns: [:address] do
    return s.allPairs
  end

  function :createPair, { tokenA: :address, tokenB: :address }, :public, returns: :address do
    require(tokenA != tokenB, 'Scribeswap: IDENTICAL_ADDRESSES')
    
    token0, token1 = uint256( tokenA ) < uint256( tokenB ) ? [tokenA, tokenB] : [tokenB, tokenA]
    
    require(token0 != address(0), "Scribeswap: ZERO_ADDRESS");
    require(s.getPair[token0][token1] == address(0), "Scribeswap: PAIR_EXISTS");

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

    pair = UniswapV2Pair.construct
    pair.init( token0, token1 )

    s.getPair[token0][token1] = pair.__address__
    s.getPair[token1][token0] = pair.__address__

    s.allPairs.push( pair.__address__ )
    emit :PairCreated, token0: token0, token1: token1, pair: pair.__address__, pairLength: s.allPairs.length

    return pair.__address__
  end

  

  function :setFeeTo, { _feeTo: :address }, :public do
    require(msg.sender == feeToSetter, "Scribeswap: FORBIDDEN")
    
    s.feeTo = _feeTo
    
    return nil
  end

  function :setFeeToSetter, { _feeToSetter: :address }, :public do
    require(msg.sender == feeToSetter, "Scribeswap: FORBIDDEN")
    
    s.feeToSetter = _feeToSetter
    
    return nil
  end
end
