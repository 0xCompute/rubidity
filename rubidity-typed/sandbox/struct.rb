##
# to run use:
#   $ ruby sandbox/struct.rb


$LOAD_PATH.unshift( './lib' )
require 'rubidity/typed'


#
# struct :Bet,
#   user:   Address, 
#   block:  UInt,  
#   cap:    UInt, 
#   amount: UInt   
#

module Sandbox

Bet = Struct.build_class( :Bet, 
                       user:    Address,
                       block:   UInt,
                       cap:     UInt,
                       amount:  UInt  )


pp Bet
pp Bet.attributes




bet = Bet.new
pp bet
pp bet.user
pp bet.amount
puts "serialize:"
pp bet.serialize

pp bet.zero?

pp bet.user = Address.new( '0x'+'aa'*20 )
pp bet.amount = UInt.new( 123 )

pp bet
puts "serialize:"
state = bet.serialize
pp state


pp bet.user   = '0x'+'bb'*20    ## literal assign (with typecheck)
pp bet.amount = 234   ## literal assign (with typecheck)
puts "serialize:"
pp bet.serialize



bet2  = Bet.new
pp bet2
puts "serialize:"
pp bet2.serialize



# puts "deserialize:"
# bet2.deserialize( state )
# pp bet2


puts "serialize:"
pp bet2.serialize


bet3 = Bet.zero
bet3.zero?
pp bet3
puts "serialize:"
pp bet3.serialize


bet4 = Bet.new( '0x'+'cc'*20,  0, 0, 456 )
pp bet4
puts "serialize:"
pp bet4.serialize


puts 'bye'

end   # module Sandbox