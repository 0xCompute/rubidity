##
#  to run use
#     ruby -I ./lib -I ./test test/test_zeros.rb


require 'helper'



class TestZeros < Minitest::Test


include Types

def test_zeros_mut_false
    assert_equal Address.zero, Address.type.zero
    assert_equal Address.zero, Address.new
    assert_equal Address.zero, Address.new( Typed::ADDRESS_ZERO )
    assert  Address.zero.is_a?( Address )
    assert  Address.zero.zero?
    assert  Address.new.zero?
    Address.new( Typed::ADDRESS_ZERO ).zero?
 
    assert_equal Bytes32.zero, Bytes32.type.zero
    assert_equal Bytes32.zero, Bytes32.new
    assert_equal Bytes32.zero, Bytes32.new( Typed::BYTES32_ZERO )
    assert  Bytes32.zero.is_a?( Bytes32 )
    assert  Bytes32.zero.zero?
    assert  Bytes32.new.zero?
    assert  Bytes32.new( Typed::BYTES32_ZERO ).zero?

    assert_equal String.zero, String.type.zero
    assert_equal String.zero, String.new
    assert_equal String.zero, String.new( '' )
    assert  String.zero.is_a?( String )
    assert  String.zero.zero?
    assert  String.new.zero?
    assert  String.new( '' ).zero?
    ##  support String to ::String compare ???
    ## assert  String.zero == ''
     
    assert_equal UInt.zero, UInt.type.zero
    assert_equal UInt.zero, UInt.new
    assert_equal UInt.zero, UInt.new( 0 )
    assert  UInt.zero.is_a?( UInt )
    assert  UInt.zero.zero?
    assert  UInt.new.zero?
    assert  UInt.new( 0 ).zero?
    assert  UInt.zero == 0
    ## todo - make fail (0 == 0.0 => true)? how?
    ##       not really possible? - why? why not?
    assert  UInt.zero == 0.0
 
    
    assert_equal true,  Bool.zero == Bool.type.zero
    assert_equal true,  Bool.zero == Bool.type.new( false )
    assert_equal true,  Bool.zero == false 
    assert  Bool.zero.is_a?( Bool )
    assert  Bool.zero.is_a?( FalseClass )
    assert  Bool.zero.zero?
    assert  Bool.type.new( false ).zero?
    assert  false.zero? 
end

end  # class TestZeros

