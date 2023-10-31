################
#  to run use:
#    $ ruby sandbox/test_supplychain.rb


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

puts "bye"
