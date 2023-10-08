
class TestToken < Contract  
  
    event :Transfer, from:   Address, 
                     to:     Address, 
                     amount: UInt

    storage name:         String, 
            symbol:       String, 
            decimals:     UInt,     
            totalSupply:  UInt,
            balanceOf:    mapping( Address, UInt )

    ## or @sig constructor( string, string, uint, uint)
    ## constructor [:string, :string, :uint, :uint] 
    sig  [String, String, UInt, UInt]
    def constructor(name:, 
                    symbol:, 
                    decimals:,
                    totalSupply:) 
        @name = name
        @symbol = symbol
        @decimals = decimals
        @totalSupply = totalSupply

        @balanceOf[msg.sender] = totalSupply
        puts "hello from contructor"
    end

    ## or @sig transfer (address, uint ) public virtual returns bool
    ## function :transfer, [:address, :uint], :public, :virtual, returns: :bool 
    sig [Address, UInt], returns: Bool
    def transfer( to:, amount: )
        puts "[debug] transfer"
        pp @balanceOf[msg.sender]
        pp amount

        assert @balanceOf[msg.sender] >= amount, 'Insufficient balance'
        
        @balanceOf[msg.sender] -= amount

        pp amount
        pp to
        puts "[debug] s.balanceOf[to]"
        pp @balanceOf[to]
        puts "[debug] s.balanceOf[to] += amount"
        @balanceOf[to] += amount

        puts "hello from transfer"
    
        log :Transfer, from: msg.sender, to: to, amount: amount
        
        true
    end
end  # class TestToken  
