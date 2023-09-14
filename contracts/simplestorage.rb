
class SimpleStorage <  ContractImplementation
    uint256 :storedData
    
    function :set, { x: :uint256 }, :public do
      s.storedData = x
    end
    
    function :get, {}, :public, :view, returns: :uint256 do
      return s.storedData
    end
    
    constructor() {}
  end


