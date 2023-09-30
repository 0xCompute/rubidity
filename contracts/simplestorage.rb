

class SimpleStorage <  Contract
     
    storage storedData: UInt
    
    sig :set, [UInt]
    def set( x: )
      @storedData = x
    end

    sig :get, [], :view, returns: UInt
    def get
      @storedData
    end
    
    ## empty constructor required - double check - why? why not?
    sig :constructor, []
    def constructor
    end
end

