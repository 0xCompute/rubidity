# minitest setup
require 'minitest/autorun'



## our own code
$LOAD_PATH.unshift( '../rubidity-typed/lib' )
$LOAD_PATH.unshift( '../rubidity/lib' )
$LOAD_PATH.unshift( '../rubidity-contracts/lib' )
require 'rubidity'
require 'rubidity/contracts'

