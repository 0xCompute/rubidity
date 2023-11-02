$LOAD_PATH.unshift( '../solidity-typed/lib' )
$LOAD_PATH.unshift( '../rubidity/lib' )
$LOAD_PATH.unshift( '../rubidity-classic/lib' )

require 'rubidity/classic'


####################
# load (parse) and generate contract classes

Contract.load( 'UnsafeNoApprovalERC20' )



#############
#  try out contract classes

pp UnsafeNoApprovalERC20
pp UnsafeNoApprovalERC20.name


pp ERC20::Transfer
pp ERC20::Approval
pp ERC20::Transfer.name
pp ERC20::Approval.name



alice   = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
bob     = '0x'+'b'*40 # e.g. '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
charlie = '0x'+'c'*40 # e.g. '0xcccccccccccccccccccccccccccccccccccccccc'

pp alice
pp bob
pp charlie


cham = UnsafeNoApprovalERC20.new
pp cham
cham.constructor( name: "Chameleon", symbol: "CHAM" )
pp cham.serialize

Runtime.msg.sender = alice
cham.mint( 100 )
cham.mint( 110 )

Runtime.msg.sender = bob
cham.mint( 200 )
cham.mint( 222 )

cham.transferFrom( from: bob, to: charlie, amount: 33 ) 
pp cham.serialize



mir = UnsafeNoApprovalERC20.new
pp mir
mir.constructor( name: "Mirage", symbol: "MIR" )
pp mir.serialize


emd = UnsafeNoApprovalERC20.new
pp emd
emd.constructor( name: "Emerald", symbol: "EMD" )
pp emd.serialize


  




puts "bye"