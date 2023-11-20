###
# to run use (in /punks):
#   $ ruby test_PunksV2.rb


$LOAD_PATH.unshift( '../solidity-typed/lib' )
$LOAD_PATH.unshift( '../rubysol/lib' )
require 'rubysol'


require_relative 'PunksV2'   #  punks contract


pp PunksMarket
pp PunksMarket.name

pp PunksMarket::Assign 
pp PunksMarket::Transfer
pp PunksMarket::PunkTransfer
pp PunksMarket::PunkOffered
pp PunksMarket::PunkBidEntered
pp PunksMarket::PunkBidWithdrawn
pp PunksMarket::PunkBought
pp PunksMarket::PunkNoLongerForSale

pp PunksMarket::Offer
pp PunksMarket::Bid

pp PunksMarket::Assign.name
pp PunksMarket::Transfer.name
pp PunksMarket::PunkTransfer.name
pp PunksMarket::PunkOffered.name
pp PunksMarket::PunkBidEntered.name
pp PunksMarket::PunkBidWithdrawn.name
pp PunksMarket::PunkBought.name
pp PunksMarket::PunkNoLongerForSale.name
pp PunksMarket::Offer.name
pp PunksMarket::Bid.name



ALICE   = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
BOB     = '0x'+'b'*40 
CHARLIE = '0x'+'c'*40 

pp ALICE
pp BOB
pp CHARLIE


Runtime.msg.sender =  ALICE

punks = PunksMarket.construct
pp punks
pp punks.serialize

pp punks.name
pp punks.symbol
pp punks.decimals
pp punks.totalSupply
pp punks.balanceOf( ALICE )


puts "bye"
