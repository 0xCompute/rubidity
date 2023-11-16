################
#  to run use:
#    $ ruby sandbox/test_builder.rb

$LOAD_PATH.unshift( '../solidity-typed/lib' )
$LOAD_PATH.unshift( '../rubysol/lib' )
$LOAD_PATH.unshift( './lib' )
require 'rubidity'


source = Builder.load_file( 'PublicMintERC20' ).source
pp source


source = Builder.load_file( 'GenerativeERC721' ).source
pp source


puts "bye"