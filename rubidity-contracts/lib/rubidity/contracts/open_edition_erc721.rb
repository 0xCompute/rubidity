class OpenEditionERC721 < ERC721
  
  storage contentURI:    String, 
          maxPerAddress: UInt,
          totalSupply:   UInt,
          description:   String,
          mintStart:     Timestamp,
          mintEnd:       Timestamp

  sig [String, String, String, UInt, String, Timestamp, Timestamp]        
  def constructor(
    name:,
    symbol:,
    contentURI:,
    maxPerAddress:,
    description:,
    mintStart:,
    mintEnd: )
    super(name: name, symbol: symbol)
    
    @maxPerAddress = maxPerAddress
    @description = description
    @contentURI = contentURI
    @mintStart = mintStart
    @mintEnd = mintEnd
  end

  sig [UInt]
  def mint( amount: )
    assert(amount > 0, 'Amount must be positive')
    assert(amount + @_balanceOf[msg.sender] <= @maxPerAddress, 'Exceeded mint limit')
    assert(block.timestamp >= @mintStart, 'Minting has not started')
    assert(block.timestamp < @mintEnd, 'Minting has ended')
    
    amount.times do |id|
      _mint(to: msg.sender, id: @totalSupply + id)
    end
    
    @totalSupply += amount
  end
  
  sig [UInt], :view, returns: String
  def tokenURI( id: ) 
    assert(_exists(id: id), 'ERC721Metadata: URI query for nonexistent token')

    json_data = {
      name: "#{@name} ##{string(id)}",
      description: @description,
      image: @contentURI,
    }.to_json
    
    "data:application/json,#{json_data}"
  end
end