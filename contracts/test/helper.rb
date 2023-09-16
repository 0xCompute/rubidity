# minitest setup
require 'minitest/autorun'


## our own code
$LOAD_PATH.unshift( '../rubidity-typed/lib' )
$LOAD_PATH.unshift( '../rubidity/lib' )

require 'rubidity/typed'
require 'rubidity'
