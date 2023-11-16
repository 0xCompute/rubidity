require_relative 'helper'
require 'rubysol/contracts'

require 'cocos'  ## add write_json helper



contracts = [
    ERC20,
    ERC721,
    PublicMintERC20,
    GenerativeERC721,
]


contracts.each do |contract|
  abi = contract.abi

  puts "==>  #{contract.name} contract abi:"
  pp contract.public_abi


  data = abi.public_abi_as_json
  write_json( "abi2sol/#{contract.name}.json", data )
end



puts "bye"
