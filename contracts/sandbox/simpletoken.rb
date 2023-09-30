##
#  to run use:
#    $ ruby sandbox/simpletoken.rb

require_relative 'helper'



require_relative '../simpletoken'


##
# check metadata
pp SimpleToken.state_variable_definitions
pp SimpleToken.parent_contracts 
pp SimpleToken.events 
pp SimpleToken.is_abstract_contract

abi = SimpleToken.abi

puts
puts "public_abi:"
pp SimpleToken.public_abi




####
# test drive

contract = SimpleToken.new
pp contract


name       = contract.instance_variable_get( :@name)
symbol     = contract.instance_variable_get( :@symbol )
maxSupply  = contract.instance_variable_get( :@maxSupply )
totalSupply  = contract.instance_variable_get( :@totalSupply ) 
perMintLimit = contract.instance_variable_get( :@perMintLimit ) 
balanceOf   =  contract.instance_variable_get( :@balanceOf )

pp name
pp symbol
pp maxSupply
pp totalSupply
pp perMintLimit
pp balanceOf


pp contract.name   ## todo/check: allow access WITHOUT .s(.state_proxy) - why? why not?
pp contract.symbol
pp contract.maxSupply
pp contract.totalSupply
pp contract.perMintLimit
#  mapping ({ addressOrDumbContract: :uint256 }), :public, :balanceOf
# pp contract.balanceOf

pp contract.serialize


contract.constructor(
    name: 'My Fun Token', # string
    symbol: 'FUN', # string
    maxSupply: 21000000, # uint256
    perMintLimit: 1000   # uint256
  ) 

  
pp contract.name
pp contract.symbol
pp contract.maxSupply
pp contract.totalSupply
pp contract.perMintLimit
## pp contract.balanceOf
pp contract.serialize


alice   = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
bob     = '0x'+'b'*40 # e.g. '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
charlie = '0x'+'c'*40 # e.g. '0xcccccccccccccccccccccccccccccccccccccccc'

pp alice
pp bob
pp charlie


## 
#   function :mint, { amount: :uint256 }, :public  
Simulacrum.msg.sender = alice

contract.mint( 1000 )   
contract.mint( 100 )   

Simulacrum.msg.sender = bob

contract.mint( 500 )   
contract.mint( 10 )   
# contract.mint( 2000 )   



pp contract.totalSupply
pp contract.balanceOf( alice )
pp contract.balanceOf( bob )
pp contract.serialize


##
# function :transfer, { to: :addressOrDumbContract, amount: :uint256 }, :public
Simulacrum.msg.sender = alice

contract.transfer( to: bob, amount: 111 )
contract.transfer( to: charlie, amount: 11 )


Simulacrum.msg.sender = bob

contract.transfer( to: alice, amount: 11 )
contract.transfer( to: charlie, amount: 111 )



pp contract.totalSupply
pp contract.balanceOf( alice )
pp contract.balanceOf( bob )
pp contract.balanceOf( charlie )
pp contract.serialize

puts "bye"
