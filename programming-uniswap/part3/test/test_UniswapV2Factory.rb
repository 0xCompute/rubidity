##
#  to run use  (in /part3):
#     ruby test/test_UniswapV2Factory.rb


require_relative 'helper'


class TestUniswapV2Factory < Minitest::Test

  ALICE  = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
  BOB    = '0x'+'b'*40 

  pp ALICE
  pp BOB

  def _setup_contracts
    Runtime.block.timestamp = 0   ## start with timestamp 0 - why? why not?

    factory = UniswapV2Factory.construct

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

   token2 = PublicMintERC20.construct(
     name: "Token C",
     symbol: "TKNC",
     maxSupply: 21.e24,
     perMintLimit: 21.e24,
     decimals: 18 )
   pp token2

   token3 = PublicMintERC20.construct(
     name: "Token D",
     symbol: "TKND",
     maxSupply: 21.e24,
     perMintLimit: 21.e24,
     decimals: 18 )
   pp token3


   ## back to alice
   Runtime.msg.sender = ALICE

   [factory, token0, token1, token2, token3]
 end


  def test_CreatePair
      factory, token0, token1, token2, token3 =  _setup_contracts

      pair_address = factory.createPair(
                        address(token1),
                        address(token0)
                     )
      pp pair_address

      pair = UniswapV2Pair.at( pair_address )
      pp pair

      assert  pair.token0 == address( token0 )
      assert  pair.token1 == address( token1 )
  end

  def test_CreatePairZeroAddress
      factory, token0, token1, token2, token3 =  _setup_contracts
  
      # vm.expectRevert(encodeError("ZeroAddress()"));
      assert_raises RuntimeError do
        factory.createPair( address(0), address(token0))
      end

      # vm.expectRevert(encodeError("ZeroAddress()"));
      assert_raises RuntimeError do
        factory.createPair( address(token1), address(0))
      end
  end

  def test_CreatePairPairExists
    factory, token0, token1, token2, token3 =  _setup_contracts
    
    factory.createPair( address(token1), address(token0))
    
    # vm.expectRevert(encodeError("PairExists()"));
    assert_raises RuntimeError do
      factory.createPair( address(token1), address(token0))
    end
  end

  def test_CreatePairIdenticalTokens
     factory, token0, token1, token2, token3 =  _setup_contracts

      # vm.expectRevert(encodeError("IdenticalAddresses()"));
      assert_raises RuntimeError do 
        factory.createPair( address(token0), address(token0))
      end
  end
end  # class TestUniswapV2Factory

