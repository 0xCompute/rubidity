##
##   source/inspired by
##      https://docs.ethscriptions.com/esips/esip-4-the-ethscriptions-virtual-machine
##
##  Here is how the SimpleToken Dumb Contract might be implemented in Rubidity



class SimpleToken < ContractImplementation

    event :Transfer, { from: :addressOrDumbContract, 
                       to: :addressOrDumbContract, 
                       amount: :uint256 }
  
  string :public, :name
  string :public, :symbol
  
  uint256 :public, :maxSupply
  uint256 :public, :perMintLimit
  
  uint256 :public, :totalSupply
  
  mapping ({ addressOrDumbContract: :uint256 }), :public, :balanceOf
  
  constructor(
    name: :string,
    symbol: :string,
    maxSupply: :uint256,
    perMintLimit: :uint256,
  ) {
    s.name = name
    s.symbol = symbol
    s.maxSupply = maxSupply
    s.perMintLimit = perMintLimit
  }
  
  function :mint, { amount: :uint256 }, :public do
    assert(amount > 0, 'Amount must be positive')
    assert(amount <= s.perMintLimit, 'Exceeded mint limit')
    
    assert(s.totalSupply + amount <= s.maxSupply, 'Exceeded max supply')
    
    s.totalSupply += amount
    s.balanceOf[msg.sender] += amount
    
    # emit :Transfer, from: address(0), to: msg.sender, amount: amount
  end

  function :transfer, { to: :addressOrDumbContract, amount: :uint256 }, :public do
    assert(s.balanceOf[msg.sender] >= amount, 'Insufficient balance')
    
    s.balanceOf[msg.sender] -= amount
    s.balanceOf[to] += amount

    # emit :Transfer, from: msg.sender, to: to, amount: amount
    
    return true
  end
end
