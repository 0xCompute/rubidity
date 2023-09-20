require_relative 'helper'


## pull in contract one-by-one for now (later auto-load ALL!)

require 'rubidity/contracts/erc20'


pp ERC20
puts
pp ERC20.public_abi
puts
pp ERC20.state_variable_definitions
puts
pp ERC20.parent_contracts

require 'rubidity/contracts/public_mint_erc20'


pp PublicMintERC20
puts
pp PublicMintERC20.public_abi
puts
pp PublicMintERC20.state_variable_definitions
puts
pp PublicMintERC20.parent_contracts


contract = PublicMintERC20.create
pp contract

=begin
 constructor(
    name: :string,
    symbol: :string,
    maxSupply: :uint256,
    perMintLimit: :uint256,
    decimals: :uint256
  ) {
    ERC20(name: name, symbol: symbol, decimals: decimals)
    s.maxSupply = maxSupply
    s.perMintLimit = perMintLimit
  }
 
=end

contract.constructor(
    name: 'My Fun Token', # :string,
    symbol: 'FUN',        # :string,
    maxSupply:  21000000,  #  :uint256,
    perMintLimit: 1000,    #  :uint256,
    decimals:     18,      #  :uint256
  ) 

__END__

state = contract.serialize
pp state
=begin
{:name=>"My Fun Token",
 :symbol=>"FUN",
 :decimals=>18,
 :totalSupply=>0,
 :balanceOf=>{},
 :allowance=>{},
 :maxSupply=>21000000,
 :perMintLimit=>1000}
=end


alice   = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
bob     = '0x'+'b'*40 # e.g. '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
charlie = '0x'+'c'*40 # e.g. '0xcccccccccccccccccccccccccccccccccccccccc'

pp alice
pp bob
pp charlie


## 
#   function :mint, { amount: :uint256 }, :public  
contract.msg.sender = alice
pp contract.msg.sender

contract.mint( 100 )
contract.mint( 200 )


contract.msg.sender = bob
pp contract.msg.sender

contract.mint( 300 )
contract.mint( 400 )

state = contract.serialize
pp state

##
#  function :airdrop, { to: :addressOrDumbContract, amount: :uint256 }, :public
contract.airdrop( alice, 500 )
contract.airdrop( charlie, 600  )

state = contract.serialize
pp state

=begin
{:name=>"My Fun Token",
 :symbol=>"FUN",
 :decimals=>18,
 :totalSupply=>2100,
 :balanceOf=>
  {"0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"=>800,
   "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"=>700,
   "0xcccccccccccccccccccccccccccccccccccccccc"=>600},
 :allowance=>{},
 :maxSupply=>21000000,
 :perMintLimit=>1000}
=end


###
#   function :transfer, { to: :addressOrDumbContract, amount: :uint256 }, :public, :virtual, returns: :bool
contract.transfer( alice, 1  )
contract.transfer( charlie, 2  )

###
#   function :approve, { spender: :addressOrDumbContract, amount: :uint256 }, :public, :virtual, returns: :bool do
contract.approve( alice, 11 )
contract.approve( charlie, 22 )


##
# function :transferFrom, {
#  from: :addressOrDumbContract,
#  to: :addressOrDumbContract,
#  amount: :uint256
# }, :public, :virtual, returns: :bool

contract.msg.sender = alice
pp contract.msg.sender

contract.approve( bob, 33 )

contract.transferFrom( bob, charlie, 3 )
contract.transferFrom( bob, alice, 4 )

state = contract.serialize
pp state


##
# try reverse - deserialize/load

contract.deserialize( state )
pp contract.serialize

puts "bye"