pragma solidity 0.8.20;

contract SimpleToken {
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    string public name;
    string public symbol;
    
    uint256 immutable public maxSupply;
    uint256 immutable public perMintLimit;
    
    uint256 public totalSupply;
    
    mapping(address => uint256) public balanceOf;
    
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _maxSupply,
        uint256 _perMintLimit
    ) {
        name = _name;
        symbol = _symbol;
        maxSupply = _maxSupply;
        perMintLimit = _perMintLimit;
    }

    function mint(uint256 amount) public {
        require(amount > 0, "amount must be positive");
        require(amount <= perMintLimit, "amount exceeds perMintLimit");
        require(amount + totalSupply <= maxSupply, "amount exceeds maxSupply");
        
        totalSupply += amount;
        balanceOf[msg.sender] += amount;
        
        emit Transfer(address(0), msg.sender, amount);
    }

    function transfer(address to, uint256 amount) public {
        require(balanceOf[msg.sender] >= amount, "insufficient balance");
      
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        
        emit Transfer(msg.sender, to, amount);
    }
}
