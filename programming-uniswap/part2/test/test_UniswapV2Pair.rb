##
#  to run use  (in /part2):
#     ruby test/test_UniswapV2Pair.rb


require_relative 'helper'


class TestUniswapV2Pair < Minitest::Test

  ALICE  = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
  BOB    = '0x'+'b'*40 

  pp ALICE
  pp BOB


  def _setup_contracts
     Runtime.block.timestamp = 0   ## start with timestamp 0 - why? why not?

    ## 21.e24 = 21 *10**24  = 21_000_000_000_000_000_000_000_000
    token0 = PublicMintERC20.construct(
      name: "Token A",
      symbol: "TKNA",
      maxSupply: 21.e24,  
      perMintLimit: 21.e24,
      decimals: 18 )
    pp token0


    token1 = PublicMintERC20.construct(
      name: "Token B",
      symbol: "TKNB",
      maxSupply: 21.e24,
      perMintLimit: 21.e24,
      decimals: 18 )
    pp token1


    pair = UniswapV2Pair.construct( token0: address(token0),
                                    token1: address(token1) ) 


    Runtime.msg.sender = ALICE

    # 10.ether = 10.e18 (10 * 10**18) = 10_000_000_000_000_000_000
    token0.mint(10.ether)   
    token1.mint(10.ether) 

    ## switch msg sender to bob
    Runtime.msg.sender = BOB

    token0.mint(10.ether)
    token1.mint(10.ether)

    ## back to alice
    Runtime.msg.sender = ALICE

    [token0, token1, pair]
  end

  def test_MintBootstrap
      token0, token1, pair =  _setup_contracts
  end
end  # class TestUniswapV2Pair

