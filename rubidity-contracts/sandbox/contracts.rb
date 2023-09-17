require_relative 'helper'


## pull in contract one-by-one for now (later auto-load ALL!)
require 'rubidity/contracts/erc20.rb'
require 'rubidity/contracts/erc20_liquidity_pool.rb'
require 'rubidity/contracts/erc721.rb'
require 'rubidity/contracts/ether_erc20_bridge.rb'
require 'rubidity/contracts/ethscription_erc20_bridge.rb'
require 'rubidity/contracts/generative_erc721.rb'
require 'rubidity/contracts/open_edition_erc721.rb'
require 'rubidity/contracts/public_mint_erc20.rb'


puts "bye"
