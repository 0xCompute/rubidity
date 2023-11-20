###
# to run use (in /punks):
#   $ ruby test_Punks.rb


$LOAD_PATH.unshift( '../solidity-typed/lib' )
$LOAD_PATH.unshift( '../rubysol/lib' )
require 'rubysol'


require_relative 'Punks'   #  punks contract


pp Punks
pp Punks.name

pp Punks::Assign
pp Punks::Transfer
pp Punks::PunkTransfer
pp Punks::PunkOffered
pp Punks::PunkBought
pp Punks::PunkNoLongerForSale

pp Punks::Offer

pp Punks::Assign.name
pp Punks::Transfer.name
pp Punks::PunkTransfer.name
pp Punks::PunkOffered.name
pp Punks::PunkBought.name
pp Punks::PunkNoLongerForSale.name
pp Punks::Offer.name



ALICE   = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
BOB     = '0x'+'b'*40 
CHARLIE = '0x'+'c'*40 

pp ALICE
pp BOB
pp CHARLIE


Runtime.msg.sender =  ALICE

punks = Punks.construct
pp punks
pp punks.serialize

#=> {:owner=>"0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
#    :name=>"PUNKS",
#    :symbol=>"P",
#    :decimals=>0,
#    :totalSupply=>10000,
#    :nextPunkIndexToAssign=>0,
#    :punksRemainingToAssign=>10000,
#    :numberOfPunksToReserve=>1000,
#    :numberOfPunksReserved=>0,
#    :punkIndexToAddress=>{},
#    :balanceOf=>{},
#    :punksOfferedForSale=>{},
#    :pendingWithdrawals=>{}}

pp punks.name
pp punks.symbol
pp punks.decimals
pp punks.totalSupply
pp punks.balanceOf( ALICE )



punks.reservePunksForOwner( 100 ) 
 
pp punks.nextPunkIndexToAssign   #=> 100
pp punks.punksRemainingToAssign  #=> 9900


Runtime.msg.sender =  BOB

punks.getPunk( 100 )
punks.getPunk( 101 )
punks.getPunk( 102 )

# note: nextPunkIndexToAssign only gets updated in reservePunksForOwner
pp punks.nextPunkIndexToAssign   #=> 100
pp punks.punksRemainingToAssign  #=> 9897


pp punks.balanceOf( ALICE )    #=> 100
pp punks.balanceOf( BOB )      #=> 3


Runtime.msg.sender =  ALICE

punks.transferPunk( to: CHARLIE, punkIndex: 99 ) 
  
pp punks.balanceOf( ALICE )      #=> 99
pp punks.balanceOf( BOB )        #=> 3
pp punks.balanceOf( CHARLIE )    #=> 1


pp punks.serialize

puts "bye"
