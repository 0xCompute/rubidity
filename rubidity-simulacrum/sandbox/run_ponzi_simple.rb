####
# to run use:
#   $ ruby sandbox/run_ponzi_simple.rb


$LOAD_PATH.unshift( '../rubidity-typed/lib' )
$LOAD_PATH.unshift( '../rubidity/lib' )
$LOAD_PATH.unshift( './lib' )

require 'simulacrum'


require_relative 'ponzi_simple'


###
# test contract
pp genesis   = '0x'+'11'*20  #=> '0x1111111111111111111111111111111111111111'
pp alice     = '0x'+'aa'*20  #=> '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
pp bob       = '0x'+'bb'*20  #=> '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
pp charlie   = '0x'+'cc'*20  #=> '0xcccccccccccccccccccccccccccccccccccccccc'


## setup test accounts with starter balance
Account[ genesis ].balance   = 0
Account[ alice   ].balance   = 1_000_000
Account[ bob     ].balance   = 1_000_000
Account[ charlie ].balance   = 1_000_000


## pretty print (pp) all known accounts with balance
pp Account.all

## genesis - create contract
ponzi = Simulacrum.send_transaction( from: genesis, data: SimplePonzi ).contract
pp ponzi


Simulacrum.send_transaction( from: alice, to: ponzi, value: 100_000 )
pp ponzi

Simulacrum.send_transaction( from: bob, to: ponzi, value: 111_000 )
pp ponzi

Simulacrum.send_transaction( from: charlie, to: ponzi, value: 200_000 )
pp ponzi

## pretty print (pp) all known accounts with balance
pp Account.all


puts "bye"