
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
             punkIndex:  UInt,    # indexed

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
            numberOfPunksReserved:  UInt;
            punkIndexToAddress:   mapping( UInt, Address ),
            balanceOf: mapping( Address, UInt ),   # This creates an array with all balances 
            punksOfferedForSale: mapping( UInt, Offer ),  # A record of punks that are offered for sale at a specific minimum value, and perhaps to a specific person
            pendingWithdrawals: mapping( Address, UInt )


    # Initializes contract with initial supply tokens to the creator of the contract */
    sig []
    def constructor    # payable 
        @owner = msg.sender
        @totalSupply = 10000    # Update total supply
        @punksRemainingToAssign = @totalSupply;
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
            log Assign, to: msg.sender, 
                        punkIndex: @nextPunkIndexToAssign
            numberPunksReservedThisRun +=1
            @nextPunkIndexToAssign += 1
        end
        @punksRemainingToAssign -= numberPunksReservedThisRun
        @numberOfPunksReserved += numberPunksReservedThisRun
        @balanceOf[msg.sender] += numberPunksReservedThisRun
    end
end


## to be done / continued ...

__END__

    function getPunk(uint punkIndex) {
        if (punksRemainingToAssign == 0) throw;
        if (punkIndexToAddress[punkIndex] != 0x0) throw;
        punkIndexToAddress[punkIndex] = msg.sender;
        balanceOf[msg.sender]++;
        punksRemainingToAssign--;
        Assign(msg.sender, punkIndex);
    }

    // Transfer ownership of a punk to another user without requiring payment
    function transferPunk(address to, uint punkIndex) {
        if (punkIndexToAddress[punkIndex] != msg.sender) throw;
        punkIndexToAddress[punkIndex] = to;
        balanceOf[msg.sender]--;
        balanceOf[to]++;
        Transfer(msg.sender, to, 1);
        PunkTransfer(msg.sender, to, punkIndex);
    }

    function punkNoLongerForSale(uint punkIndex) {
        if (punkIndexToAddress[punkIndex] != msg.sender) throw;
        punksOfferedForSale[punkIndex] = Offer(false, punkIndex, msg.sender, 0, 0x0);
        PunkNoLongerForSale(punkIndex);
    }

    function offerPunkForSale(uint punkIndex, uint minSalePriceInWei) {
        if (punkIndexToAddress[punkIndex] != msg.sender) throw;
        punksOfferedForSale[punkIndex] = Offer(true, punkIndex, msg.sender, minSalePriceInWei, 0x0);
        PunkOffered(punkIndex, minSalePriceInWei, 0x0);
    }

    function offerPunkForSaleToAddress(uint punkIndex, uint minSalePriceInWei, address toAddress) {
        if (punkIndexToAddress[punkIndex] != msg.sender) throw;
        punksOfferedForSale[punkIndex] = Offer(true, punkIndex, msg.sender, minSalePriceInWei, toAddress);
        PunkOffered(punkIndex, minSalePriceInWei, toAddress);
    }

    function buyPunk(uint punkIndex) payable {
        Offer offer = punksOfferedForSale[punkIndex];
        if (!offer.isForSale) throw;                // punk not actually for sale
        if (offer.onlySellTo != 0x0 && offer.onlySellTo != msg.sender) throw;  // punk not supposed to be sold to this user
        if (msg.value < offer.minValue) throw;      // Didn't send enough ETH
        if (offer.seller != punkIndexToAddress[punkIndex]) throw; // Seller no longer owner of punk

        punkIndexToAddress[punkIndex] = msg.sender;
        balanceOf[offer.seller]--;
        balanceOf[msg.sender]++;
        Transfer(offer.seller, msg.sender, 1);

        punkNoLongerForSale(punkIndex);
        pendingWithdrawals[offer.seller] += msg.value;
        PunkBought(punkIndex, msg.value, offer.seller, msg.sender);
    }

    function withdraw() {
        uint amount = pendingWithdrawals[msg.sender];
        // Remember to zero the pending refund before
        // sending to prevent re-entrancy attacks
        pendingWithdrawals[msg.sender] = 0;
        msg.sender.transfer(amount);
    }
