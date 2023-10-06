#  SPDX-License-Identifier: public domain
# pragma rubity 0.0.1


class EnglishAuction < Contract  
    event :Start
    event :Bid,      sender: Address, # +indexed 
                     amount: UInt
    event :Withdraw, bidder: Address, # +indexed 
                     amount: UInt
    event :End,      winner: Address, 
                     amount: UInt 

    storage  nft:        Address,   # IERC721 
             nftId:      UInt,
             seller:     Address,   # +payable
             endAt:      UInt,
             started:    Bool,  
             ended:      Bool,
             highestBidder: Address,
             highestBid:    UInt,
             bids:     mapping( Address, UInt )

    sig :constructor, [Address, UInt, UInt]   
    def constructor( nft:, nftId:, startingBid: ) 
        @nft        = nft
        @nftId      = nftId
        @seller     = msg.sender       # payable(msg.sender)
        @highestBid = startingBid
    end

    sig :start, []
    def start
        assert  !@started, "started"
        assert  msg.sender == @seller, "not seller"

        IERC721(@nft).transferFrom( msg.sender, address(this), @nftId )
        @started = true
        @endAt = block.timestamp + 7.days

        log :Start
    end

    sig :bid, [], :payable 
    def bid
        assert @started, "not started"
        assert block.timestamp < @endAt, "ended"
        assert msg.value > @highestBid, "value < highest"

        if @highestBidder != address(0)
            @bids[@highestBidder] += @highestBid;
        end

        @highestBidder = msg.sender;
        @highestBid = msg.value;

        log :Bid, msg.sender, msg.value
    end

    sig :withdraw, []
    def withdraw
        bal = @bids[msg.sender]
        @bids[msg.sender] = 0
        address(msg.sender).transfer(bal)   # payable(msg.sender)

        log :Withdraw, msg.sender, bal
    end

    sig :end, []
    def end
        assert @started, "not started"
        assert block.timestamp >= @endAt, "not ended"
        assert !@ended, "ended"

        @ended = true
        if @highestBidder != address(0)
            IERC721(@nft).safeTransferFrom( address(this), @highestBidder, @nftId )
            seller.transfer( @highestBid )
        else 
            IERC721(@nft).safeTransferFrom( address(this), @seller, @nftId )
        end

        log :End, @highestBidder, @highestBid
    end
end




__END__


interface IERC721 {
    function safeTransferFrom(address from, address to, uint tokenId) external;

    function transferFrom(address, address, uint) external;
}
