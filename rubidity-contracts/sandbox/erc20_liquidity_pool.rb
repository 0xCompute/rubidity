require_relative 'helper'


## pull in contract one-by-one for now (later auto-load ALL!)

require 'rubidity/contracts/erc20_liquidity_pool'


pp ERC20LiquidityPool
puts
pp ERC20LiquidityPool.public_abi
puts
pp ERC20LiquidityPool.state_variable_definitions


puts "bye"