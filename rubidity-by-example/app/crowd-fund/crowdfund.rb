# SPDX-License-Identifier: public domain
# pragma: rubidity 0.0.1


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
            campaigns:     mapping( UInt, Campaign ), # Mapping from id to Campaign
            pledgedAmount: mapping( UInt, mapping( Address, UInt )) # Mapping from campaign id => pledger => amount pledged
    

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



__END__


interface IERC20 {
    function transfer(address, uint) external returns (bool);

    function transferFrom(address, address, uint) external returns (bool);
}
