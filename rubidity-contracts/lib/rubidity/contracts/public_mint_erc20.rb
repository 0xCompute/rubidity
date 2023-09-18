class PublicMintERC20 < ERC20
  
  uint256 :public, :maxSupply
  uint256 :public, :perMintLimit
  
  sig :constructor, [:string, :string, :uint256, :uint256, :uint256]
  def constructor(
    name:,
    symbol:,
    maxSupply:,
    perMintLimit:,
    decimals:
  ) 
    ERC20(name: name, symbol: symbol, decimals: decimals)
    s.maxSupply = maxSupply
    s.perMintLimit = perMintLimit
  end
 

  sig :mint, [:uint256], :public
  def mint( amount: )
    assert(amount > 0, 'Amount must be positive')
    assert(amount <= s.perMintLimit, 'Exceeded mint limit')
    
    assert(s.totalSupply + amount <= s.maxSupply, 'Exceeded max supply')
    
    _mint(to: msg.sender, amount: amount)
  end
  
  sig :airdrop, [:addressOrDumbContract, :uint256], :public
  def airdrop( to:, amount: ) 
    assert(amount > 0, 'Amount must be positive')
    assert(amount <= s.perMintLimit, 'Exceeded mint limit')
    
    assert(s.totalSupply + amount <= s.maxSupply, 'Exceeded max supply')
    
    _mint(to: to, amount: amount)
  end
end
