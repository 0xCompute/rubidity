##
##   source/inspired by
##      https://docs.ethscriptions.com/esips/esip-4-the-ethscriptions-virtual-machine
##
##  Here is how the SimpleToken Dumb Contract might be implemented in Rubidity


class SimpleToken < ContractImplementation

    event :Transfer, { from:   :addressOrDumbContract, 
                       to:     :addressOrDumbContract, 
                       amount: :uint256 }
  
    storage  name:         :string,
             symbol:       :string, 
             maxSupply:    :uint256,
             perMintLimit: :uint256,  
             totalSupply:  :uint256,
             balanceOf:    mapping( :addressOrDumbContract, :uint256 )

  
  sig :constructor, [:string, :string, :uint256, :uint256] 
  def constructor(
         name:,
         symbol:,
         maxSupply:,
         perMintLimit: )
    @name = name
    @symbol = symbol
    @maxSupply = maxSupply
    @perMintLimit = perMintLimit
  end
  
  sig :mint, [:uint256]
  def  mint( amount: )
    puts "==> mint amount: #{amount.pretty_print_inspect}"

    assert amount > 0, 'Amount must be positive' 
    pp @perMintLimit
    assert amount <= @perMintLimit, 'Exceeded mint limit' 
    
    assert @totalSupply + amount <= @maxSupply, 'Exceeded max supply' 
    
    @totalSupply += amount
    @balanceOf[msg.sender] += amount
    
    log :Transfer, from: address(0), to: msg.sender, amount: amount
  end


  sig :transfer, [:addressOrDumbContract, :uint256]
  def transfer( to:, 
                amount: )
    puts "==> transfer to: #{to.pretty_print_inspect}, amount: #{amount.pretty_print_inspect}"

    assert @balanceOf[msg.sender] >= amount, 'Insufficient balance'
    
    @balanceOf[msg.sender] -= amount
    @balanceOf[to] += amount

    log :Transfer, from: msg.sender, to: to, amount: amount
    
    true
  end
end
