# minitest setup
require 'minitest/autorun'


## our own code
$LOAD_PATH.unshift( '../../solidity-typed/lib' )
$LOAD_PATH.unshift( '../../rubidity/lib' )
require 'solidity/typed'
require 'rubidity'


## pull-in standard contracts from rubidity contracts
$LOAD_PATH.unshift( '../../rubidity_contracts/lib' )
require 'rubidity/contracts/erc20'
require 'rubidity/contracts/public_mint_erc20'


require_relative '../UniswapV2Pair'


pp ERC20
pp PublicMintERC20
pp UniswapV2Pair

