pragma :rubidity, "1.0.0"

contract :SupplyChain do

  event :Transfer, { productId: :uint32 }

  struct :Product, { modelNumber:  :string,
                     partNumber:   :string,
                     serialNumber: :string,
                     productOwner: :address,
                     cost:         :uint32,
                     mfgTimestamp: :timestamp }

  struct :Participant, { userName: :string,
                         password: :string,
                         participantType: :string,
                         participantAddress: :address }

  struct :Registration, { productId:    :uint32,  
                          ownerId:      :uint32, 
                          productOwner: :address,
                          trxTimestamp: :timestamp }                    
 
  uint32 :public, :p_id    # (last) product id 
  uint32 :public, :u_id    # (last) participant id
  uint32 :public, :r_id    # (last) registration id

  mapping ({ uint32: :Product }),      :public, :products
  mapping ({ uint32: :Participant }),  :public, :participants
  mapping ({ uint32: :Registration }), :public, :registrations

  # movement track for a product
  mapping ({ uint32: array( :uint32 ) }), :public, :productTrack  

=begin  
   sig :createParticipant, [String, String, Address, String], returns: UInt
   def createParticipant( name:,
                          pass:,
                          addr:,
                          type: )
      userId = @u_id += 1
      @participants[ userId ].userName = name
      @participants[ userId ].password = pass
      @participants[ userId ].participantAddress = addr
      @participants[ userId ].participantType = type
      userId
   end

   sig :getParticipantDetails, [UInt], :view, returns: [String,Address,String]
   def getParticipantDetails( id: )
      [@participants[ id ].userName,
       @participants[ id ].participantAddress,
       @participants[ id ].participantType]
   end


   sig :createProduct, [String, String, Address, String], returns: UInt
   def createProduct( ownerId:,
                      modelNumber:,
                      partNumber:,
                      serialNumber:,
                      productCost: )
     
      assert @participants[ ownerId ].participantType == "Manufacturer",  "must be manufacturer" 
      ## check - string compare NOT possible in solidity?
      ##  use keccak256() compare via hash (is workaround)??                
      
      productId = @p_id += 1
      @products[ productId ].modelNumber  = modelNumber
      @products[ productId ].partNumber   = partNumber
      @products[ productId ].serialNumber = serialNumber
      @products[ productId ].cost         = productCost
      @products[ productId ].productOwner = @participants[ownerId].participantAddress
      @products[ productId ].mfgTimestamp = block.timestamp
      productId
   end
 
   sig :getProductDetails, [UInt], :view, returns: [String,String,String,UInt,Address,Timestamp]
   def getProductDetails( id: )
      [@products[ id ].modelNumber,
       @products[ id ].partNumber,
       @products[ id ].serialNumber,
       @products[ id ].cost,
       @products[ id ].productOwner,
       @products[ id ].mfgTimestamp]
   end
  
   sig :transferToOwner, [UInt, UInt, UInt], returns: Bool
   def transferToOwner( user1Id:,
                        user2Id:, 
                        prodId: )

        assert msg.sender == @products[prodId].productOwner, "only owner"

        p1 = @participants[ user1Id ]
        p2 = @participants[ user2Id ]
        registrationId = @r_id += 1
        
        @registrations[ registrationId ].productId    = prodId
        @registrations[ registrationId ].productOwner = p2.participantAddress 
        @registrations[ registrationId ].ownerId      = user2Id
        @registrations[ registrationId ].trxTimestamp = block.timestamp

        @products[ prodId ].productOwner = p2.participantAddress
        @productTrack[ prodId ].push( registrationId )

        log :Transfer, prodId

        true
   end

   sig :getProductTrack, [UInt], :view, returns: array(UInt) 
   def getProductTrack( prodId: )
       @productTrack[ prodId ]
   end

   sig :getRegistrationDetails, [UInt], :view, returns: [UInt, UInt, Address, Timestamp]
   def getRegistrationDetails( regId: )
      r = @registrations[ regId ]

      [r.productId,
       r.ownerId,
       r.productOwner,
       r.trxTimestamp]
   end
=end

end


