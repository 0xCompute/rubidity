##
#  to run use
#     ruby -I ./lib -I ./test test/test_types.rb


require 'helper'



class TestTypes < MiniTest::Test


def test_create
    t = Type.create( :string )
    pp t

    assert_equal StringType.instance, t
    assert_equal 'string', t.format
    assert_equal true, t.string?
    assert_equal true, t.is_a?( StringType )
    assert_equal true, t.is_value_type?
    assert_equal true, t.is_a?( ValueType )

    assert_equal ''.freeze, t.zero
  
    t2 = Type.create( :string )
    pp t
    pp t2

    assert_equal t.class, t2.class
    assert_equal t.format, t2.format
    assert       t == t2
    assert      !t != t2
end

def test_address
    a1 = Type.create( :address )
    pp a1
    a2 = Type.create( :address )
    pp a2

    assert_equal a1.class, a2.class
    assert_equal a1.format, a2.format
    assert       a1 == a2
    assert      !a1 != a2

    puts a1.inspect
    puts a2.inspect
    assert_equal a1, a2
end
end   # class TestTypes

