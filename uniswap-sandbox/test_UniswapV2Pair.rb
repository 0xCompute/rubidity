$LOAD_PATH.unshift( '../solidity-typed/lib' )
$LOAD_PATH.unshift( '../rubidity/lib' )
$LOAD_PATH.unshift( '../rubidity-classic/lib' )

require 'rubidity/classic'

# note:  
#  UniswapV2Pair required factory (parent) for handling fees and such!!


####################
# load (parse) and generate contract classes

source = Contract.load( 'UniswapV2Pair' )

pp source.contracts

puts "  #{source.contracts.size} contract(s):"
source.contracts.each do |contract|
    print "   #{contract.name}"
    print " is #{contract.is.inspect}"   unless contract.is.empty?
    print "\n"
end

# 5 contract(s):
#   UniswapV2Callee
#   ERC20
#   UniswapV2ERC20 is [:ERC20]
#   IUniswapV2Factory
#   UniswapV2Pair is [:UniswapV2ERC20]


alice   = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
bob     = '0x'+'b'*40 # e.g. '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
charlie = '0x'+'c'*40 # e.g. '0xcccccccccccccccccccccccccccccccccccccccc'

pp alice
pp bob
pp charlie



# tokenA = UnsafeNoApprovalERC20.new
# tokenA.constructor( name: "TokenA",
#                     symbol: "TKA" )
# pp tokenA
tokenA = UnsafeNoApprovalERC20.construct( name: "TokenA",
                                          symbol: "TKA" )
pp tokenA
pp tokenA.__address__
  
# tokenB = UnsafeNoApprovalERC20.new
# tokenB.constructor( name: "TokenB",
#                     symbol: "TKB" )
# pp tokenB

tokenB = UnsafeNoApprovalERC20.construct( name: "TokenB",
                                          symbol: "TKB" )
pp tokenB
pp tokenB.__address__
  
  

            


puts "bye"
