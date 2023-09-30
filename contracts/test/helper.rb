# minitest setup
require 'minitest/autorun'


## our own code
$LOAD_PATH.unshift( '../rubidity-typed/lib' )
$LOAD_PATH.unshift( '../rubidity/lib' )
$LOAD_PATH.unshift( '../rubidity-simulacrum/lib' )


require 'rubidity/typed'
require 'rubidity'
require 'rubidity/simulacrum'
