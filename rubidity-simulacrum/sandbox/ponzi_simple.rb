##
# a simple ponzy (scheme) contract
#   last investor (or sucker) HODLing the bag


class SimplePonzi < ContractImplementation

    storage current_investor:    :address,
            current_investment:  :uint256


    sig :constructor, []
    def constructor
      @current_investor  = msg.sender
    end

    sig :receive, [] 
    def receive         # @payable default function
      minimum_investment = @current_investment * 11/10
      assert  msg.value >= minimum_investment, 'new investments must be 10% greater than current'  
  
      # record new investor
      previous_investor   = @current_investor
      @current_investor   = msg.sender
      @current_investment = msg.value
  
      # pay out previous investor
      previous_investor.send( msg.value )
    end
  
  end # class SimplPonzi