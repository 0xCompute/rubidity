$LOAD_PATH.unshift( '../solidity-typed/lib' )
$LOAD_PATH.unshift( '../rubidity/lib' )
$LOAD_PATH.unshift( '../rubidity-classic/lib' )

require 'rubidity/classic'


####################
# load (parse) and generate contract classes

source = Contract.load( 'UniswapV2Factory' )

pp source.contracts

puts "  #{source.contracts.size} contract(s):"
source.contracts.each do |contract|
    print "   #{contract.name}"
    print " is #{contract.is.inspect}"   unless contract.is.empty?
    print "\n"
end

#=>  6 contract(s):
#   UniswapV2Callee
#   ERC20
#   UniswapV2ERC20 is [:ERC20]
#   IUniswapV2Factory
#   UniswapV2Pair is [:UniswapV2ERC20]
#   UniswapV2Factory



#############
#  try out contract classes

pp UniswapV2Factory
pp IUniswapV2Factory
pp UniswapV2Pair 
pp UniswapV2ERC20
pp ERC20
pp UniswapV2Callee

pp UniswapV2Factory.name
pp IUniswapV2Factory.name
pp UniswapV2Pair.name 
pp UniswapV2ERC20.name
pp ERC20.name
pp UniswapV2Callee.name


pp UniswapV2Factory::PairCreated
pp UniswapV2Factory::PairCreated.name

pp UniswapV2Pair::Mint
pp UniswapV2Pair::Burn
pp UniswapV2Pair::Swap 
pp UniswapV2Pair::Sync
pp UniswapV2Pair::PreSwapReserves
pp UniswapV2Pair::Mint.name
pp UniswapV2Pair::Burn.name
pp UniswapV2Pair::Swap.name
pp UniswapV2Pair::Sync.name
pp UniswapV2Pair::PreSwapReserves.name
  



alice   = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
bob     = '0x'+'b'*40 # e.g. '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
charlie = '0x'+'c'*40 # e.g. '0xcccccccccccccccccccccccccccccccccccccccc'

pp alice
pp bob
pp charlie



factory = UniswapV2Factory.new
pp factory

factory.constructor( _feeToSetter: alice ) 


Runtime.msg.sender = alice
factory.setFeeTo( _feeTo: bob )
 
factory.setFeeToSetter( _feeToSetter: bob  )

Runtime.msg.sender = bob
factory.setFeeTo( _feeTo: charlie )


pp factory.serialize
#=> {:feeTo=>"0xcccccccccccccccccccccccccccccccccccccccc",
#    :feeToSetter=>"0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
#    :getPair=>{},
#    :allPairs=>[]}

pp factory.allPairsLength
pp factory.getAllPairs


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
  
  
#  pair = factory.createPair(tokenA, tokenB)
pair = factory.createPair( tokenA: tokenA.__address__, 
                           tokenB: tokenB.__address__ ) 

pp pair                           

pp factory.serialize
pp factory.allPairsLength
pp factory.getAllPairs
                


pair_contract = UniswapV2Pair.at( pair )
pp pair_contract
pp pair_contract.serialize
pp pair_contract.__address__


puts "bye"

##
#  -  UniswapV2Pair - called from UniswapV2Factory
#       msg.sender MUST set to address of calling contract UniswapV2Factory
#  constructor() do
#  super
#  s.factory = msg.sender

