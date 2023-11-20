
class Punks < Contract  

    # You can use this hash to verify the image file containing 
    #   all the punks
    IMAGE_HASH = "0xac39af4793119ee46bbff351d8cb6b5f23da60222126add4268e261199a2921b";
 
    event :Assign,
             to:        Address,  # indexed 
             punkIndex: UInt 
    event :Transfer,
             from:      Address,  # indexed 
             to:        Address,  # indexed
             value:     UInt
    event :PunkTransfer,
             from:      Address,  # indexed 
             to:        Address,  # indexed 
             punkIndex: UInt
    event :PunkOffered,
             punkIndex: UInt,    # indexed 
             minValue:  UInt,
             toAddress: Address  # indexed 
    event :PunkBought,
             punkIndex:   UInt,    # indexed 
             value:       UInt,    
             fromAddress: Address, # indexed 
             toAddress:   Address  # indexed
    event :PunkNoLongerForSale,
             punkIndex:  UInt    # indexed

    struct :Offer, 
        isForSale:  Bool,
        punkIndex:  UInt,
        seller:     Address,
        minValue:   UInt,      # in ether
        onlySellTo: Address    # specify to sell only to a specific person

    storage owner:       Address,
            name:        String,
            symbol:      String,
            decimals:    UInt,
            totalSupply: UInt,
            nextPunkIndexToAssign: UInt, 
            punksRemainingToAssign: UInt,
            numberOfPunksToReserve: UInt,
            numberOfPunksReserved:  UInt,
            punkIndexToAddress:   mapping( UInt, Address ),
            balanceOf: mapping( Address, UInt ),   # This creates an array with all balances 
            punksOfferedForSale: mapping( UInt, Offer ),  # A record of punks that are offered for sale at a specific minimum value, and perhaps to a specific person
            pendingWithdrawals: mapping( Address, UInt )


    # Initializes contract with initial supply tokens to the creator of the contract */
    sig []
    def constructor    # payable 
        @owner = msg.sender
        @totalSupply = 10000    # Update total supply
        @punksRemainingToAssign = @totalSupply
        @numberOfPunksToReserve = 1000
        @name = "PUNKS"  # Set the name for display purposes
        @symbol = "P"   # Set the symbol for display purposes
        @decimals = 0   #  Amount of decimals for display purposes
    end

    sig [UInt]
    def reservePunksForOwner( maxForThisRun: ) 
        assert msg.sender == @owner
        assert @numberOfPunksReserved < @numberOfPunksToReserve

        numberPunksReservedThisRun = 0
        while @numberOfPunksReserved < @numberOfPunksToReserve && numberPunksReservedThisRun < maxForThisRun
            @punkIndexToAddress[ @nextPunkIndexToAssign ] = msg.sender
            log Assign, to: msg.sender, punkIndex: @nextPunkIndexToAssign
            numberPunksReservedThisRun +=1
            @nextPunkIndexToAssign += 1
        end
        @punksRemainingToAssign -= numberPunksReservedThisRun
        @numberOfPunksReserved += numberPunksReservedThisRun
        @balanceOf[msg.sender] += numberPunksReservedThisRun
    end

    sig [UInt]
    def getPunk( punkIndex: ) 
        assert @punksRemainingToAssign > 0
        assert @punkIndexToAddress[punkIndex] == address(0)

        @punkIndexToAddress[punkIndex] = msg.sender
        @balanceOf[msg.sender] += 1
        @punksRemainingToAssign -= 1
        log Assign, to: msg.sender, punkIndex: punkIndex
    end

    # Transfer ownership of a punk to another user without requiring payment
    sig [Address, UInt]
    def transferPunk( to:, punkIndex: ) 
        assert @punkIndexToAddress[punkIndex] == msg.sender
        @punkIndexToAddress[punkIndex] = to
        @balanceOf[msg.sender] -= 1
        @balanceOf[to] += 1
        log Transfer, from: msg.sender, to: to, value: 1
        log PunkTransfer, from: msg.sender, to: to, punkIndex: punkIndex
    end

    sig [UInt]
    def punkNoLongerForSale( punkIndex: ) 
        assert @punkIndexToAddress[punkIndex] == msg.sender
        @punksOfferedForSale[punkIndex] = Offer.new( 
                                            isForSale:  false,
                                            punkIndex:  punnkIndex,
                                            seller:     msg.sender,
                                            minValue:   0,      
                                            onlySellTo: address(0))
        log PunkNoLongerForSale, punkIndex: punkIndex
    end

    sig [UInt, UInt]
    def offerPunkForSale( punkIndex:, minSalePriceInWei: ) 
        assert @punkIndexToAddress[punkIndex] == msg.sender
        @punksOfferedForSale[punkIndex] = Offer.new(
                                           isForSale: true, 
                                           punkIndex: punkIndex, 
                                           seller: msg.sender, 
                                           minValue: minSalePriceInWei, 
                                           onlySellTo: address(0))
        log PunkOffered, punkIndex: punkIndex, minValue: minSalePriceInWei,
                         toAddress: address(0)
    end

    sig [UInt, UInt, Address]
    def offerPunkForSaleToAddress( punkIndex:, minSalePriceInWei:, toAddress: ) 
        assert @punkIndexToAddress[punkIndex] == msg.sender
        @punksOfferedForSale[punkIndex] = Offer.new(
                                            isForSale: true, 
                                            punkIndex: punkIndex, 
                                            seller: msg.sender, 
                                            minValue: minSalePriceInWei, 
                                            onlySellTo: toAddress)
        log PunkOffered, punkIndex: punkIndex, minValue: minSalePriceInWei, 
                         toAddress: toAddress
    end

    sig [UInt]
    def buyPunk( punkIndex: )  # payable 
        offer = @punksOfferedForSale[ punkIndex ]
        assert offer.isForSale, "punk not actually for sale"
        assert offer.onlySellTo == address(0) || offer.onlySellTo == msg.sender, "punk not supposed to be sold to this user"
        assert msg.value >= offer.minValue, "Didn't send enough ETH"
        assert offer.seller == @punkIndexToAddress[punkIndex], "Seller no longer owner of punk"

        @punkIndexToAddress[punkIndex] = msg.sender
        @balanceOf[offer.seller] -= 1
        @balanceOf[msg.sender] += 1
        log Transfer, from: offer.seller, to: msg.sender, value: 1

        punkNoLongerForSale( punkIndex )
        @pendingWithdrawals[offer.seller] += msg.value
        log PunkBought, punkIndex: punkIndex, value: msg.value, 
                        fromAddress: offer.seller, 
                        toAddress: msg.sender
    end

    sig []
    def withdraw
       amount = @pendingWithdrawals[msg.sender]
        # Remember to zero the pending refund before
        # sending to prevent re-entrancy attacks
        @pendingWithdrawals[ msg.sender ] = 0
        msg.sender.transfer(amount)
    end
end