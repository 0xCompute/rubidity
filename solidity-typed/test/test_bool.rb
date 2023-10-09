##
#  to run use
#     ruby -I ./lib -I ./test test/test_bool.rb


require 'helper'



class TestBool < MiniTest::Test


include Types

def test_bool
    assert  defined?( Bool )

    assert   TrueClass.ancestors.include?( Bool )
    assert   FalseClass.ancestors.include?( Bool )

    assert false.is_a?( Bool )
    assert true.is_a?( Bool )
    
    assert  false.zero? == true
    assert  true.zero?  == false
        
    assert_equal Typed::BoolType.instance,  false.type
    assert_equal Typed::BoolType.instance,  true.type
    
    ## same as
    assert_equal Typed::BoolType.instance,  false.class.type
    assert_equal Typed::BoolType.instance,  true.class.type
    
    assert_equal Typed::BoolType.instance,  TrueClass.type
    assert_equal Typed::BoolType.instance,  FalseClass.type
    
    assert false.as_data == false
    assert true.as_data == true
        
    assert false.type.new_zero == false
    assert true.type.new_zero == false
    
    assert false.type.new( true ) == true
    assert false.type.new( false ) == false
    
    assert true.type.new( true ) == true
    assert true.type.new( false ) == false
    
    assert_equal Typed::BoolType.instance, Bool.type
    assert       Bool.respond_to?( :type )
    
    
    assert  Bool.type.new( true )   == true
    assert  Bool.type.new( false )  == false
    assert  Bool.type.new_zero      == false    
end


end  # class TestBool