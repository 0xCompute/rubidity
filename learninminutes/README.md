# Learn X in Y Minutes (Where X=Rubidity, Y=?)

Inspired by [Learn X In Y Minutes - Where X=Solidity](https://learnxinyminutes.com/docs/solidity/) [(Source)](https://github.com/adambard/learnxinyminutes-docs/blob/master/solidity.html.markdown) - a reworked edition / version for Rubidity et al.



First, a simple Bank contract. Allows deposits, withdrawals, and balance checks


[simple_bank.rb](simple_bank.rb) (note .rb extension)

``` ruby
# Declare the source file language version
# pragma: rubidity 0.0.1

# Start with Natspec comment 
# used for documentation - and as descriptive data for UI elements/actions

# @title SimpleBank
# @author geraldb

# 'contract' has similarities to 'class' in other languages
# (class variables, inheritance, etc.) 

class SimpleBank < Contract     #  CapWords
    # Declare state (storage) variables outside function, persist through life of contract

    # dictionary that maps addresses to balances
    #  always be careful about overflow attacks with numbers
    
    storage _balance: mapping( Address, UInt )
    # 'private'  (by using (leading) underscore naming convention) 
    # means that other contracts 
    # can't directly query balances
    # but data is still viewable to other parties on blockchain

    storage owner: Address    
    # 'public'  (by default) makes externally 
    #   readable (not writeable) by users or contracts

    # Events - publicize actions to external listeners
    event :LogDepositMade accountAddress: Address, 
                          amount: UInt

    # Constructor, can receive one or many variables here; only one allowed
    sig []
    def constructor
        # msg provides details about the message that's sent to the contract
        # msg.sender is contract caller (address of contract creator)
        @owner = msg.sender
    end

    #  @notice Deposit ether into bank
    #  @return The balance of the user after the deposit is made
    sig [], :payable, returns: UInt
    def deposit
        #  Use 'assert' to test user inputs, 'assert' for internal invariants
        #  Here we are making sure that there isn't an overflow issue
        assert @balances[msg.sender] + msg.value >= @balances[msg.sender]

        @balances[msg.sender] += msg.value
        
        # no "this." or "self." required with state variable (use @)
        # all values set to data type's initial (zero) value by default

        log LogDepositMade,  msg.sender, msg.value   # fire event

        @balances[msg.sender]
    end

    #  @notice Withdraw ether from bank
    #  @dev This does not return any excess ether sent to it
    #  @param withdrawAmount amount you want to withdraw
    #  @return remainingBal
    sig [UInt], returns: [UInt]
    def withdraw( withdrawAmount: ) 
        assert withdrawAmount <= @balances[msg.sender]

        # Note the way we deduct the balance right away, before sending
        # Every .transfer/.send from this contract can call an external function
        # This may allow the caller to request an amount greater
        # than their balance using a recursive call
        # Aim to commit state before calling external functions, including .transfer/.send
        @balances[msg.sender] -= withdrawAmount

        # this automatically throws on a failure, which means the updated balance is reverted
        msg.sender.transfer(withdrawAmount)

        @balances[msg.sender]
    end


    # @notice Get balance
    # @return The balance of the user
    #'view' (ex: constant) prevents function from editing state variables;
    #  allows function to run locally/off blockchain
    sig [], :view, returns: UInt
    def balance
      @balances[msg.sender]
    end
end
```


To be continued ...





A crowdfunding example (broadly similar to Kickstarter).

[crowdfunder.rb](crowdfunder.rb) (note .rb extension)


``` ruby
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
```





## Questions? Comments?

Join us in the [Rubidity (community) discord (chat server)](https://discord.gg/3JRnDUap6y). Yes you can.
Your questions and commentary welcome.

Or post them over at the [Help & Support](https://github.com/geraldb/help) page. Thanks.

