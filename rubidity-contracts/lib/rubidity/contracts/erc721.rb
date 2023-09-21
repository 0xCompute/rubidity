class ERC721 < ContractImplementation
  pragma :rubidity, "1.0.0"

  abstract
  
  event :Transfer, { from: :addressOrDumbContract, 
                     to:   :addressOrDumbContract, 
                     id:   :uint256 }
  event :Approval, { owner:   :addressOrDumbContract, 
                     spender: :addressOrDumbContract, 
                     id:      :uint256 }
  event :ApprovalForAll, { owner:    :addressOrDumbContract, 
                           operator: :addressOrDumbContract, 
                           approved: :bool }

  storage  name:             :string,
           symbol:           :string,
           _ownerOf:         mapping( :uint256, :addressOrDumbContract ),
           _balanceOf:       mapping( :addressOrDumbContract, :uint256 ),
           getApproved:      mapping( :uint256, :addressOrDumbContract ), 
           isApprovedForAll: mapping( :addressOrDumbContract, mapping( :addressOrDumbContract, :bool))

  sig :constructor, [:string, :string]           
  def constructor( name:, 
                   symbol: ) 
    @name   = name
    @symbol = symbol
  end


  sig :ownerOf, [ :uint256 ], :view, :virtual, returns: :addressOrDumbContract 
  def ownerOf( id )
    owner = @_ownerOf[id]
    assert owner != addressOrDumbContract(0), "ERC721: owner query for nonexistent token"
    
    owner
  end
  
  sig :balanceOf, [ :addressOrDumbContract ], :view, :virtual, returns: :uint256
  def balanceOf( owner: ) 
    assert owner != addressOrDumbContract(0), "ERC721: balance query for nonexistent owner"
    
    @_balanceOf[owner]
  end
  
  sig :approve, [ :addressOrDumbContract, :uint256], :virtual
  def approve( spender:, 
               id: )
    owner = @_ownerOf[id]
    
    assert msg.sender == owner || @isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED"
    
    @getApproved[id] = spender;

    log :Approval, owner: owner, spender: spender, id: id
  end
  
  sig :setApprovalForAll, [:addressOrDumbContract, :bool], :virtual
  def setApprovalForAll( operator:,
                         approved: ) 
    @isApprovedForAll[msg.sender][operator] = approved;

    log :ApprovalForAll, owner: msg.sender, operator: operator, approved: approved
  end
  
  sig :transferFrom, [ :addressOrDumbContract, :addressOrDumbContract, :uint256], :virtual
  def transferFrom( from:, 
                    to:, 
                    id: )
    assert from == @_ownerOf[id], "ERC721: transfer of token that is not own"
    assert to != addressOrDumbContract(0), "ERC721: transfer to the zero address"
    
    assert(
      msg.sender == from ||
      @getApproved[id] == msg.sender ||
      @isApprovedForAll[from][msg.sender],
      "NOT_AUTHORIZED"
    )
    
    @_balanceOf[from] -= 1
    @_balanceOf[to] += 1
    
    @_ownerOf[id] = to
    
    @getApproved[id] = addressOrDumbContract(0)
  end
  
  sig :_exists, [:uint256], :virtual
  def _exists( id )
    @_ownerOf[id] != addressOrDumbContract(0)
  end
 
  sig :_mint, [:addressOrDumbContract, :uint256], :virtual
  def _mint( to:, 
             id: )
    assert to != addressOrDumbContract(0), "ERC721: mint to the zero address"
    assert @_ownerOf[id] == addressOrDumbContract(0), "ERC721: token already minted"
    
    @_balanceOf[to] += 1

    @_ownerOf[id] = to
    
    log :Transfer, from: addressOrDumbContract(0), to: to, id: id
  end
  
  sig :_burn, [:uint256], :virtual
  def _burn( id: )
    owner = @_ownerOf[id]
    
    assert owner != addressOrDumbContract(0), "ERC721: burn of nonexistent token"
    
    @_balanceOf[owner] -= 1
    
    @_ownerOf[id] = addressOrDumbContract(0)
    
    @getApproved[id] = addressOrDumbContract(0)
    
    log :Transfer, from: owner, to: addressOrDumbContract(0), id: id
  end
  
  sig :tokenURI, [:uint256], :view, :virtual, returns: :string
  def tokenURI( id: )
  end
end