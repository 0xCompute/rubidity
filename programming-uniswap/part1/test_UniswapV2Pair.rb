$LOAD_PATH.unshift( '../../solidity-typed/lib' )
$LOAD_PATH.unshift( '../../rubidity/lib' )
require 'solidity/typed'
require 'rubidity'


require_relative 'ERC20'
require_relative 'PublicMintERC20'
require_relative 'UniswapV2Pair'


pp ERC20
pp PublicMintERC20
pp UniswapV2Pair

alice   = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
pp alice


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


Runtime.msg.sender = alice

# 10.ether = 10.e18 (10 * 10**18) = 10_000_000_000_000_000_000
token0.mint(10.ether)   
token1.mint(10.ether) 

## 
## function testMintBootstrap

# from alice to (uniswap)pair
token0.transfer( address(pair), 1.ether ) 
token1.transfer( address(pair), 1.ether )

pp token0
pp token1


pair.mint
pp pair

# assertEq(pair.balanceOf(address(this)), 1 ether - 1000);
pp pair.balanceOf( alice )   #=> 999999999999999000
pp pair.balanceOf( alice ) == 1.ether - 1000

# assertReserves(1 ether, 1 ether);
pp reserves = pair.getReserves
pp reserves[0] == 1.ether
pp reserves[1] == 1.ether

# assertEq(pair.totalSupply(), 1 ether);
pp pair.totalSupply
pp pair.totalSupply == 1.ether



puts "bye"