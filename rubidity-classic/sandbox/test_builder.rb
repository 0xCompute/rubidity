################
#  to run use:
#    $ ruby sandbox/test_builder.rb

$LOAD_PATH.unshift( './lib' )
require 'rubidity/classic'


source = Builder.load_file( 'PublicMintERC20' ).source
pp source


source = Builder.load_file( 'GenerativeERC721' ).source
pp source


puts "bye"