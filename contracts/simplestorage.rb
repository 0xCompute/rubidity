

class SimpleStorage <  ContractImplementation
     
    storage storedData: :uint256
    
    sig :set, [:uint256]
    def set( x: )
      @storedData = x
    end

    sig :get, [], :view, returns: :uint256
    def get
      @storedData
    end
    
    ## empty constructor required - double check - why? why not?
    sig :constructor, []
    def constructor
    end
end


