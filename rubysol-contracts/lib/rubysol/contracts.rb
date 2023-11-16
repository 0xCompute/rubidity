require 'solidity/typed'
require 'rubysol'

## our own code / contracts
require_relative 'contracts/version'
require_relative 'contracts/erc20.rb'
require_relative 'contracts/erc20_liquidity_pool.rb'
require_relative 'contracts/erc721.rb'
require_relative 'contracts/ether_erc20_bridge.rb'
require_relative 'contracts/ethscription_erc20_bridge.rb'
require_relative 'contracts/generative_erc721.rb'
require_relative 'contracts/open_edition_erc721.rb'
require_relative 'contracts/public_mint_erc20.rb'




puts Rubysol::Module::Contracts.banner     ## say hello
