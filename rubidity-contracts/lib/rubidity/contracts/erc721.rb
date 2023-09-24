class ERC721 < ContractImplementation
  abstract
  
  event :Transfer, { from: :address, 
                     to:   :address, 
                     id:   :uint256 }
  event :Approval, { owner:   :address, 
                     spender: :address, 
                     id:      :uint256 }
  event :ApprovalForAll, { owner:    :address, 
                           operator: :address, 
                           approved: :bool }

  storage  name:             :string,
           symbol:           :string,
           _ownerOf:         mapping( :uint256, :address ),
           _balanceOf:       mapping( :address, :uint256 ),
           getApproved:      mapping( :uint256, :address ), 
           isApprovedForAll: mapping( :address, mapping( :address, :bool))

  sig :constructor, [:string, :string]           
  def constructor( name:, 
                   symbol: ) 
    @name   = name
    @symbol = symbol
  end


  sig :ownerOf, [ :uint256 ], :view, :virtual, returns: :address 
  def ownerOf( id )
    owner = @_ownerOf[id]
    assert owner != address(0), "ERC721: owner query for nonexistent token"
    
    owner
  end
  
  sig :balanceOf, [ :address ], :view, :virtual, returns: :uint256
  def balanceOf( owner: ) 
    assert owner != address(0), "ERC721: balance query for nonexistent owner"
    
    @_balanceOf[owner]
  end
  
  sig :approve, [ :address, :uint256], :virtual
  def approve( spender:, 
               id: )
    owner = @_ownerOf[id]
    
    assert msg.sender == owner || @isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED"
    
    @getApproved[id] = spender;

    log :Approval, owner: owner, spender: spender, id: id
  end
  
  sig :setApprovalForAll, [:address, :bool], :virtual
  def setApprovalForAll( operator:,
                         approved: ) 
    @isApprovedForAll[msg.sender][operator] = approved;

    log :ApprovalForAll, owner: msg.sender, operator: operator, approved: approved
  end
  
  sig :transferFrom, [ :address, :address, :uint256], :virtual
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
  
  sig :_exists, [:uint256], :virtual
  def _exists( id )
    @_ownerOf[id] != address(0)
  end
 
  sig :_mint, [:address, :uint256], :virtual
  def _mint( to:, 
             id: )
    assert to != address(0), "ERC721: mint to the zero address"
    assert @_ownerOf[id] == address(0), "ERC721: token already minted"
    
    @_balanceOf[to] += 1

    @_ownerOf[id] = to
    
    log :Transfer, from: address(0), to: to, id: id
  end
  
  sig :_burn, [:uint256], :virtual
  def _burn( id: )
    owner = @_ownerOf[id]
    
    assert owner != address(0), "ERC721: burn of nonexistent token"
    
    @_balanceOf[owner] -= 1
    
    @_ownerOf[id] = address(0)
    
    @getApproved[id] = address(0)
    
    log :Transfer, from: owner, to: address(0), id: id
  end
  
  sig :tokenURI, [:uint256], :view, :virtual, returns: :string
  def tokenURI( id: )
  end
end