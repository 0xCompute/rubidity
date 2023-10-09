# pragma: rubidity 0.0.1

# @title CrowdFunder
# @author geraldb
class CrowdFunder < Contract  
    #  Variables set on create by creator
    storage creator: Address,
            fundRecipient: Address, # payable - creator may be different than recipient, and must be payable
            minimumToRaise: UInt, # required to tip, else everyone gets refund
            campaignUrl: String
    
    # Data structures
    enum :State, :fundraising,
                 :expiredRefund,
                 :successful
    
    struct :Contribution, amount:       UInt,
                          contributor:  Address    # payable
    
    # State variables
    storage  state:         State,        # // initialize on create   
             totalRaised:   UInt,
             raiseBy:       Timestamp,
             completeAt:    Timestamp,
             contributions: array(Contribution)

    event :LogFundingReceived, addr: Address, 
                               amount: UInt, 
                               currentTotal: UInt
    event :LogWinnerPaid, winnerAddress: Address


    sig [UInt, String, Address, UInt] 
    def crowdFund(
        timeInHoursForFundraising:,
        campaignUrl:,
        fundRecipient:,     # payable
        minimumToRaise: )

        @creator = msg.sender
        @fundRecipient = fundRecipient
        @campaignUrl = campaignUrl
        @minimumToRaise = minimumToRaise
        @raiseBy = now + (timeInHoursForFundraising * 1.hours)
    end

    sig [], :payable, returns: [UInt]
    def contribute
      assert @state == State.fundraising
   
      @contributions.push(
            Contribution.new(
                amount: msg.value,
                contributor: msg.sender
            ) # use array, so can iterate
       ) 
        
      @totalRaised += msg.value

      log LogFundingReceived, msg.sender, msg.value, totalRaised

      checkIfFundingCompleteOrExpired()
      @contributions.length - 1  #  return id
    end

    def checkIfFundingCompleteOrExpired
        if @totalRaised > @minimumToRaise
            state = State.successful
            payOut()

            # could incentivize sender who initiated state change here
        elsif now > @raiseBy
            state = State.expiredRefund  # backers can now collect refunds by calling getRefund(id)
        end
        @completeAt = now
    end

    def payOut
      assert @state == State.successful
    
      @fundRecipient.transfer( address(this).balance )
      log LogWinnerPaid, fundRecipient
    end

    sig [UInt], returns: Bool
    def getRefund( id: )
      assert @state == State.expiredRefund
      assert @contributions.length > id && id >= 0
      assert @contributions[id].amount != 0

      amountToRefund = @contributions[id].amount
      @contributions[id].amount = 0

      @contributions[id].contributor.transfer(amountToRefund)

      true
    end

    sig []
    def removeContract
       assert msg.sender == @creator
  
       # Wait 24 weeks after final contract state before allowing contract destruction
       assert state == State.expiredRefund || state == State.successful
       assert  @completeAt + 24.weeks < now
      
       selfdestruct(msg.sender)
        # creator gets all money that hasn't be claimed
    end
end
