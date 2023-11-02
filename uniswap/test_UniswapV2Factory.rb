$LOAD_PATH.unshift( '../solidity-typed/lib' )
$LOAD_PATH.unshift( '../rubidity/lib' )
$LOAD_PATH.unshift( '../rubidity-classic/lib' )

require 'rubidity/classic'


####################
# load (parse) and generate contract classes

Contract.load( 'UniswapV2Factory' )


#############
#  try out contract classes

pp UniswapV2Factory
pp UniswapV2Factory.name



puts "bye"