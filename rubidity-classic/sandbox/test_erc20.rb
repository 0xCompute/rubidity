################
#  to run use:
#    $ ruby sandbox/test_erc20.rb


$LOAD_PATH.unshift( '../solidity-typed/lib' )
$LOAD_PATH.unshift( '../rubidity/lib' )
$LOAD_PATH.unshift( './lib' )
require 'rubidity/classic'



source = Builder.load_file( 'PublicMintERC20' ).source
pp source
pp source.contracts

puts "  #{source.contracts.size} contract(s):"
source.contracts.each do |contract|
    print "   #{contract.name}"
    print " is #{contract.is.inspect}"   unless contract.is.empty?
    print "\n"
end


####################
### generate contract classes
source.generate



#############
#  try out contract classes

pp ERC20
pp PublicMintERC20

pp ERC20.name
pp PublicMintERC20.name


pp ERC20::Transfer   ## {:from=>:address,  :to=>:address,      :amount=>:uint256}
pp ERC20::Approval   ## {:owner=>:address, :spender=>:address, :amount=>:uint256}
pp ERC20::Transfer.name 
pp ERC20::Approval.name

pp ERC20::Transfer.new( from: address(0), to: address(0), amount: 0)
pp ERC20::Approval.new( owner: address(0), spender: address(0), amount: 0)




contract = ERC20.new
pp contract
contract.constructor( name: 'My Fun Token',
                      symbol: 'FUN',
                      decimals: 18 )

pp contract

contract.__ERC20__constructor( name: 'My Fun Token',
                               symbol: 'FUN',
                               decimals: 18 )
pp contract



contract = PublicMintERC20.new
pp contract


contract.__ERC20__constructor( name: 'My Fun Token',
                               symbol: 'FUN',
                               decimals: 18 )
pp contract



## try call constructor
##  [debug] add sig args: [Types::String, Types::String, Types::UInt, Types::UInt, Types::UInt], opti

puts
puts "==========="

contract.constructor( name: 'My Fun Token',
                      symbol: 'FUN',
                      maxSupply: 21000000,
                      perMintLimit: 10000,
                      decimals: 18 )
pp contract
pp contract.serialize



### test drive

alice   = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
bob     = '0x'+'b'*40 # e.g. '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
charlie = '0x'+'c'*40 # e.g. '0xcccccccccccccccccccccccccccccccccccccccc'

pp alice
pp bob
pp charlie


## 
#   function :mint, { amount: :uint256 }, :public  
Runtime.msg.sender = alice

contract.mint( 1000 )   
contract.mint( 100 )   

pp contract.serialize



Runtime.msg.sender = bob

contract.mint( 500 )   
contract.mint( 10 )   
# contract.mint( 2000 )   

pp contract.serialize


pp contract.totalSupply
pp contract.balanceOf( alice )
pp contract.balanceOf( bob )
pp contract.serialize


##
# function :transfer, { to: :addressOrDumbContract, amount: :uint256 }, :public
Runtime.msg.sender = alice

contract.transfer( to: bob, amount: 111 )
contract.transfer( to: charlie, amount: 11 )


Runtime.msg.sender = bob

contract.transfer( to: alice, amount: 11 )
contract.transfer( to: charlie, amount: 111 )



pp contract.totalSupply
pp contract.balanceOf( alice )
pp contract.balanceOf( bob )
pp contract.balanceOf( charlie )
pp contract.serialize



puts "bye"