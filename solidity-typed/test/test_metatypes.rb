##
#  to run use
#     ruby -I ./lib -I ./test test/test_metatypes.rb


require 'helper'



class TestMetatypes < Minitest::Test


include Types


def test_create
    t = Typed::StringType.instance
    pp t

    assert_equal 'string', t.format
    assert_equal true, t.is_a?( Typed::StringType )
    assert_equal true, t.is_a?( Typed::ValueType ) 

    assert_equal String.zero,  t.zero
  
    t2 = Typed::StringType.instance
    pp t
    pp t2

    assert_equal t.class, t2.class
    assert_equal t.format, t2.format
    assert       t == t2
    assert      !t != t2


    str = t.new( '' )   ## note: Type#new ALWAYS requires an (initial) value!!!
    assert_equal t, str.type

    str = t.new_zero
    assert_equal t, str.type
end



def test_address
    t = Typed::AddressType.instance
    a1 = t.new_zero.type
    a2 = t.new_zero.type

    assert_equal a1.class, a2.class
    assert_equal a1.format, a2.format
    assert       a1 == a2
    assert      !a1 != a2

    puts a1.inspect
    puts a2.inspect
    assert_equal a1, a2
end
end   # class TestMetatypes

