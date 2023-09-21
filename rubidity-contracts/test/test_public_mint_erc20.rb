##
#  to run use:
#    $ ruby test/test_public_mint_erc20.rb


require_relative 'helper'


class TestPublicMintERC20 < MiniTest::Test
  
STATE_ZERO = {
  :name=>'',
  :symbol=>'',
  :decimals=>0,
  :totalSupply=>0,
  :balanceOf=>{},
  :allowance=>{},
  :maxSupply=>0,
  :perMintLimit=>0
}

STATE_INIT = {
  :name=>"My Fun Token",
  :symbol=>"FUN",
  :decimals=>18,
  :totalSupply=>0,
  :balanceOf=>{},
  :allowance=>{},
  :maxSupply=>21000000,
  :perMintLimit=>1000
}

STATE_ONE = {
  :name=>"My Fun Token",
  :symbol=>"FUN",
  :decimals=>18,
  :totalSupply=>2100,
  :balanceOf=>
   {"0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"=>800,
    "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"=>700,
    "0xcccccccccccccccccccccccccccccccccccccccc"=>600},
  :allowance=>{},
  :maxSupply=>21000000,
  :perMintLimit=>1000
}

STATE_TWO = {
 :name=>"My Fun Token",
 :symbol=>"FUN",
 :decimals=>18,
 :totalSupply=>2100,
 :balanceOf=>
  {"0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"=>805,
   "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"=>690,
   "0xcccccccccccccccccccccccccccccccccccccccc"=>605},
 :allowance=>
  {"0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"=> {
      "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"=>4, 
      "0xcccccccccccccccccccccccccccccccccccccccc"=>22},
   "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"=> {
      "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"=>33}},
 :maxSupply=>21000000,
 :perMintLimit=>1000
}


  def test_meta
    pp ERC20.state_variable_definitions
    pp ERC20.parent_contracts 
    pp ERC20.events 
    pp ERC20.is_abstract_contract
    
    abi = ERC20.abi
    
    puts
    puts "public_abi:"
    pp ERC20.public_abi    

    pp PublicMintERC20.state_variable_definitions
    pp PublicMintERC20.parent_contracts 
    pp PublicMintERC20.events 
    pp PublicMintERC20.is_abstract_contract
    
    abi = PublicMintERC20.abi
    
    puts
    puts "public_abi:"
    pp PublicMintERC20.public_abi    
  end

  def test_contract
    contract = PublicMintERC20.create
    pp contract
    

    assert_equal STATE_ZERO, contract.serialize

    contract.constructor(
        name: 'My Fun Token', # :string,
        symbol: 'FUN',        # :string,
        maxSupply:  21000000,  #  :uint256,
        perMintLimit: 1000,    #  :uint256,
        decimals:     18,      #  :uint256
      ) 
    
    state = contract.serialize
    pp state
    assert_equal STATE_INIT, state

    ###
    #  todo/check: use converter/cast functions - why? why not? 
    ##    string('My Fun Token')   or 'My Fun Token'.t  (for typed - why?)   
    ##    uint256( 210000000 )     or 210000000.uint   or 210000000.u ?? 
    assert_equal TypedString.new('My Fun Token'), contract.name
    assert_equal TypedString.new('FUN'),          contract.symbol
    assert_equal TypedUint256.new( 21000000),          contract.maxSupply
    assert_equal TypedUint256.new( 1000),          contract.perMintLimit
    assert_equal TypedUint256.new( 18 ),          contract.decimals
        
    assert_equal TypedString.new('My Fun Token'), contract.instance_variable_get( :@name )
    assert_equal TypedString.new('FUN'),          contract.instance_variable_get( :@symbol )
    assert_equal TypedUint256.new( 21000000),     contract.instance_variable_get( :@maxSupply )
    assert_equal TypedUint256.new( 1000),         contract.instance_variable_get( :@perMintLimit )
    assert_equal TypedUint256.new( 18 ),          contract.instance_variable_get( :@decimals )

    
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
assert_equal STATE_ONE, state


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

    ##
    # try reverse - deserialize/load
    state = contract.serialize
    pp state
    assert_equal STATE_TWO, state
    
    contract.deserialize( state )
    assert_equal state,  contract.serialize
  end
end  # class TestPublicMintERC20




