
class TestToken < ContractImplementation   
  
    event :Transfer, { from: :addressOrDumbContract, 
                       to: :addressOrDumbContract, 
                       amount: :uint256 }

    string :public, :name
    string :public, :symbol
    uint256 :public, :decimals    
    uint256 :public, :totalSupply
  
    mapping ({ addressOrDumbContract: :uint256 }), :public, :balanceOf


    ## or @sig constructor( string, string, uint256, uint256)
    ## constructor [:string, :string, :uint256, :uint256] 
    sig :constructor, [:string, :string, :uint256, :uint256]
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

    ## or @sig transfer (addressOrDumbContract, uint256 ) public virtual returns bool
    ## function :transfer, [:addressOrDumbContract, :uint256], :public, :virtual, returns: :bool 
    sig :transfer, [:addressOrDumbContract, :uint256], :public, :virtual, returns: :bool
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
