pragma solidity ^0.6.6;

/// @title CrowdFunder
/// @author nemild
contract CrowdFunder {
    // Variables set on create by creator
    address public creator;
    address payable public fundRecipient; // creator may be different than recipient, and must be payable
    uint public minimumToRaise; // required to tip, else everyone gets refund
    string campaignUrl;
    byte version = "1";

    // Data structures
    enum State {
        Fundraising,
        ExpiredRefund,
        Successful
    }
    struct Contribution {
        uint amount;
        address payable contributor;
    }

    // State variables
    State public state = State.Fundraising; // initialize on create
    uint public totalRaised;
    uint public raiseBy;
    uint public completeAt;
    Contribution[] contributions;

    event LogFundingReceived(address addr, uint amount, uint currentTotal);
    event LogWinnerPaid(address winnerAddress);

    modifier inState(State _state) {
        require(state == _state);
        _;
    }

    modifier isCreator() {
        require(msg.sender == creator);
        _;
    }

    // Wait 24 weeks after final contract state before allowing contract destruction
    modifier atEndOfLifecycle() {
    require(((state == State.ExpiredRefund || state == State.Successful) &&
        completeAt + 24 weeks < now));
        _;
    }

    function crowdFund(
        uint timeInHoursForFundraising,
        string memory _campaignUrl,
        address payable _fundRecipient,
        uint _minimumToRaise)
        public
    {
        creator = msg.sender;
        fundRecipient = _fundRecipient;
        campaignUrl = _campaignUrl;
        minimumToRaise = _minimumToRaise;
        raiseBy = now + (timeInHoursForFundraising * 1 hours);
    }

    function contribute()
    public
    payable
    inState(State.Fundraising)
    returns(uint256 id)
    {
        contributions.push(
            Contribution({
                amount: msg.value,
                contributor: msg.sender
            }) // use array, so can iterate
        );
        totalRaised += msg.value;

        emit LogFundingReceived(msg.sender, msg.value, totalRaised);

        checkIfFundingCompleteOrExpired();
        return contributions.length - 1; // return id
    }

    function checkIfFundingCompleteOrExpired()
    public
    {
        if (totalRaised > minimumToRaise) {
            state = State.Successful;
            payOut();

            // could incentivize sender who initiated state change here
        } else if ( now > raiseBy )  {
            state = State.ExpiredRefund; // backers can now collect refunds by calling getRefund(id)
        }
        completeAt = now;
    }

    function payOut()
    public
    inState(State.Successful)
    {
        fundRecipient.transfer(address(this).balance);
        LogWinnerPaid(fundRecipient);
    }

    function getRefund(uint256 id)
    inState(State.ExpiredRefund)
    public
    returns(bool)
    {
        require(contributions.length > id && id >= 0 && contributions[id].amount != 0 );

        uint256 amountToRefund = contributions[id].amount;
        contributions[id].amount = 0;

        contributions[id].contributor.transfer(amountToRefund);

        return true;
    }

    function removeContract()
    public
    isCreator()
    atEndOfLifecycle()
    {
        selfdestruct(msg.sender);
        // creator gets all money that hasn't be claimed
    }
}