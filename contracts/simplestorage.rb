

class SimpleStorage <  Contract
     
    storage storedData: UInt
    
    sig [UInt]
    def set( x: )
      @storedData = x
    end

    sig [], :view, returns: UInt
    def get
      @storedData
    end
    
end

