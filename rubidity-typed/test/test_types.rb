##
#  to run use
#     ruby -I ./lib -I ./test test/test_types.rb


require 'helper'



class TestTypes < MiniTest::Test


def test_create
    t = Type.create( :string )
    pp t

    assert_equal StringType.instance, t
    assert_equal :string, t.name
    assert_equal 'string', t.format
    assert_equal true, t.string?
    assert_equal true, t.is_a?( StringType )
    assert_equal true, t.is_value_type?
    assert_equal true, t.is_a?( ValueType )

    assert_equal ''.freeze, t.zero
    assert_equal ''.freeze, t.default_value
end
end   # class TestTypes

