

class SupplyChain < Contract

  event :Transfer, productId: UInt

  struct :Product, modelNumber:  String,
                   partNumber:   String,
                   serialNumber: String,
                   productOwner: Address,
                   cost:         UInt,      # uint32
                   mfgTimestamp: Timestamp

  struct :Participant, userName: String,
                       password: String,
                       participantType: String,
                       participantAddress: Address

  struct :Registration, productId:    UInt,  # uint32
                        ownerId:      UInt, 
                        productOwner: Address,
                        trxTimestamp: Timestamp                    
 
  storage p_id: UInt,    # (last) product id     - uint32
          u_id: UInt,    # (last) participant id - uint32 
          r_id: UInt,    # (last) registration id - uint32
          products:      mapping( UInt, Product ),
          participants:  mapping( UInt, Participant ),
          registrations: mapping( UInt, Registration ),
          productTrack:  mapping( UInt, array( UInt ))  # movement track for a product 



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


   ## empty constructor required - double check - why? why not?
   sig :constructor, []
   def constructor
   end
end