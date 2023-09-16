require_relative 'helper'


## pull in contract one-by-one for now (later auto-load ALL!)

require 'rubidity/contracts/erc721'


pp ERC721
puts
pp ERC721.public_abi
puts
pp ERC721.state_variable_definitions
puts
pp ERC721.parent_contracts

require 'rubidity/contracts/generative_erc721'


pp GenerativeERC721
puts
pp GenerativeERC721.public_abi
puts
pp GenerativeERC721.state_variable_definitions
puts
pp GenerativeERC721.parent_contracts


puts "bye"