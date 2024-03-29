
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
