class PublicMintERC20 < ERC20
  
  storage maxSupply:    :uint256,
          perMintLimit: :uint256 
  
  sig :constructor, [:string, :string, :uint256, :uint256, :uint256]
  def constructor(
    name:,
    symbol:,
    maxSupply:,
    perMintLimit:,
    decimals:
  ) 

  puts "==> PublicMintERC20.construct name:#{name.pretty_print_inspect},"+
                                     "symbol: #{symbol.pretty_print_inspect},"+
                                     "maxSupply: #{maxSupply.pretty_print_inspect},"+
                                     "perMintLimit: #{perMintLimit.pretty_print_inspect},"+
                                     "decimals: #{decimals.pretty_print_inspect})"              


    #super( name: name, 
    #       symbol: symbol, 
    #       decimals: decimals )
    ERC20( name: name, 
           symbol: symbol, 
           decimals: decimals)
    #__ERC20__constructor( name: name, 
    #                      symbol: symbol, 
    #                      decimals: decimals)

    @maxSupply    = maxSupply
    @perMintLimit = perMintLimit
  end
 

  sig :mint, [:uint256], :public
  def mint( amount: )
    assert(amount > 0, 'Amount must be positive')
    assert(amount <= @perMintLimit, 'Exceeded mint limit')
    
    assert( @totalSupply + amount <= @maxSupply, 'Exceeded max supply')
    
    _mint(to: msg.sender, amount: amount)
  end
  
  sig :airdrop, [:addressOrDumbContract, :uint256], :public
  def airdrop( to:, amount: ) 
    assert(amount > 0, 'Amount must be positive')
    assert(amount <= @perMintLimit, 'Exceeded mint limit')
    
    assert(@totalSupply + amount <= @maxSupply, 'Exceeded max supply')
    
    _mint(to: to, amount: amount)
  end
end
