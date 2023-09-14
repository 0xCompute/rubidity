##
#  to run use:
#    $ ruby sandbox/simpletoken.rb

require_relative 'helper'



require_relative '../simpletoken'


contract = SimpleToken.create
pp contract

pp contract.s.name
pp contract.s.symbol
pp contract.s.maxSupply
pp contract.s.totalSupply
pp contract.s.perMintLimit
pp contract.s.balanceOf


pp contract.name   ## todo/check: allow access WITHOUT .s(.state_proxy) - why? why not?
pp contract.symbol
pp contract.maxSupply
pp contract.totalSupply
pp contract.perMintLimit
#  mapping ({ addressOrDumbContract: :uint256 }), :public, :balanceOf
# pp contract.balanceOf

pp contract.state_proxy.serialize


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
pp contract.state_proxy.serialize


alice   = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
bob     = '0x'+'b'*40 # e.g. '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
charlie = '0x'+'c'*40 # e.g. '0xcccccccccccccccccccccccccccccccccccccccc'

pp alice
pp bob
pp charlie


## 
#   function :mint, { amount: :uint256 }, :public  
contract.msg.sender = alice
pp contract.msg.sender

contract.mint( 1000 )   
contract.mint( 100 )   

contract.msg.sender = bob
pp contract.msg.sender

contract.mint( 500 )   
contract.mint( 10 )   
# contract.mint( 2000 )   



pp contract.totalSupply
## pp contract.balanceOf
pp contract.state_proxy.serialize


##
# function :transfer, { to: :addressOrDumbContract, amount: :uint256 }, :public
contract.msg.sender = alice
pp contract.msg.sender

contract.transfer( to: bob, amount: 111 )
contract.transfer( to: charlie, amount: 11 )
  
contract.msg.sender = bob
pp contract.msg.sender

contract.transfer( to: alice, amount: 11 )
contract.transfer( to: charlie, amount: 111 )



pp contract.s.totalSupply
pp contract.s.balanceOf
pp contract.s.balanceOf[ alice ]
pp contract.s.balanceOf[ bob ]
pp contract.s.balanceOf[ charlie ]
pp contract.state_proxy.serialize

puts "bye"