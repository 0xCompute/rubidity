##
#  to run use
#     ruby -I ./lib -I ./test test/test_typeof.rb


require 'helper'



class TestTypeof < Minitest::Test


include Types

def test_typeof

    assert_equal Typed::BoolType.instance, typeof( Typed::BoolType.instance )
    assert_equal Typed::BoolType.instance, typeof( TrueClass )
    assert_equal Typed::BoolType.instance, typeof( FalseClass )
    assert_equal Typed::BoolType.instance, typeof( Bool )


    assert_equal Typed::UIntType.instance, typeof( Typed::UIntType.instance )
    assert_equal Typed::UIntType.instance, typeof( UInt )
end

end  # class TestTypeof

