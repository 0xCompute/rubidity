##
#  to run use:
#     ruby test/test_UniswapV2Pair.rb


require_relative 'helper'


class TestUniswapV2Pair < Minitest::Test

  ALICE  = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
  pp ALICE

  
  def _setup_contracts
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

    [token0, token1, pair]
  end


  def test_MintBootstrap
      token0, token1, pair =  _setup_contracts

      # from alice to (uniswap)pair
      token0.transfer( address(pair), 1.ether ) 
      token1.transfer( address(pair), 1.ether )

      pair.mint

      # assertEq(pair.balanceOf(address(this)), 1 ether - 1000);
      pp pair.balanceOf( ALICE )   #=> 999999999999999000
      assert  pair.balanceOf( ALICE ) == 1.ether - 1000

      # assertReserves(1 ether, 1 ether);
      pp reserves = pair.getReserves
      assert reserves[0] == 1.ether
      assert reserves[1] == 1.ether

      # assertEq(pair.totalSupply(), 1 ether);
      pp pair.totalSupply
      assert pair.totalSupply == 1.ether
  end

  def test_MintUnbalanced
    token0, token1, pair =  _setup_contracts

    # from alice to (uniswap)pair
    token0.transfer( address(pair), 1.ether )
    token1.transfer( address(pair), 1.ether )

    pair.mint  #  + 1 LP
    
    assert pair.balanceOf( ALICE ) == 1.ether - 1000
    
    # assertReserves(1 ether, 1 ether)
    pp reserves = pair.getReserves
    assert reserves[0] == 1.ether
    assert reserves[1] == 1.ether

    # from alice to (uniswap)pair
    token0.transfer( address(pair), 2.ether )
    token1.transfer( address(pair), 1.ether )

    pair.mint   # + 1 LP

    pp pair.balanceOf( ALICE )   #=> 1999999999999999000
    assert pair.balanceOf( ALICE ) == 2.ether - 1000
  
    # assertReserves(3 ether, 2 ether)
    pp reserves = pair.getReserves
    assert reserves[0] == 3.ether
    assert reserves[1] == 2.ether
  end
end  # class TestUniswapV2Pair

