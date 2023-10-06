


##[sig(Integer, Bool, Integer, Address)]
##
## Struct.new( :Voter,
##  weight:   0,
##  voted:    false,
##  vote:     0,
##  delegate: '0x0000' )
##
## struct :Voter, 
##     weight:   UInt,
##     voted:    false,
##     vote:     0,
##    delegate: '0x0000' }
### -or-
# struct :Voter,
#   weight:   0,
#   voted:    false,
#   vote:     0,
#   delegate: '0x0000'

module Sandbox

  ## use scope Types here - why? why not?
structclass =  Struct.new( :Voter,
                             scope: Types,     
                             weight:    UInt,
                             voted:     Bool,
                             vote:      UInt,
                             delegate:  Address )

pp structclass
pp structclass.name   ##=>  Types::Voter

pp Voter.new
pp Voter.new( 0, false, 0, address(0) )
end

