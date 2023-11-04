
$LOAD_PATH.unshift( '../rubidity-typed/lib' )
$LOAD_PATH.unshift( '../rubidity/lib' )
$LOAD_PATH.unshift( '../rubidity-contracts/lib' )
require 'rubidity'
require 'rubidity/contracts'


require_relative 'unsafe_no_approval_erc20'
require_relative 'uniswap_v2_erc20'


alice   = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
bob     = '0x'+'b'*40 # e.g. '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
charlie = '0x'+'c'*40 # e.g. '0xcccccccccccccccccccccccccccccccccccccccc'

pp alice
pp bob
pp charlie



c1 = UnsafeNoApprovalERC20.create

c1.msg.sender = alice

c1.constructor( name: 'My Fun token', symbol: 'FUN' )
c1.mint( 100 )
c1.mint( 200 )
pp c1.serialize


c2 = UnsafeNoApprovalERC20.create

c2.msg.sender = bob

c2.constructor( name: 'My Foo token', symbol: 'FOO' )
c2.mint( 111 )
c2.mint( 222 )
pp c2.serialize



u =  UniswapV2ERC20.create
u.constructor
pp u.serialize

  


pp AbiProxy.contract_classes


puts "bye"