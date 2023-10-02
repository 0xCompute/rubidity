####
# Kick Start Your Project with a Crowd Funder


class CrowdFunder < Contract

event :FundingReceived, address: Address, 
                        amount: UInt, 
                        current_total: UInt
event :WinnerPaid, winner_address: Address


enum :State, :fundraising, :expired_refund, :successful

struct :Contribution,
         amount:      UInt, 
         contributor: Address

storage   creator:          Address,
          fund_recipient:   Address,
          campaign_url:     String,
          minimum_to_raise: UInt,
          raise_by:         Timestamp,
          state:            State,
          total_raised:     UInt,
          complete_at:      Timestamp,
          contributions:    Array( Contribution ) 

sig :constructor[Timedelta, String, Address, UInt]
def constructor(
      time_in_hours_for_fundraising:,
      campaign_url:,
      fund_recipient:,
      minimum_to_raise: )

  @creator          = msg.sender
  @fund_recipient   = fund_recipient   # note: creator may be different than recipient
  @campaign_url     = campaign_url
  @minimum_to_raise = minimum_to_raise # required to tip, else everyone gets refund
  @raise_by         = block.timestamp + (time_in_hours_for_fundraising * 1.hour )
  @state            = State.fundraising
end


sig :pay_out, []
def pay_out
  assert @state.successful?,  'state must be set to successful for pay out'

  @fund_recipient.transfer( this.balance )
  log WinnerPaid, winner_address: @fund_recipient
end


sig :check_if_funding_complete_or_expired, []
def check_if_funding_complete_or_expired
  if @total_raised > @minimum_to_raise
    @state = State.successful
    pay_out()
  elsif block.timestamp > @raise_by
    # note: backers can now collect refunds by calling refund(id)
    @state = State.expired_refund
    @complete_at = block.timestamp
  end
end


sig :sig, [], return: UInt
def contribute
  assert @state.fundraising?, 'state must be set to fundraising to contribute'

  @contributions.push( Contribution.new( msg.value, msg.sender ))
  @total_raised += msg.value

  log FundingReceived, address: msg.sender, 
                       amount: msg.value,
                       current_total: @total_raised 

  check_if_funding_complete_or_expired()

  @contributions.size - 1   # return (contribution) id
end


sig :refund, [UInt], returns: Bool
def refund( id: )
  assert @state.expired_refund?, 'state must be set to expired_refund to refund'
  assert @contributions.size > id && id >= 0 && @contributions[id].amount != 0,  'contribution id out-of-range'

  amount_to_refund = @contributions[id].amount
  @contributions[id].amount = 0

  @contributions[id].contributor.transfer( amount_to_refund )

  true
end

sig :kill, []
def kill
  assert msg.sender == @creator,  'only creator can kill contract'
  # wait 24 weeks after final contract state before allowing contract destruction
  assert @state.expired_refund? || @state.successful?, 'state must be set to expired_refund'  
  aasert @complete_at + 24.weeks < block.timestamp,  'complete_at time must be beyond 24 weeks'

  # note: creator gets all money that hasn't be claimed
  selfdestruct( msg.sender )
end
end  # class CrowdFunder
