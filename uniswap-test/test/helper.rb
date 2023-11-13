# minitest setup
require 'minitest/autorun'


## our own code
$LOAD_PATH.unshift( '../solidity-typed/lib' )
$LOAD_PATH.unshift( '../rubidity/lib' )
$LOAD_PATH.unshift( '../rubidity-classic/lib' )

require 'rubidity/classic'
