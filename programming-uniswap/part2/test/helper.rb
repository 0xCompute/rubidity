# minitest setup
require 'minitest/autorun'


## our own code
$LOAD_PATH.unshift( '../../solidity-typed/lib' )
$LOAD_PATH.unshift( '../../rubidity/lib' )
require 'solidity/typed'
require 'rubidity'


require_relative '../ERC20'
require_relative '../PublicMintERC20'
require_relative '../UniswapV2Pair'


pp ERC20
pp PublicMintERC20
pp UniswapV2Pair

