# Rubidity - English Auction


English auction for NFT.

Auction

1. Seller of NFT deploys this contract.
2. Auction lasts for 7 days.
3. Participants can bid by depositing ETH greater than the current highest bidder.
4. All bidders can withdraw their bid if it is not the current highest bid.

After the auction

1. Highest bidder becomes the new owner of NFT.
2. The seller receives the highest bid of ETH.


<details>
<summary markdown="1">Solidity - English Auction</summary>

``` solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC721 {
    function safeTransferFrom(address from, address to, uint tokenId) external;

    function transferFrom(address, address, uint) external;
}

contract EnglishAuction {
    event Start();
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event End(address winner, uint amount);

    IERC721 public nft;
    uint public nftId;

    address payable public seller;
    uint public endAt;
    bool public started;
    bool public ended;

    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) public bids;

    constructor(address _nft, uint _nftId, uint _startingBid) {
        nft = IERC721(_nft);
        nftId = _nftId;

        seller = payable(msg.sender);
        highestBid = _startingBid;
    }

    function start() external {
        require(!started, "started");
        require(msg.sender == seller, "not seller");

        nft.transferFrom(msg.sender, address(this), nftId);
        started = true;
        endAt = block.timestamp + 7 days;

        emit Start();
    }

    function bid() external payable {
        require(started, "not started");
        require(block.timestamp < endAt, "ended");
        require(msg.value > highestBid, "value < highest");

        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        emit Bid(msg.sender, msg.value);
    }

    function withdraw() external {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);

        emit Withdraw(msg.sender, bal);
    }

    function end() external {
        require(started, "not started");
        require(block.timestamp >= endAt, "not ended");
        require(!ended, "ended");

        ended = true;
        if (highestBidder != address(0)) {
            nft.safeTransferFrom(address(this), highestBidder, nftId);
            seller.transfer(highestBid);
        } else {
            nft.safeTransferFrom(address(this), seller, nftId);
        }

        emit End(highestBidder, highestBid);
    }
}
```

</details>


``` ruby
#  SPDX-License-Identifier: public domain
# pragma rubity 0.0.1


class EnglishAuction < Contract  
    event :Start
    event :Bid,      sender: Address, # indexed 
                     amount: UInt
    event :Withdraw, bidder: Address, # indexed 
                     amount: UInt
    event :End,      winner: Address, 
                     amount: UInt 

    storage  nft:        Address,   # IERC721 
             nftId:      UInt,
             seller:     Payable,   
             endAt:      UInt,
             started:    Bool,  
             ended:      Bool,
             highestBidder: Address,
             highestBid:    UInt,
             bids:     Mapping( Address, UInt )

    sig [Address, UInt, UInt]   
    def constructor( nft:, nftId:, startingBid: ) 
        @nft        = nft
        @nftId      = nftId
        @seller     = payable( msg.sender )
        @highestBid = startingBid
    end

    sig []
    def start
        assert  !@started, "started"
        assert  msg.sender == @seller, "not seller"

        IERC721(@nft).transferFrom( msg.sender, address(this), @nftId )
        @started = true
        @endAt = block.timestamp + 7.days

        log Start
    end

    sig []  
    def bid
        assert @started, "not started"
        assert block.timestamp < @endAt, "ended"
        assert msg.value > @highestBid, "value < highest"

        if @highestBidder != address(0)
            @bids[@highestBidder] += @highestBid;
        end

        @highestBidder = msg.sender;
        @highestBid = msg.value;

        log Bid, msg.sender, msg.value
    end

    sig []
    def withdraw
        bal = @bids[msg.sender]
        @bids[msg.sender] = 0
        payable(msg.sender).transfer(bal)

        log Withdraw, msg.sender, bal
    end

    sig []
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

        log End, @highestBidder, @highestBid
    end
end
```

