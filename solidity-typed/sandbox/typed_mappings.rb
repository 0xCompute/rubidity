##
# to run use:
#   $ ruby sandbox/typed_mappings.rb


$LOAD_PATH.unshift( "./lib" )
require 'solidity/typed'


module Sandbox

alice   = '0x'+ 'aa'*20
bob     = '0x'+ 'bb'*20
charlie = '0x'+ 'cc'*20

typedclass = Mapping.new( Address, UInt )
pp typedclass

## sames as
typedclass2 = Mapping‹Address→UInt›
pp typedclass2


pp a = typedclass.new
pp a.type
pp a = typedclass.new( { alice   =>  100,
                         bob     =>  200 } )

pp a[ alice ]
pp a[ bob ]
pp a[ charlie ]      
pp a[ charlie ] = 300
pp a[ charlie ]      
pp a.serialize



######################
## try with struct

#
# struct :Bet,
#   user:   Address, 
#   block:  UInt,  
#   cap:    UInt, 
#   amount: UInt   
#
Bet = Struct.new( :Bet, 
                      user:    Address,
                      block:   UInt,
                      cap:     UInt,
                      amount:  UInt  )


pp Bet
pp Bet.attributes
pp Bet.type



bet = Bet.new
pp bet


typedclass = Mapping.new( UInt, Bet )
pp typedclass
pp typedclass.type


bets = typedclass.new
pp bets
puts "serialize:"
pp bets.serialize

bet = bets[0]
pp bet
bet.amount = 123


pp bets[0]


bets[0] = bet
pp bets[0]

puts "serialize:"
pp bets.serialize

# >Bet struct(user address,block uint,cap uint,amount uint)
bets[4] = Bet.new( bob, 0, 0, 234 )
bets[6] = Bet.new( charlie, 0, 0, 345 )

puts "serialize:"
pp bets.serialize


puts "bye"

end  # module Sandbox
