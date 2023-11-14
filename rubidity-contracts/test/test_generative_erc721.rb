##
#  to run use:
#    $ ruby test/test_generative_erc721.rb


require_relative 'helper'


class TestGenerativeERC721 < Minitest::Test

STATE_ZERO = {
    :name=>"",
    :symbol=>"",
    :_ownerOf=>{},
    :_balanceOf=>{},
    :getApproved=>{},
    :isApprovedForAll=>{},
    :generativeScript=>"",
    :tokenIdToSeed=>{},
    :totalSupply=>0,
    :maxSupply=>0,
    :maxPerAddress=>0,
    :description=>""
}

STATE_INIT = {
    :name=>"My Generative",
    :symbol=>"GEN",
    :_ownerOf=>{},
    :_balanceOf=>{},
    :getApproved=>{},
    :isApprovedForAll=>{},
    :generativeScript=>"script_here",
    :tokenIdToSeed=>{},
    :totalSupply=>0,
    :maxSupply=>10000,
    :maxPerAddress=>10,
    :description=>"description_here"    
}


def test_meta
    pp ERC721.state_variable_definitions
    pp ERC721.parent_contracts 
    pp ERC721.events 
    pp ERC721.is_abstract_contract
    
    abi = ERC721.abi
    
    puts
    puts "public_abi:"
    pp ERC721.public_abi    

    pp GenerativeERC721.state_variable_definitions
    pp GenerativeERC721.parent_contracts 
    pp GenerativeERC721.events 
    pp GenerativeERC721.is_abstract_contract
    
    abi = GenerativeERC721.abi
    
    puts
    puts "public_abi:"
    pp GenerativeERC721.public_abi    
  end

  def test_contract
    contract = GenerativeERC721.new
    pp contract
  
    state = contract.serialize
    pp state

    assert_equal STATE_ZERO, state

    contract.constructor(
        name: 'My Generative',      # :string,
        symbol: 'GEN',                  # :string,
        generativeScript: 'script_here', # :string,
        maxSupply:  10000,               # :uint256,
        description: 'description_here', # :string,
        maxPerAddress: 10               # :uint256,
      ) 

    state = contract.serialize
    pp state
    assert_equal STATE_INIT, state
  end
end