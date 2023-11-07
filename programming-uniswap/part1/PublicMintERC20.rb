


class PublicMintERC20 < ERC20

  storage maxSupply:    UInt,
          perMintLimit: UInt
  
  sig [String, String, UInt, UInt, UInt]
  def constructor(
    name:,
    symbol:,
    maxSupply:,
    perMintLimit:,
    decimals: 
    )
    super( name: name, symbol: symbol, decimals: decimals )
    @maxSupply    = maxSupply
    @perMintLimit = perMintLimit
  end
  
  sig [UInt]  
  def mint( amount: )
    assert amount > 0, 'Amount must be positive'
    assert amount <= @perMintLimit, 'Exceeded mint limit'    
    assert @totalSupply + amount <= @maxSupply, 'Exceeded max supply'
    
    _mint( to: msg.sender, amount: amount )
  end
  
  sig [Address, UInt]
  def airdrop( to:, amount: )
    assert amount > 0, 'Amount must be positive'
    assert amount <= @perMintLimit, 'Exceeded mint limit'
    assert @totalSupply + amount <= @maxSupply, 'Exceeded max supply'
    
    _mint( to: to, amount: amount )
  end
end  # class PublicMintERC20
