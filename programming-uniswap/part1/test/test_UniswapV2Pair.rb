##
#  to run use:
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

  def test_MintWhenTheresLiquidity
    token0, token1, pair =  _setup_contracts

    # from alice to (uniswap)pair
    token0.transfer( address(pair), 1.ether )
    token1.transfer( address(pair), 1.ether )

    pair.mint  # + 1 LP


    # vm.warp(37);
# function warp(uint256) external;
# - Sets block.timestamp.
#   Examples
#
#    vm.warp(1641070800);
#     emit log_uint(block.timestamp);   // 1641070800
   Runtime.block.timestamp = 37  

    token0.transfer( address(pair), 2.ether )
    token1.transfer( address(pair), 2.ether )

    pair.mint    #  + 2 LP
    pp pair

    assert pair.balanceOf(address( ALICE )) == 3.ether - 1000
    assert pair.totalSupply == 3.ether
   
    # assertReserves(3 ether, 3 ether);
    pp reserves = pair.getReserves
    assert reserves[0] == 3.ether
    assert reserves[1] == 3.ether
end

def test_MintLiquidityUnderflow
  token0, token1, pair =  _setup_contracts

  #  0x11: If an arithmetic operation results in underflow or overflow
  #    outside of an unchecked { ... } block.
  # vm.expectRevert(
  #    hex"4e487b710000000000000000000000000000000000000000000000000000000000000011"
  assert_raises RuntimeError do 
    pair.mint
  end
end

def test_MintZeroLiquidity
  token0, token1, pair =  _setup_contracts

  token0.transfer( address(pair), 1000 )
  token1.transfer( address(pair), 1000 )

  # vm.expectRevert(bytes(hex"d226f9d4")); // InsufficientLiquidityMinted()
  assert_raises RuntimeError do 
    pair.mint
  end
end


def test_Burn
  token0, token1, pair =  _setup_contracts

  token0.transfer( address(pair), 1.ether )
  token1.transfer( address(pair), 1.ether )

  pair.mint
  pair.burn

  assert pair.balanceOf(address( ALICE )) == 0

  # assertReserves(1000, 1000);
  pp reserves = pair.getReserves
  assert reserves[0] == 1000
  assert reserves[1] == 1000

  assert pair.totalSupply == 1000
  assert token0.balanceOf(address( ALICE )), 10.ether - 1000
  assert token1.balanceOf(address( ALICE )), 10.ether - 1000
end


def test_BurnUnbalanced
  token0, token1, pair =  _setup_contracts

  token0.transfer( address(pair), 1.ether )
  token1.transfer( address(pair), 1.ether )

  pair.mint

  token0.transfer( address(pair), 2.ether )
  token1.transfer( address(pair), 1.ether )

  pair.mint   # + 1 LP

  pair.burn

  assert pair.balanceOf(address(ALICE)) == 0
  # assertReserves(1500, 1000)
  pp reserves = pair.getReserves
  assert reserves[0] == 1500
  assert reserves[1] == 1000

  assert pair.totalSupply == 1000
  assert token0.balanceOf( address( ALICE )) == 10.ether - 1500
  assert token1.balanceOf( address( ALICE )) == 10.ether - 1000
end



def test_BurnUnbalancedDifferentUsers
  token0, token1, pair =  _setup_contracts

  # testUser.provideLiquidity(
  #     address(pair),
  #     address(token0),
  #     address(token1),
  #     1 ether,
  #    1 ether
  # )

  Runtime.msg.sender = BOB
  token0.transfer( address(pair), 1.ether )
  token1.transfer( address(pair), 1.ether )
  pair.mint

  assert pair.balanceOf(address( ALICE )) == 0
  assert pair.balanceOf(address( BOB )) == 1.ether - 1000
  assert pair.totalSupply == 1.ether


  Runtime.msg.sender = ALICE
  token0.transfer( address(pair), 2.ether )
  token1.transfer( address(pair), 1.ether )
  pair.mint    # + 1 LP

  pair.burn

  # this user is penalized for providing unbalanced liquidity
  assert  pair.balanceOf(address( ALICE)) == 0

  # assertReserves(1.5 ether, 1 ether)
  pp reserves = pair.getReserves
  assert reserves[0] == 15.e17   ## 1.5 ether
  assert reserves[1] == 1.ether

  assert pair.totalSupply == 1.ether
  assert token0.balanceOf(address(ALICE)), 10.ether - 5.e17  # 0.5 ether 
  assert token1.balanceOf(address(ALICE)), 10.ether

  # testUser.withdrawLiquidity(address(pair))
  Runtime.msg.sender = BOB
  pair.burn

  #  testUser receives the amount collected from this user
  assert  pair.balanceOf(address( BOB)) == 0
  # assertReserves(1500, 1000)
  pp reserves = pair.getReserves
  assert reserves[0] == 1500
  assert reserves[1] == 1000

  assert pair.totalSupply == 1000
  assert token0.balanceOf(address(BOB)) == 10.ether + 5.e17 - 1500
  assert token1.balanceOf(address(BOB)) == 10.ether - 1000
end



def test_BurnZeroTotalSupply
  token0, token1, pair =  _setup_contracts

  # // 0x12; If you divide or modulo by zero.
  # vm.expectRevert(
  #     hex"4e487b710000000000000000000000000000000000000000000000000000000000000012"
  # );

  assert_raises ZeroDivisionError do 
    pair.burn
  end
end


def test_BurnZeroLiquidity
  token0, token1, pair =  _setup_contracts
 
  # Transfer and mint as a normal user.
  token0.transfer( address(pair), 1.ether )
  token1.transfer( address(pair), 1.ether )
  pair.mint

  # Burn as a user who hasn't provided liquidity.
  #   bytes memory prankData = abi.encodeWithSignature("burn()");
  #   vm.prank(address(0xdeadbeef));
  #   vm.expectRevert(bytes(hex"749383ad")); // InsufficientLiquidityBurned()
  Runtime.msg.sender = BOB

  assert_raises RuntimeError do 
    pair.burn
  end
end

end  # class TestUniswapV2Pair

