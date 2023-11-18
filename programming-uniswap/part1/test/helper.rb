# minitest setup
require 'minitest/autorun'


## our own code
$LOAD_PATH.unshift( '../../solidity-typed/lib' )
$LOAD_PATH.unshift( '../../rubysol/lib' )
require 'solidity/typed'
require 'rubysol'


## pull-in standard contracts from rubysol contracts
$LOAD_PATH.unshift( '../../rubysol_contracts/lib' )
require 'rubysol/contracts/erc20'
require 'rubysol/contracts/public_mint_erc20'


require_relative '../UniswapV2Pair'


pp ERC20
pp PublicMintERC20
pp UniswapV2Pair

