################################
# Satoshi Dice Contract



class SathoshiDice < Contract

event :BetPlaced, id: UInt, user: Address, cap: UInt, amount: UInt
event :Roll,      id: UInt, rolled: UInt

struct :Bet,
         user:   Address, 
         block:  UInt,  
         cap:    UInt, 
         amount: UInt 

storage   owner:    Address,
          counter:  UInt,
          bets:     mapping( UInt, Bet ) 

## Fee (Casino House Edge) is 1.9%, that is, 19 / 1000
FEE_NUMERATOR   = 19
FEE_DENOMINATOR = 1000

MAXIMUM_CAP = 2**16   # 65_536 = 2^16 = 2 byte/16 bit
MAXIMUM_BET = 100_000_000
MINIMUM_BET = 100


sig :constructor, []
def constructor
  @owner  = msg.sender
end

sig :bet, [UInt] 
def bet( cap: )
  assert cap >= 1 && cap <= MAXIMUM_CAP,  'invalid cap'
  assert msg.value >= MINIMUM_BET && msg.value <= MAXIMUM_BET, 'invalid bet'

  @counter += 1
  @bets[@counter] = Bet.new( msg.sender, block.number+3, cap, msg.value )

  log :BetPlaced,  id: @counter, user: msg.sender, cap: cap, amount: msg.value
end



sig :roll, [UInt]
def roll( id: )
  bet = @bets[id]

  assert msg.sender == bet.user
  assert block.number >= bet.block
  assert block.number <= bet.block + 255

  ## "provable" fair - random number depends on
  ##  - blockhash (of block in the future - t+3)
  ##  - nonce (that is, bet counter id)
  hex = sha256( "#{blockhash( bet.block )} #{id}" )
  ## get first 2 bytes (4 chars in hex string) and convert to integer number
  ##   results in a number between 0 and 65_535
  rolled = hex_to_i( hex[0,4] )

  if rolled < bet.cap
     payout = bet.amount * MAXIMUM_CAP / bet.cap
     fee = payout * FEE_NUMERATOR / FEE_DENOMINATOR
     payout -= fee

     msg.sender.transfer( payout )
  end

  log :Roll, id: id, rolled: rolled
  @bets.delete( id )
end

sig :fund, []
def fund
end

sig :kill, []
def kill
  assert msg.sender == @owner
  selfdestruct( @owner )
end

end  # class SathoshiDice