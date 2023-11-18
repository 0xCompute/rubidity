# // SPDX-License-Identifier: Unlicense
# pragma solidity ^0.8.10;
#
# import "./ZuniswapV2Pair.sol";
# import "./interfaces/IZuniswapV2Pair.sol";
#
#   error IdenticalAddresses();
#   error PairExists();
#   error ZeroAddress();


class UniswapV2Factory < Contract

    event :PairCreated, 
              token0: Address,   # indexed 
              token1: Address,   # indexed 
              pair:   Address,
              length: UInt

    storage pairs:    mapping( Address, mapping( Address, Address)),
            allPairs: array( Address )


    sig [Address, Address], returns: Address    # pair
    def createPair( tokenA:, tokenB: )
        assert tokenA != tokenB, "Identical Addresses"

        token0, token1 = tokenA < tokenB ? [tokenA, tokenB]
                                         : [tokenB, tokenA]
                        
        assert token0 != address(0), "Zero Address"

        assert @pairs[token0][token1] == address(0), "Pair Exists"

        pair = UniswapV2Pair.construct
        pair.init( token0, token1 )

        @pairs[token0][token1] = address(pair)
        @pairs[token1][token0] = address(pair)
        @allPairs.push( address(pair) )

        log PairCreated, token0: token0,
                         token1: token1,
                         pair:   address( pair ),
                         length: @allPairs.length

        address( pair )
    end
end