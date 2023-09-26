####
# to run use:
#   $ ruby sandbox/test_run.rb


$LOAD_PATH.unshift( '../rubidity-typed/lib' )
$LOAD_PATH.unshift( '../rubidity/lib' )
$LOAD_PATH.unshift( './lib' )

require 'simulacrum'


pp genesis   = '0x'+'11'*20  #=> '0x1111111111111111111111111111111111111111'
pp alice     = '0x'+'aa'*20  #=> '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
pp bob       = '0x'+'bb'*20  #=> '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
pp charlie   = '0x'+'cc'*20  #=> '0xcccccccccccccccccccccccccccccccccccccccc'


pp Account[ genesis ]
pp Account[ alice ]
pp Account[ bob ]
pp Account[ charlie ]

Account[ alice ].balance     = 1_000_000
Account[ bob ].balance       = 1_000_000
Account[ charlie ].balance   = 1_000_000


pp Account.all



require_relative 'ponzi_simple'



Simulacrum.msg.sender = genesis
Simulacrum.msg.value = 0
ponzi = SimplePonzi.construct
pp ponzi
pp ponzi.serialize

Simulacrum.msg.sender = alice
Simulacrum.msg.value = 100_000
ponzi.receive
pp ponzi


Simulacrum.msg.sender = bob
Simulacrum.msg.value = 111_000
ponzi.receive
pp ponzi

Simulacrum.msg.sender = charlie
Simulacrum.msg.value = 200_000
ponzi.receive
pp ponzi


pp Account.all


puts "bye"
