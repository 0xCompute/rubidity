# minitest setup
require 'minitest/autorun'


## our own code
$LOAD_PATH.unshift( '../solidity-typed/lib' )
$LOAD_PATH.unshift( '../rubysol/lib' )
$LOAD_PATH.unshift( './lib' )  ### gets auto-added by rake test?? keep here - why? why not?

require 'rubysol/contracts'

