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

  puts "==> PublicMintERC20.construct name:#{name.pretty_print_inspect},"+
                                     "symbol: #{symbol.pretty_print_inspect},"+
                                     "maxSupply: #{maxSupply.pretty_print_inspect},"+
                                     "perMintLimit: #{perMintLimit.pretty_print_inspect},"+
                                     "decimals: #{decimals.pretty_print_inspect})"              


    #ERC20( name: name, 
    #       symbol: symbol, 
    #       decimals: decimals )
    super( name: name, 
           symbol: symbol, 
           decimals: decimals)
    #__ERC20__constructor( name: name, 
    #                      symbol: symbol, 
    #                      decimals: decimals)

    @maxSupply    = maxSupply
    @perMintLimit = perMintLimit
  end
 

  sig  [UInt]
  def mint( amount: )
    assert(amount > 0, 'Amount must be positive')
    assert(amount <= @perMintLimit, 'Exceeded mint limit')
    
    assert( @totalSupply + amount <= @maxSupply, 'Exceeded max supply')
    
    _mint(to: msg.sender, amount: amount)
  end
  
  sig [Address, UInt]
  def airdrop( to:, amount: ) 
    assert(amount > 0, 'Amount must be positive')
    assert(amount <= @perMintLimit, 'Exceeded mint limit')
    
    assert(@totalSupply + amount <= @maxSupply, 'Exceeded max supply')
    
    _mint(to: to, amount: amount)
  end
end
