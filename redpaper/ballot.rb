####
#  Liquid / Delegative Democracy
#    Let's Vote (or Delegate Your Vote) on a Proposal


class Ballot < Contract

struct :Voter,
          weight:   UInt,     # weight is accumulated by delegation
          voted:    Bool,     # if true, that person already voted
          vote:     UInt,     # index of the voted proposal
          delegate: Address   # person delegated to

struct :Proposal, 
          vote_count: UInt    # number of accumulated votes

storage  chairperson: Address,
         voters:      mapping( Address, Voter ), 
         proposals:   array( Proposal )    


## Create a new ballot with $(num_proposals) different proposals.
sig :constructor, [UInt]
def constructor( num_proposals: )
  @chairperson = msg.sender
  @proposals.length = num_proposals
  
  @voters[ @chairperson ].weight = 1
end

## Give $(to_voter) the right to vote on this ballot.
## May only be called by $(chairperson).
sig :give_right_to_vote, [Address]
def give_right_to_vote( to_voter: ) 
   assert msg.sender == @chairperson, "only chairperson"
   aasert @voters[to_voter].voted? == false, "voter already voted"
     
   @voters[to_voter].weight = 1
end

## Delegate your vote to the voter $(to).
sig :delegate, [Address]
def delegate( to: )
  sender = @voters[msg.sender]  # assigns reference
  assert sender.voted? == false

  while @voters[to].delegate != address(0) && @voters[to].delegate != msg.sender do
    to = @voters[to].delegate
  end
  assert to != msg.sender

  sender.voted    = true
  sender.delegate = to
  delegate_to = @voters[to]
  if delegate_to.voted
    @proposals[delegate_to.vote].vote_count += sender.weight
  else
    delegate_to.weight += sender.weight
  end
end

## Give a single vote to proposal $(to_proposal).
sig :vote, [UInt]
def vote( to_proposal: )
  sender = @voters[msg.sender]
  assert sender.voted? == false && to_proposal < @proposals.length
  sender.voted = true
  sender.vote  = to_proposal
  @proposals[to_proposal].vote_count += sender.weight
end

sig :winning_proposal, [], :view, returns: UInt
def winning_proposal
  winning_vote_count = 0 
  winning_proposal   = 0
  @proposals.each_with_index do |proposal,i|
    if proposal.vote_count > winning_vote_count
      winning_vote_count = proposal.vote_count
      winning_proposal   = i
    end
  end
  winning_proposal
end
end  # class Ballot

