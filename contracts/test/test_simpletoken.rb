##
#  to run use:
#    $ ruby test/test_simpletoken.rb

require_relative 'helper'

require_relative '../simpletoken'



class TestSimpleToken < MiniTest::Test     

  STATE_ZERO = {
    :name=>"", 
    :symbol=>"", 
    :maxSupply=>0, 
    :perMintLimit=>0, 
    :totalSupply=>0, 
    :balanceOf=>{}}

   STATE_INIT = {
      :name=>"My Fun Token", 
      :symbol=>"FUN", 
      :maxSupply=>21000000, 
      :perMintLimit=>1000, 
      :totalSupply=>0, :balanceOf=>{}}

  STATE_ONE = {
      :name=>"My Fun Token",
      :symbol=>"FUN",
      :maxSupply=>21000000,
      :perMintLimit=>1000,
      :totalSupply=>1610,
      :balanceOf=>{
        "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"=>1100, 
        "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"=>510}}

  STATE_TWO = {
      :name=>"My Fun Token",
      :symbol=>"FUN",
      :maxSupply=>21000000,
      :perMintLimit=>1000,
      :totalSupply=>1610,
      :balanceOf=> {
        "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"=>989,
        "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"=>499,
        "0xcccccccccccccccccccccccccccccccccccccccc"=>122}}

  def test_meta
    pp SimpleToken.state_variable_definitions
    pp SimpleToken.parent_contracts 
    pp SimpleToken.events 
    pp SimpleToken.is_abstract_contract
    
    abi = SimpleToken.abi
    
    puts
    puts "public_abi:"
    pp SimpleToken.public_abi    
  end

  def test_contract
    contract = SimpleToken.create
    pp contract

    assert_equal STATE_ZERO, contract.serialize

    ###
    # double check zero init values machinery
    assert_equal TypedString.zero, TypedString.new
    assert_equal TypedString.zero, TypedString.new('')
    assert_equal TypedUint256.zero, TypedUint256.new
    assert_equal TypedUint256.zero, TypedUint256.new(0)

    assert_equal TypedString.zero, contract.name  ## call public function
    assert_equal TypedString.zero, contract.symbol ## call public function
    assert_equal TypedUint256.zero, contract.maxSupply ## call public function
 
    pp contract.instance_variable_get( :@name )
    pp contract.instance_variable_get( :@symbol )
    pp contract.instance_variable_get( :@maxSupply )
    pp contract.instance_variable_get( :@perMintLimit )
    pp contract.instance_variable_get( :@balanceOf )
 

    contract.constructor(
      name: 'My Fun Token', # string
      symbol: 'FUN', # string
      maxSupply: 21000000, # uint256
      perMintLimit: 1000   # uint256
    ) 

    assert_equal STATE_INIT, contract.serialize 

    contract.deserialize( STATE_ZERO )
    assert_equal STATE_ZERO, contract.serialize

    contract.deserialize( STATE_INIT )
    assert_equal STATE_INIT, contract.serialize

    pp contract.instance_variable_get( :@name )
    pp contract.instance_variable_get( :@symbol )
    pp contract.instance_variable_get( :@maxSupply )
    pp contract.instance_variable_get( :@perMintLimit )
    pp contract.instance_variable_get( :@balanceOf )
    
    
    pp contract.name 
    pp contract.symbol
    pp contract.maxSupply
    pp contract.totalSupply
    pp contract.perMintLimit
    #  mapping ({ addressOrDumbContract: :uint256 }), :public, :balanceOf
    # pp contract.balanceOf
    
    pp contract.serialize
    
      
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
    
    contract.mint( 1000 )   
    contract.mint( 100 )   
    
    contract.msg.sender = bob
    pp contract.msg.sender
    
    contract.mint( 500 )   
    contract.mint( 10 )   
    # contract.mint( 2000 )   
    
    
    
    pp contract.totalSupply
    pp contract.balanceOf( alice )
    
    state = contract.serialize
    pp state
    assert_equal STATE_ONE, state
  
    ##
    # function :transfer, { to: :addressOrDumbContract, amount: :uint256 }, :public
    contract.msg.sender = alice
    pp contract.msg.sender
    
    contract.transfer( to: bob, amount: 111 )
    contract.transfer( to: charlie, amount: 11 )
      
    contract.msg.sender = bob
    pp contract.msg.sender
    
    contract.transfer( to: alice, amount: 11 )
    contract.transfer( to: charlie, amount: 111 )
        
    
    pp contract.balanceOf( alice )
    pp contract.balanceOf( bob )
    pp contract.balanceOf( charlie )

    state = contract.serialize
    pp state
    assert_equal STATE_TWO, state
  end
end  # class TestSimpleToken


