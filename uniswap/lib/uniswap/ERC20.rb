

class ERC20 < Contract   #  abstract: true

  event :Transfer, from: Address, 
                   to:   Address, 
                   amount: UInt 
  event :Approval, owner: Address, 
                   spender: Address, 
                   amount: UInt 

  storage name:        String, 
          symbol:      String, 
          decimals:    UInt,
          totalSupply: UInt,
          balanceOf:   mapping( Address, UInt), 
          allowance:   mapping( Address, mapping( Address, UInt))
          
  sig [String, String, UInt]        
  def constructor(name:, symbol:, decimals:)
    @name     = name
    @symbol   = symbol
    @decimals = decimals
  end

  sig [Address, UInt], returns: Bool 
  def approve( spender:, amount: )
    @allowance[msg.sender][spender] = amount
    
    log Approval, owner: msg.sender, spender: spender, amount: amount
    
    true
  end

  sig [Address, UInt], returns: Bool 
  def transfer( to:, amount: )
    assert @balanceOf[msg.sender] >= amount, "Insufficient balance"
    
    @balanceOf[msg.sender] -= amount
    @balanceOf[to] += amount

    log Transfer, from: msg.sender, to: to, amount: amount
    
    true
  end
  
  sig [Address, Address, UInt], returns: Bool
  def transferFrom( from:, to:, amount: )
    allowed = @allowance[from][msg.sender]
    
    assert @balanceOf[from] >= amount, "Insufficient balance"
    assert allowed >= amount, "Insufficient allowance"
    
    @allowance[from][msg.sender] = allowed - amount
    
    @balanceOf[from] -= amount
    @balanceOf[to] += amount
    
    log Transfer, from: from, to: to, amount: amount
    
    true
  end
  
  sig [Address, UInt]
  def _mint( to:, amount: )
    @totalSupply += amount
    @balanceOf[to] += amount
    
    log Transfer, from: address(0), to: to, amount: amount
  end
  
  sig [Address, UInt]
  def _burn( from:, amount: )
    @balanceOf[from] -= amount
    @totalSupply -= amount
    
    log Transfer, from: from, to: address(0), amount: amount
  end
end  # class ERC20 
