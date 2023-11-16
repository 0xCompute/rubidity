# Rubysol - Crowd Fund

Crowd fund ERC20 token

1. User creates a campaign.
2. Users can pledge, transferring their token to a campaign.
3. After the campaign ends, campaign creator can claim the funds if total amount pledged is more than the campaign goal.
4. Otherwise, campaign did not reach it's goal, users can withdraw their pledge.


<details>
<summary markdown="1">Solidity - English Auction</summary>

``` solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address, uint) external returns (bool);

    function transferFrom(address, address, uint) external returns (bool);
}

contract CrowdFund {
    event Launch(
        uint id,
        address indexed creator,
        uint goal,
        uint32 startAt,
        uint32 endAt
    );
    event Cancel(uint id);
    event Pledge(uint indexed id, address indexed caller, uint amount);
    event Unpledge(uint indexed id, address indexed caller, uint amount);
    event Claim(uint id);
    event Refund(uint id, address indexed caller, uint amount);

    struct Campaign {
        // Creator of campaign
        address creator;
        // Amount of tokens to raise
        uint goal;
        // Total amount pledged
        uint pledged;
        // Timestamp of start of campaign
        uint32 startAt;
        // Timestamp of end of campaign
        uint32 endAt;
        // True if goal was reached and creator has claimed the tokens.
        bool claimed;
    }

    IERC20 public immutable token;
    // Total count of campaigns created.
    // It is also used to generate id for new campaigns.
    uint public count;
    // Mapping from id to Campaign
    mapping(uint => Campaign) public campaigns;
    // Mapping from campaign id => pledger => amount pledged
    mapping(uint => mapping(address => uint)) public pledgedAmount;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function launch(uint _goal, uint32 _startAt, uint32 _endAt) external {
        require(_startAt >= block.timestamp, "start at < now");
        require(_endAt >= _startAt, "end at < start at");
        require(_endAt <= block.timestamp + 90 days, "end at > max duration");

        count += 1;
        campaigns[count] = Campaign({
            creator: msg.sender,
            goal: _goal,
            pledged: 0,
            startAt: _startAt,
            endAt: _endAt,
            claimed: false
        });

        emit Launch(count, msg.sender, _goal, _startAt, _endAt);
    }

    function cancel(uint _id) external {
        Campaign memory campaign = campaigns[_id];
        require(campaign.creator == msg.sender, "not creator");
        require(block.timestamp < campaign.startAt, "started");

        delete campaigns[_id];
        emit Cancel(_id);
    }

    function pledge(uint _id, uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp >= campaign.startAt, "not started");
        require(block.timestamp <= campaign.endAt, "ended");

        campaign.pledged += _amount;
        pledgedAmount[_id][msg.sender] += _amount;
        token.transferFrom(msg.sender, address(this), _amount);

        emit Pledge(_id, msg.sender, _amount);
    }

    function unpledge(uint _id, uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp <= campaign.endAt, "ended");

        campaign.pledged -= _amount;
        pledgedAmount[_id][msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);

        emit Unpledge(_id, msg.sender, _amount);
    }

    function claim(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        require(campaign.creator == msg.sender, "not creator");
        require(block.timestamp > campaign.endAt, "not ended");
        require(campaign.pledged >= campaign.goal, "pledged < goal");
        require(!campaign.claimed, "claimed");

        campaign.claimed = true;
        token.transfer(campaign.creator, campaign.pledged);

        emit Claim(_id);
    }

    function refund(uint _id) external {
        Campaign memory campaign = campaigns[_id];
        require(block.timestamp > campaign.endAt, "not ended");
        require(campaign.pledged < campaign.goal, "pledged >= goal");

        uint bal = pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender] = 0;
        token.transfer(msg.sender, bal);

        emit Refund(_id, msg.sender, bal);
    }
}
```

</details>


``` ruby
# SPDX-License-Identifier: public domain


class CrowdFund < Contract 
    event :Launch,  id:      UInt,
                    creator: Address,  # indexed 
                    goal:    UInt,
                    startAt: Timestamp,  
                    endAt:   Timestamp    
    event :Cancel,  id: UInt
    event :Pledge,  id:     UInt,    # indexed, 
                    caller: Address, # indexed 
                    amount: UInt
    event :Unpledge, id:     UInt,    # indexed 
                     caller: Address, # indexed 
                     amount: UInt 
    event :Claim,  id: UInt
    event :Refund, id: UInt, 
                   caller: Address, # indexed 
                   amount: UInt

    struct :Campaign, creator: Address,    # Creator of campaign
                      goal:    UInt,       # Amount of tokens to raise
                      pledged: UInt,       # Total amount pledged
                      startAt: Timestamp,  # Timestamp of start of campaign
                      endAt:   Timestamp,  # Timestamp of end of campaign
                      claimed: Bool        # True if goal was reached and creator has claimed the tokens

    storage token:         Address,     # IERC20 immutable
            count:         UInt,        # Total count of campaigns created. It is also used to generate id for new campaigns.
            campaigns:     Mapping( UInt, Campaign ), # Mapping from id to Campaign
            pledgedAmount: Mapping( UInt, Mapping( Address, UInt )) # Mapping from campaign id => pledger => amount pledged
    

    sig [Address]
    def constructor( token: ) 
        @token = token
    end

    sig [UInt, Timestamp, Timestamp]
    def launch( goal:, startAt:, endAt: )
        assert startAt >= block.timestamp, "start at < now"
        assert endAt >= startAt, "end at < start at"
        assert endAt <= block.timestamp + 90.days, "end at > max duration"

        @count += 1;
        @campaigns[@count] = Campaign.new(
            creator: msg.sender,
            goal: goal,
            pledged: 0,
            startAt: startAt,
            endAt: endAt,
            claimed: false
        )

        log Launch, @count, msg.sender, goal, startAt, endAt
    end

    sig [UInt]
    def cancel( id: )
        campaign = @campaigns[ id ]
        assert campaign.creator == msg.sender, "not creator"
        assert block.timestamp < campaign.startAt, "started"

        campaigns.delete( id )
        log Cancel, id
    end

    sig [UInt, UInt]  
    def pledge( id:, amount: ) 
        campaign = @campaigns[ id ]
        assert block.timestamp >= campaign.startAt, "not started"
        assert block.timestamp <= campaign.endAt, "ended"

        campaign.pledged += amount
        @pledgedAmount[id][msg.sender] += amount
        IERC20(@token).transferFrom( msg.sender, address(this), amount)

        log Pledge, id, msg.sender, amount
    end

    sig [UInt, UInt]
    def unpledge( id:, amount: )
        campaign = @campaigns[ id] 
        assert block.timestamp <= campaign.endAt, "ended"

        campaign.pledged -= amount
        @pledgedAmount[id][msg.sender] -= amount
        IERC20(@token).transfer( msg.sender, amount )

        log Unpledge, id, msg.sender, amount
    end

    sig [UInt]
    def claim( id: ) 
        campaign = @campaigns[ id ]
        assert campaign.creator == msg.sender, "not creator"
        assert block.timestamp > campaign.endAt, "not ended"
        assert campaign.pledged >= campaign.goal, "pledged < goal"
        assert !campaign.claimed, "claimed"

        campaign.claimed = true;
        IERC20(token).transfer( campaign.creator, campaign.pledged )

        log Claim, id
    end

    sig [UInt]
    def refund( id: ) 
        campaign = @campaigns[ id ]
        assert block.timestamp > campaign.endAt, "not ended"
        assert campaign.pledged < campaign.goal, "pledged >= goal"

        bal = @pledgedAmount[id][msg.sender]
        @pledgedAmount[id][msg.sender] = 0
        IERC20(token).transfer( msg.sender, bal )

        log Refund, id, msg.sender, bal
    end
end
```


