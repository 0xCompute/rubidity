
class TestToken < ContractImplementation   
  
    event :Transfer, { from: :addressOrDumbContract, 
                       to: :addressOrDumbContract, 
                       amount: :uint256 }

    string :public, :name
    string :public, :symbol
    uint256 :public, :decimals    
    uint256 :public, :totalSupply
  
    mapping ({ addressOrDumbContract: :uint256 }), :public, :balanceOf


    constructor(name: :string, 
                symbol: :string, 
                decimals: :uint256,
                totalSupply: :uint256) {
        s.name = name
        s.symbol = symbol
        s.decimals = decimals
        s.totalSupply = totalSupply

        s.balanceOf[msg.sender] = totalSupply
        puts "hello from contructor"
      }

    function :transfer, { to: :addressOrDumbContract, amount: :uint256 }, :public, :virtual, returns: :bool do

        puts "[debug] transfer"
        pp s.balanceOf[msg.sender]
        pp amount

        require(s.balanceOf[msg.sender] >= amount, 'Insufficient balance')
        
        s.balanceOf[msg.sender] -= amount

        pp amount
        pp to
        puts "[debug] s.balanceOf[to]"
        pp s.balanceOf[to]
        puts "[debug] s.balanceOf[to] += amount"
        s.balanceOf[to] += amount

        puts "hello from transfer"
    
        emit :Transfer, from: msg.sender, to: to, amount: amount
        
        return true
    end
end  # class TestToken  

