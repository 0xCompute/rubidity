class ERC721 < Contract
  
  event :Transfer, from: Address, 
                   to:   Address, 
                   id:   UInt
  event :Approval, owner:  Address, 
                   spender: Address, 
                     id:     UInt 
  event :ApprovalForAll,  owner:    Address, 
                           operator: Address, 
                           approved: Bool 

  storage  name:             String,
           symbol:           String,
           _ownerOf:         mapping( UInt, Address ),
           _balanceOf:       mapping( Address, UInt ),
           getApproved:      mapping( UInt, Address ), 
           isApprovedForAll: mapping( Address, mapping( Address, Bool ))

  sig  [String, String]           
  def constructor( name:, 
                   symbol: ) 
    @name   = name
    @symbol = symbol
  end


  sig [ UInt ], :view, returns: Address 
  def ownerOf( id )
    owner = @_ownerOf[id]
    assert owner != address(0), "ERC721: owner query for nonexistent token"
    
    owner
  end
  
  sig [ Address ], :view, returns: UInt
  def balanceOf( owner: ) 
    assert owner != address(0), "ERC721: balance query for nonexistent owner"
    
    @_balanceOf[owner]
  end
  
  sig [ Address, UInt]
  def approve( spender:, 
               id: )
    owner = @_ownerOf[id]
    
    assert msg.sender == owner || @isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED"
    
    @getApproved[id] = spender;

    log Approval, owner: owner, spender: spender, id: id
  end
  
  sig [Address, Bool]
  def setApprovalForAll( operator:,
                         approved: ) 
    @isApprovedForAll[msg.sender][operator] = approved;

    log ApprovalForAll, owner: msg.sender, operator: operator, approved: approved
  end
  
  sig [ Address, Address, UInt]
  def transferFrom( from:, 
                    to:, 
                    id: )
    assert from == @_ownerOf[id], "ERC721: transfer of token that is not own"
    assert to != address(0), "ERC721: transfer to the zero address"
    
    assert(
      msg.sender == from ||
      @getApproved[id] == msg.sender ||
      @isApprovedForAll[from][msg.sender],
      "NOT_AUTHORIZED"
    )
    
    @_balanceOf[from] -= 1
    @_balanceOf[to] += 1
    
    @_ownerOf[id] = to
    
    @getApproved[id] = address(0)
  end
  
  sig [UInt]
  def _exists( id )
    @_ownerOf[id] != address(0)
  end
 
  sig [Address, UInt]
  def _mint( to:, 
             id: )
    assert to != address(0), "ERC721: mint to the zero address"
    assert @_ownerOf[id] == address(0), "ERC721: token already minted"
    
    @_balanceOf[to] += 1

    @_ownerOf[id] = to
    
    log Transfer, from: address(0), to: to, id: id
  end
  
  sig [UInt]
  def _burn( id: )
    owner = @_ownerOf[id]
    
    assert owner != address(0), "ERC721: burn of nonexistent token"
    
    @_balanceOf[owner] -= 1
    
    @_ownerOf[id] = address(0)
    
    @getApproved[id] = address(0)
    
    log Transfer, from: owner, to: address(0), id: id
  end
  
  sig [UInt], :view, returns: String
  def tokenURI( id: )
  end
end
