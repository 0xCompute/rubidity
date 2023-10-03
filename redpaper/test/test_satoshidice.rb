##
#  to run use:
#    $ ruby test/test_satoshidice.rb

require_relative 'helper'

require_relative '../satoshidice'



class TestSathoshiDice < MiniTest::Test     

  STATE_ZERO = {
        :owner=>"0x0000000000000000000000000000000000000000",
        :counter=>0, 
        :bets=>{}
  }
       
  STATE_INIT = {
    :owner=>"0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
    :counter=>0, 
    :bets=>{}
  }

  STATE_ONE = {
    :owner=>"0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
    :counter=>1,
    :bets=>{
       1=>["0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb", 891, 1000, 100]
    }}

  STATE_TWO = {
    :owner=>"0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
    :counter=>2,
    :bets=>{
       1=>["0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb", 891, 1000, 100],
       2=>["0xcccccccccccccccccccccccccccccccccccccccc", 892, 10000, 200]
  }}


  def test_meta
    pp SathoshiDice.state_variable_definitions
    pp SathoshiDice.parent_contracts 
    pp SathoshiDice.events 
    pp SathoshiDice.is_abstract_contract
    
    abi = SathoshiDice.abi
    
    puts
    puts "public_abi:"
    pp SathoshiDice.public_abi    
  end

  def test_contract
    contract = SathoshiDice.new
    pp contract

    assert_equal STATE_ZERO, contract.serialize


    alice   = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
    bob     = '0x'+'b'*40 # e.g. '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
    charlie = '0x'+'c'*40 # e.g. '0xcccccccccccccccccccccccccccccccccccccccc'
    
    Simulacrum.msg.sender = alice    
    contract = SathoshiDice.construct

    assert_equal STATE_INIT, contract.serialize 


    Simulacrum.block.number = 888
    Simulacrum.msg.sender = bob
    Simulacrum.msg.value  = 100
    contract.bet( cap: 1000 )       ##  cap max. 65_536 = 2^16 = 2 byte/16 bit

    assert_equal STATE_ONE, contract.serialize 


    Simulacrum.block.number = 889
    Simulacrum.msg.sender = charlie
    Simulacrum.msg.value  = 200    
    contract.bet( cap: 10000 ) 
    
    assert_equal STATE_TWO, contract.serialize   
  end
end  # class TestSatoshiDice


