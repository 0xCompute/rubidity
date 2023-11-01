################
#  to run use:
#    $ ruby sandbox/test_supplychain.rb


$LOAD_PATH.unshift( '../solidity-typed/lib' )
$LOAD_PATH.unshift( '../rubidity/lib' )
$LOAD_PATH.unshift( './lib' )
require 'rubidity/classic'



####################
# load (parse) and generate contract classes

Contract.load( 'SupplyChain' )



#############
#  try out contract classes

pp SupplyChain

pp SupplyChain.name


pp SupplyChain::Transfer
pp SupplyChain::Transfer.name

pp SupplyChain::Transfer.new( productId: 111 )


pp SupplyChain::Product
pp SupplyChain::Participant
pp SupplyChain::Registration
pp SupplyChain::Product.name
pp SupplyChain::Participant.name
pp SupplyChain::Registration.name


alice   = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
bob     = '0x'+'b'*40 # e.g. '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
charlie = '0x'+'c'*40 # e.g. '0xcccccccccccccccccccccccccccccccccccccccc'

pp alice
pp bob
pp charlie

pp SupplyChain::Product.new( modelNumber: 'model1',
                             partNumber:  'part1',
                             serialNumber: 'serial1',
                             productOwner: alice,
                             cost:         1000,
                             mfgTimestamp: 1698756267 )
                   
pp SupplyChain::Participant.new( userName: 'alice',
                                 password: 'passa',
                                 participantType: 'manufacturer',
                                 participantAddress: alice )

pp SupplyChain::Registration.new( productId:  1,  
                                   ownerId:   1, 
                                   productOwner: alice,
                                   trxTimestamp: 1698756267 )                    



contract = SupplyChain.new
pp contract

pp contract.p_id
pp contract.u_id
pp contract.r_id

pp contract.serialize
#=>
# {:p_id=>0, :u_id=>0, :r_id=>0,
#  :products=>{}, 
#  :participants=>{}, 
#  :registrations=>{}, 
#  :productTrack=>{}}



pp contract.createParticipant( name: 'alice', 
                               pass: 'passa', 
                               addr: alice, 
                               type: 'manufacturer' )

pp contract.createParticipant( name: 'bob', 
                               pass: 'passb', 
                               addr: bob, 
                               type: 'supplier' )

pp contract.createParticipant( name: 'charlie', 
                               pass: 'passc', 
                               addr: charlie, 
                               type: 'consumer' )

pp contract.serialize


pp contract.getParticipantDetails( 1 )
pp contract.getParticipantDetails( 2 )
pp contract.getParticipantDetails( 3 )



## set block.timestamp
Runtime.block.timestamp = 1698846375


pp contract.createProduct( ownerId: 1,
                             modelNumber: 'prod1',
                             partNumber: '100',
                             serialNumber: '123',
                             productCost: 11 )

pp contract.serialize

pp contract.getProductDetails( 1 )


Runtime.msg.sender = alice
Runtime.block.timestamp = 1698847541

pp contract.transferToOwner( user1Id: 1,
                             user2Id: 2, 
                             prodId: 1 )

Runtime.msg.sender = bob
Runtime.block.timestamp = 1698848314

pp contract.transferToOwner( user1Id: 2,
                             user2Id: 3, 
                             prodId: 1 )


pp contract.serialize


pp contract.getRegistrationDetails( 1 )
pp contract.getRegistrationDetails( 2 )

pp contract.getProductTrack( 1 )


puts "bye"
