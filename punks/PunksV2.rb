
class PunksMarket < Contract  

    # You can use this hash to verify the image file containing all the punks
    IMAGE_HASH = "0xac39af4793119ee46bbff351d8cb6b5f23da60222126add4268e261199a2921b";

    event :Assign, 
            to: Address, # indexed 
            punkIndex: UInt
    event :Transfer,
             from: Address, # indexed
             to:   Address, # indexed 
             value: UInt
    event :PunkTransfer,
            from: Address, # indexed
            to:   Address, # indexed 
            punkIndex: UInt
    event :PunkOffered,
             punkIndex: UInt, # indexed 
             minValue:  UInt, 
             toAddress: Address
    event :PunkBidEntered,
              punkIndex: UInt, # indexed 
              value: UInt, 
              fromAddress: Address # indexed
    event :PunkBidWithdrawn,
              punkIndex: UInt,  # indexed 
              value:  UInt, 
              fromAddress: Address  # indexed
    event :PunkBought,
              punkIndex: UInt,  # indexed 
              value: UInt, 
              fromAddress: Address,  # indexed 
              toAddress: Address     # indexed
    event :PunkNoLongerForSale,
              punkIndex: UInt  # indexed

    struct :Offer, 
            isForSale:  Bool, 
            punkIndex:  UInt,
            seller:     Address,
            minValue:   UInt,         # in ether
            onlySellTo: Address       # specify to sell only to a specific person
    
    struct :Bid, 
             hasBid:    Bool,
             punkIndex: UInt,
             bidder:    Address,
             value:     UInt 

 
    storage owner: Address,
            name:  String,
            symbol: String,
            decimals: UInt,
            totalSupply: UInt,
            nextPunkIndexToAssign: UInt,
            allPunksAssigned: Bool,
            punksRemainingToAssign: UInt,
            punkIndexToAddress: mapping( UInt, Address ),
            balanceOf: mapping( Address, UInt ),  # This creates an array with all balances 
            punksOfferedForSale: mapping( UInt, Offer), # A record of punks that are offered for sale at a specific minimum value, and perhaps to a specific person
            punkBids: mapping( UInt, Bid ),   #  A record of the highest punk bid
            pendingWithdrawals:  mapping( Address, UInt )

 
    sig []  
    def constructor 
        @owner = msg.sender
        @totalSupply = 10000                     # Update total supply
        @punksRemainingToAssign = @totalSupply
        @name = "PUNKS"                         # Set the name for display purposes
        @symbol = "P"                           # Set the symbol for display purposes
        @decimals = 0                           # Amount of decimals for display purposes
    end

    sig [Address, UInt]
    def setInitialOwner( to:, punkIndex: ) 
        assert msg.sender == @owner
        assert !allPunksAssigned
        assert punkIndex < 10000

        if @punkIndexToAddress[punkIndex] != to
            if @punkIndexToAddress[punkIndex] != address(0)
                @balanceOf[@punkIndexToAddress[punkIndex]] -= 1
            else 
                @punksRemainingToAssign -= 1
            end
            @punkIndexToAddress[punkIndex] = to
            @balanceOf[to] += 1
            log Assign, to: to, punkIndex: punkIndex
        end
    end

    sig [array(Address), array(UInt)]
    def setInitialOwners( addresses:, indices: ) 
        assert msg.sender == owner
        n = addresses.length
        for i in 0..n
            setInitialOwner( addresses[i], indices[i] )
        end
    end

    sig []
    def allInitialOwnersAssigned
        assert msg.sender == owner
        @allPunksAssigned = true
    end

    sig [UInt]
    def getPunk( punkIndex: ) 
        assert @allPunksAssigned
        assert @punksRemainingToAssign != 0
        assert @punkIndexToAddress[punkIndex] == address(0)
        assert punkIndex < 10000

        @punkIndexToAddress[punkIndex] = msg.sender
        @balanceOf[msg.sender] += 1
        @punksRemainingToAssign -= 1
        log Assign, to: msg.sender, punkIndex: punkIndex
    end

    # Transfer ownership of a punk to another user without requiring payment
    sig [Address, UInt]
    def transferPunk( to:, punkIndex: ) 
        assert @allPunksAssigned
        assert @punkIndexToAddress[punkIndex] == msg.sender
        assert punkIndex < 10000
        
        punkNoLongerForSale(punkIndex)  if @punksOfferedForSale[punkIndex].isForSale
            
        @punkIndexToAddress[punkIndex] = to
        @balanceOf[msg.sender] -= 1
        @balanceOf[to] += 1
        log Transfer, from: msg.sender, to: to, value: 1
        log PunkTransfer, from: msg.sender, to: to, punkIndex: punkIndex
        
        # Check for the case where there is a bid from the new owner and refund it.
        # Any other bid can stay in place.
        bid = @punkBids[punkIndex]
        if bid.bidder == to
            # Kill bid and refund value
            @pendingWithdrawals[to] += bid.value
            @punkBids[punkIndex] = Bid.new( hasBid: false, 
                                            punkIndex: punkIndex, 
                                            bidder: address(0), 
                                            value: 0)
        end
    end

    sig [UInt]
    def punkNoLongerForSale( punkIndex: ) 
        assert @allPunksAssigned
        assert @punkIndexToAddress[punkIndex] == msg.sender
        assert punkIndex < 10000
        
        @punksOfferedForSale[punkIndex] = Offer.new( isForSale: false, 
                                                     punkIndex: punkIndex, 
                                                     seller: msg.sender, 
                                                     minValue: 0, 
                                                     onlySellTo: address(0))
        log PunkNoLongerForSale, punkIndex: punkIndex
    end

    sig [UInt, UInt]
    def offerPunkForSale( punkIndex:, minSalePriceInWei: ) 
        assert @allPunksAssigned
        assert @punkIndexToAddress[punkIndex] == msg.sender
        assert punkIndex < 10000

        @punksOfferedForSale[punkIndex] = Offer.new( isForSale: true, 
                                                     punkIndex: punkIndex, 
                                                     seller: msg.sender, 
                                                     minValue: minSalePriceInWei, 
                                                     onlySellTo: address(0))
        log PunkOffered, punkIndex: punkIndex, 
                         minValue: minSalePriceInWei, 
                         toAddress: address(0)
    end

    sig [UInt, UInt, Address]
    def offerPunkForSaleToAddress( punkIndex:, minSalePriceInWei:, toAddress: ) 
        assert  @allPunksAssigned
        assert  @punkIndexToAddress[punkIndex] == msg.sender
        assert  punkIndex < 10000

        @punksOfferedForSale[punkIndex] = Offer.new( isForSale: true, 
                                                     punkIndex: punkIndex, 
                                                     seller: msg.sender, 
                                                     minValue: minSalePriceInWei, 
                                                     onlySellTo: toAddress)
        log PunkOffered, punkIndex: punkIndex, 
                         minValue: minSalePriceInWei, 
                         toAddress: toAddress
    end

    sig [UInt]   # payable
    def buyPunk( punkIndex: )  
        assert  @allPunksAssigned
        offer = @punksOfferedForSale[punkIndex]
        assert  punkIndex < 10000
        assert  offer.isForSale, "punk not actually for sale"
        assert  offer.onlySellTo == assert(0) || offer.onlySellTo == msg.sender, "punk not supposed to be sold to this user"
        assert  msg.value >= offer.minValue, "Didn't send enough ETH"
        assert  offer.seller == @punkIndexToAddress[punkIndex], "Seller no longer owner of punk"

        seller = offer.seller

        @punkIndexToAddress[punkIndex] = msg.sender
        @balanceOf[ seller] -= 1
        @balanceOf[ msg.sender ] += 1
        log Transfer, from: seller, to: msg.sender, value: 1

        punkNoLongerForSale(punkIndex)
        @pendingWithdrawals[seller] += msg.value
        log PunkBought, punkIndex: punkIndex, value: msg.value, 
                        fromAddress: seller, 
                        toAddress: msg.sender

        # Check for the case where there is a bid from the new owner and refund it.
        # Any other bid can stay in place.
        bid = @punkBids[punkIndex]
        if bid.bidder == msg.sender
            # Kill bid and refund value
            @pendingWithdrawals[msg.sender] += bid.value
            @punkBids[punkIndex] = Bid.new( hasBid:    false, 
                                            punkIndex: punkIndex, 
                                            bidder: address(0), 
                                            value: 0)
        end
    end

    sig []
    def withdraw
        assert @allPunksAssigned
        amount = @pendingWithdrawals[msg.sender]
        # Remember to zero the pending refund before
        # sending to prevent re-entrancy attacks
        @pendingWithdrawals[msg.sender] = 0
        msg.sender.transfer(amount)
    end

    sig [UInt]  # payable
    def enterBidForPunk( punkIndex: )  
        assert punkIndex < 10000
        assert allPunksAssigned
        assert @punkIndexToAddress[punkIndex] != address(0) 
        assert @punkIndexToAddress[punkIndex] != msg.sender
        assert msg.value > 0

        existing = @punkBids[punkIndex]
        assert  msg.value > existing.value
        if existing.value > 0
            # Refund the failing bid
            @pendingWithdrawals[existing.bidder] += existing.value
        end
        @punkBids[punkIndex] = Bid.new( hasBid: true, 
                                        punkIndex: punkIndex, 
                                        bidder: msg.sender, 
                                        value: msg.value )
        log PunkBidEntered, punkIndex: punkIndex, value: msg.value, fromAddress: msg.sender
    end

    sig [UInt, UInt]
    def acceptBidForPunk( punkIndex:, minPrice: ) 
        assert punkIndex < 10000
        assert allPunksAssigned
        assert @punkIndexToAddress[punkIndex] == msg.sender
        seller = msg.sender
        bid = @punkBids[punkIndex]
        assert bid.value > 0
        assert bid.value >= minPrice

        @punkIndexToAddress[punkIndex] = bid.bidder
        @balanceOf[seller] -= 1
        @balanceOf[bid.bidder] += 1
        log Transfer, from: seller, to: bid.bidder, value: 1

        @punksOfferedForSale[punkIndex] = Offer.new( isForSale: false, 
                                                     punkIndex: punkIndex, 
                                                     seller: bid.bidder, 
                                                     minValue: 0, 
                                                     onlySellTo: address(0))
        amount = bid.value
        @punkBids[punkIndex] = Bid.new( hasBid: false, 
                                        punkIndex: punkIndex, 
                                        bidder: address(0), 
                                        value: 0)
        @pendingWithdrawals[seller] += amount
        log PunkBought, punkIndex: punkIndex, value: bid.value, 
                        fromAddress: seller, toAddress: bid.bidder
    end

    sig [UInt]
    def withdrawBidForPunk( punkIndex: ) 
        assert punkIndex < 10000
        assert @allPunksAssigned
        assert @punkIndexToAddress[punkIndex] != address(0)
        assert @punkIndexToAddress[punkIndex] != msg.sender
        bid = @punkBids[punkIndex]
        assert bid.bidder == msg.sender
        log PunkBidWithdrawn, punkIndex: punkIndex, value: bid.value, fromAddress: msg.sender
        amount = bid.value
        @punkBids[punkIndex] = Bid.new( hasBid: false, 
                                        punkIndex: punkIndex, 
                                        bidder: address(0), 
                                        value: 0)
        # Refund the bid money
        msg.sender.transfer(amount)
    end
end

