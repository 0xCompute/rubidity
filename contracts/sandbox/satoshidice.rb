##
#  to run use:
#    $ ruby sandbox/satoshidice.rb

require_relative 'helper'


require_relative '../satoshidice'


pp SathoshiDice

contract = SathoshiDice.new
pp contract
puts "serialize:"
pp contract.serialize



alice   = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
bob     = '0x'+'b'*40 # e.g. '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
charlie = '0x'+'c'*40 # e.g. '0xcccccccccccccccccccccccccccccccccccccccc'

Simulacrum.msg.sender = alice


contract = SathoshiDice.construct 
pp contract.__address__
pp contract
puts "serialize:"
pp contract.serialize
#=> {:owner=>"0x0000000000000000000000000000000000000000",
#    :counter=>0, 
#    :bets=>{}}


Simulacrum.block.number = 888
Simulacrum.msg.sender = bob
Simulacrum.msg.value  = 100

contract.bet( cap: 1000 )       ##  cap max. 65_536 = 2^16 = 2 byte/16 bit

pp contract
puts "serialize:"
pp contract.serialize
#=> {:owner=>"0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
#    :counter=>1,
#    :bets=>{1=>["0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb", 891, 1000, 100]}}

Simulacrum.block.number = 889
Simulacrum.msg.sender = charlie
Simulacrum.msg.value  = 200

contract.bet( cap: 10000 ) 

pp contract
puts "serialize:"
pp contract.serialize
#=> {:owner=>"0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
#    :counter=>2,
#    :bets=>
#     {1=>["0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb", 891, 1000, 100],
#      2=>["0xcccccccccccccccccccccccccccccccccccccccc", 892, 10000, 200]}}


puts 'bye'