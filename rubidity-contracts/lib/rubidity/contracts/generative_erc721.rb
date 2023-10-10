class GenerativeERC721 < ERC721
  
  storage generativeScript: String,
          tokenIdToSeed:    mapping( UInt, UInt ),  
          totalSupply:      UInt, 
          maxSupply:        UInt, 
          maxPerAddress:    UInt, 
          description:      String 
  
  sig [ String, String, String, UInt, String, UInt]  
  def constructor(
    name:,
    symbol:,
    generativeScript:,
    maxSupply:,
    description:,
    maxPerAddress: )
    super(name: name, symbol: symbol)
    
    @maxSupply = maxSupply
    @maxPerAddress = maxPerAddress
    @description = description
    @generativeScript = generativeScript
  end
  
  sig [UInt]
  def mint( amount )
    assert(amount > 0, 'Amount must be positive')
    assert(amount + @_balanceOf[msg.sender] <= @maxPerAddress, 'Exceeded mint limit')
    assert(amount + @totalSupply <= @maxSupply, 'Exceeded max supply')
    
    hash = block.blockhash(block.number).cast(:uint256) % (2 ** 48)
    
    amount.times do |id|
      tokenId = @totalSupply + id
      seed = hash + tokenId
      
      @tokenIdToSeed[tokenId] = seed
      
      _mint(to: msg.sender, id: tokenId)
    end
    
    @totalSupply += amount
  end
  
  sig [UInt], :view,  returns: String
  def tokenURI( id )
    assert( _exists(id: id), 'ERC721Metadata: URI query for nonexistent token')
    
    html = getHTML(seed: @tokenIdToSeed[id])
    
    html_as_base_64_data_uri = "data:text/html;base64,#{Base64.strict_encode64(html)}"
    
    json_data = {
      name: "#{@name} ##{string(id)}",
      description: @description,
      animation_url: html_as_base_64_data_uri,
    }.to_json
    
    "data:application/json,#{json_data}"
  end
  
  sig [UInt], :view, returns: String
  def getHTML( seed )
    %{<!DOCTYPE html>
    <html>
      <head>
        <style>
          body,
          html {
            width: 100%;
            height: 100%;
            margin: 0;
            padding: 0;
            overflow: hidden;
            display: block;
          }

          #canvas {
            position: absolute;
          }
        </style>
      </head>
      <body>
        <canvas id="canvas"></canvas>
      </body>
      <script>
        window.SEED = #{string(seed)};
        #{@generativeScript}
      </script>
    </html>}
  end
end