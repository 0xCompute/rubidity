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


  function :createParticipant, { name: :string, 
                                 pass: :string, 
                                 addr: :address, 
                                 type: :string }, :public, returns: :uint32 do
      userId = s.u_id += 1
      s.participants[ userId ].userName = name
      s.participants[ userId ].password = pass
      s.participants[ userId ].participantAddress = addr
      s.participants[ userId ].participantType = type
      return userId
  end


  function :getParticipantDetails, { id: :uint32 }, :public, :view, returns: [:string,:address,:string] do
    return [s.participants[ id ].userName,
            s.participants[ id ].participantAddress,
            s.participants[ id ].participantType]
  end


  function :createProduct, { ownerId: :uint32,
                             modelNumber: :string,
                             partNumber: :string,
                             serialNumber: :string,
                             productCost: :uint32 }, :public, returns: :uint32 do     
      require( s.participants[ ownerId ].participantType == "manufacturer",  "must be manufacturer" ) 
      ## check - string compare NOT possible in solidity?
      ##  use keccak256() compare via hash (is workaround)??                
      
      productId = s.p_id += 1
      s.products[ productId ].modelNumber  = modelNumber
      s.products[ productId ].partNumber   = partNumber
      s.products[ productId ].serialNumber = serialNumber
      s.products[ productId ].cost         = productCost
      s.products[ productId ].productOwner = s.participants[ownerId].participantAddress
      s.products[ productId ].mfgTimestamp = block.timestamp
      return productId
  end

  
  function :getProductDetails, { id: :uint32 }, :public, :view, returns: [:string,:string,:string,:uint32,:address,:timestamp] do
      return [s.products[ id ].modelNumber,
              s.products[ id ].partNumber,
              s.products[ id ].serialNumber,
              s.products[ id ].cost,
              s.products[ id ].productOwner,
              s.products[ id ].mfgTimestamp]
  end

   
  function :transferToOwner, { user1Id: :uint32,
                               user2Id: :uint32, 
                               prodId: :uint32 }, :public, returns: :bool do
        require( msg.sender == s.products[prodId].productOwner, "only owner" )

        p1 = s.participants[ user1Id ]
        p2 = s.participants[ user2Id ]
        registrationId = s.r_id += 1
        
        s.registrations[ registrationId ].productId    = prodId
        s.registrations[ registrationId ].productOwner = p2.participantAddress 
        s.registrations[ registrationId ].ownerId      = user2Id
        s.registrations[ registrationId ].trxTimestamp = block.timestamp

        s.products[ prodId ].productOwner = p2.participantAddress
        s.productTrack[ prodId ].push( registrationId )

        emit :Transfer, prodId

        return true
  end


  
  function :getProductTrack, { prodId: :uint32 }, :public, :view, returns: array(:uint32) do 
      return s.productTrack[ prodId ]
  end



  function :getRegistrationDetails, { regId: :uint32 }, :public, :view, returns: [:uint32, :uint32, :address, :timestamp] do
      r = s.registrations[ regId ]

      return [r.productId,
              r.ownerId,
              r.productOwner,
              r.trxTimestamp]
  end
end


