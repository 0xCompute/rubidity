class ERC20 < ContractImplementation  
  abstract
  
  event :Transfer, { from:    :address, 
                     to:      :address, 
                     amount:  :uint256 }
  event :Approval, { owner:   :address, 
                     spender: :address, 
                     amount:  :uint256 }

  storage name:        :string, 
          symbol:      :string,  
          decimals:    :uint256, 
          totalSupply: :uint256, 
          balanceOf:   mapping( :address, :uint256 ), 
          allowance:   mapping( :address, mapping( :address, :uint256 ))
          

  sig :constructor, [:string, :string, :uint256] 
  def constructor(name:, 
                  symbol:, 
                  decimals:) 
    puts "==> ERC20.construct name:#{name.pretty_print_inspect},"+
                             "symbol: #{symbol.pretty_print_inspect},"+
                             "decimals: #{decimals.pretty_print_inspect})"              
    @name = name
    @symbol = symbol
    @decimals = decimals
  end


  sig :approve, [:address, :uint256], :virtual, returns: :bool
  def approve( spender:, 
               amount: ) 
    @allowance[msg.sender][spender] = amount
    
    log :Approval, owner: msg.sender, spender: spender, amount: amount
    
    true
  end
  

  sig :decreaseAllowanceUntilZero, [:address, :uint256], :virtual, returns: :bool
  def decreaseAllowanceUntilZero( spender:, 
                                  difference: )
    allowed = @allowance[msg.sender][spender]
    
    newAllowed = allowed > difference ? allowed - difference : 0
    
    approve(spender: spender, amount: newAllowed)
    
    true
  end


  sig :transfer, [:address, :uint256], :virtual, returns: :bool
  def transfer( to:, 
                amount: )
    assert @balanceOf[msg.sender] >= amount, 'Insufficient balance'
    
    @balanceOf[msg.sender] -= amount
    @balanceOf[to] += amount

    log :Transfer, from: msg.sender, to: to, amount: amount
    
    true
  end
  
  sig :transferFrom, [:address, :address, :uint256], :virtual, returns: :bool
  def transferFrom( 
       from:,
       to:,
       amount:)
    allowed = @allowance[from][msg.sender]
    
    assert @balanceOf[from] >= amount, 'Insufficient balance'
    assert allowed >= amount, 'Insufficient allowance'
    
    @allowance[from][msg.sender] = allowed - amount
    
    @balanceOf[from] -= amount
    @balanceOf[to] += amount
    
    log :Transfer, from: from, to: to, amount: amount
    
    true
  end
  
  sig :_mint, [:address, :uint256], :virtual
  def _mint( to:,
             amount: )
    @totalSupply += amount
    @balanceOf[to] += amount
    
    log :Transfer, from: address(0), to: to, amount: amount
  end
  
  sig :_burn, [:address, :uint256], :virtual
  def _burn( from:, 
             amount: )
     @balanceOf[from] -= amount
     @totalSupply -= amount
    
     log :Transfer, from: from, to: address(0), amount: amount
  end
end
