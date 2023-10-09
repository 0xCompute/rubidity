##
##   source/inspired by
##      https://docs.ethscriptions.com/esips/esip-4-the-ethscriptions-virtual-machine
##
##  Here is how the SimpleToken Dumb Contract might be implemented in Rubidity


class SimpleToken < Contract

    event :Transfer,  from:   Address, 
                      to:     Address, 
                      amount: UInt 
  
    storage  name:         String,
             symbol:       String, 
             maxSupply:    UInt,
             perMintLimit: UInt,  
             totalSupply:  UInt,
             balanceOf:    mapping( Address, UInt )

  
  sig  [String, String, UInt, UInt] 
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
  
  sig [UInt]
  def  mint( amount: )
    puts "==> mint amount: #{amount.pretty_print_inspect}"

    assert amount > 0, 'Amount must be positive' 
    pp @perMintLimit
    assert amount <= @perMintLimit, 'Exceeded mint limit' 
    
    assert @totalSupply + amount <= @maxSupply, 'Exceeded max supply' 
    
    @totalSupply += amount
    @balanceOf[msg.sender] += amount
    
    log Transfer, from: address(0), to: msg.sender, amount: amount
  end


  sig [Address, UInt]
  def transfer( to:, 
                amount: )
    puts "==> transfer to: #{to.pretty_print_inspect}, amount: #{amount.pretty_print_inspect}"

    assert @balanceOf[msg.sender] >= amount, 'Insufficient balance'
    
    @balanceOf[msg.sender] -= amount
    @balanceOf[to] += amount

    log Transfer, from: msg.sender, to: to, amount: amount
  end
end
