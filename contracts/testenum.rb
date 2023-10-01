
class TestEnum < Contract
    
    enum :ActionChoices, :goLeft, :goRight, :goStraight, :sitStill
    
    storage choice: ActionChoices

    DEFAULT_CHOICE = ActionChoices.goStraight

    sig :setGoStraight, []
    def setGoStraight
      @choice = ActionChoices.goStraight
    end

    # Since enum types are not part of the ABI, the signature of "getChoice"
    # will automatically be changed to "getChoice() returns (uint8)"
    # for all matters external to Solidity.
    sig :getChoice, [], :view, returns: ActionChoices
    def getChoice
      @choice
    end

    sig :getDefaultChoice, [], :pure, returns: UInt
    def getDefaultChoice
        ## fix: convert to uint  uint(defaultChoice)
       DEFAULT_CHOICE  
    end

    sig :getLargestValue, [], :pure, returns: ActionChoices
    def getLargestValue
        ActionChoices.max
    end

    sig :getSmallestValue, [], :pure, returns: ActionChoices
    def getSmallestValue 
        ActionChoices.min
    end
end

