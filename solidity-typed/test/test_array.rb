###
#  to run use
#     ruby -I ./lib -I ./test test/test_array.rb


require 'helper'


class TestArray < MiniTest::Test

  include Types


  Array_Int     = Array.new( Int )
  Array_Bool    = Array.new( Bool )

  ## multi-dimensional / nested  array
  Array_Array_Int = Array.new( Array_Int )

  ## "fixed" size
  Array_3_Int         = Array.new( Int, 3 )
  Array_Array_3x3_Int = Array.new( Array_3_Int, 3 )



def test_push_and_clear
  ary = Array_Int.new

  ## note: push returns array.size after adding new item
  ##   std ruby returns reference to array itself
  assert_equal 0, ary.size
  assert_equal 1, ary.push( 10 )
  assert_equal 1, ary.size

  assert_equal 2, ary.push( 20 )
  assert_equal 2, ary.size

  ary.clear
  assert_equal 0, ary.size
end

def test_integer
  pp Array_Int
  pp ary = Array_Int.new
  pp ary.length = 2

  assert_equal Typed::IntType.instance, Array_Int.type.sub_type
  assert_equal 0,       Array_Int.type.size
  assert_equal 0, ary[0]
  assert_equal 0, ary[1]

  ary[0] = 101
  ary[1] = 102
  assert_equal 101,  ary[0]
  assert_equal 102,  ary[1]

  assert_equal 2,     ary.size
  assert_equal 2,     ary.length
  assert_equal false, ary.frozen?

  ary.each { |item| pp item }
  ary.each_with_index { |item,i| puts "[#{i}] #{item}"}

  ary.size = 3
  assert_equal 3,     ary.size
  assert_equal 0,     ary[2]
  assert_equal false, Array_Int.zero == ary

  pp Array_Int.zero
  ## assert_equal true,  Array_Int.zero.frozen?
  assert_equal true,  Array_Int.zero == Array_Int.zero
  assert_equal true,  Array_Int.zero == Array_Int.new
  assert_equal true,  Array_Int.zero == Array_Int.type.new_zero

  ## check cached classes 
  assert_equal Array_Int,  Array.new( Int )
  assert_equal Array‹Int›, Array.new( Int )
end

def test_bool
  pp Array_Bool
  pp ary = Array_Bool.new
  ary.length = 2

  assert_equal Typed::BoolType.instance, Array_Bool.type.sub_type
  assert_equal 0,                        Array_Bool.type.size
  assert_equal false,  ary[0]
  assert_equal false,  ary[1]

  ary[0] = true
  ary[1] = true
  assert_equal true,  ary[0]
  assert_equal true,  ary[1]

  ## check cached classes
  assert_equal Array_Bool, Array.new( Bool )
  assert_equal Array‹Bool›, Array.new( Bool )
end


def test_array_new
    assert_equal true,  Array.is_a?( Class )

    ary = Array.new( Int )   
    assert_equal true,  ary.is_a?( Class )
    assert_equal false, ary.new.is_a?( Class )
end


def test_multi  # nested (multi-dimensional) array
   multi = Array_Array_Int.new
   multi.push( Array_Int.new )
   multi[0].push( 100 )
   multi[0].push( 200 )
   multi.push( Array_Int.new )
   multi[1].push( 300 )
   pp multi

   assert_equal 100, multi[0][0]
   assert_equal 200, multi[0][1]
   assert_equal 300, multi[1][0]

   multi[1].clear
   assert_equal 0, multi[1].size
   multi.clear
   assert_equal 0, multi.size

   ##############################################
   ## try Array.of convenience helper

   multi = Array.new( Array.new( Int ) ).new
   multi.push( Array.new( Int ).new )
   multi[0].push( 100 )
   multi[0].push( 200 )
   multi.push( Array.new( Int ).new )
   multi[1].push( 300 )
   pp multi

   assert_equal 100, multi[0][0]
   assert_equal 200, multi[0][1]
   assert_equal 300, multi[1][0]

   multi[1].clear
   assert_equal 0, multi[1].size
   multi.clear
   assert_equal 0, multi.size
end


def test_3x3  # nested (multi-dimensional) array
   board = Array_Array_3x3_Int.new
   pp board

   assert_equal Typed::IntType.instance, Array_3_Int.type.sub_type
   assert_equal 3,                       Array_3_Int.type.size

   assert_equal Array_3_Int.type, Array_Array_3x3_Int.type.sub_type
   assert_equal 3,                Array_Array_3x3_Int.type.size
  
   assert_equal 0, board[0][0]
   assert_equal 0, board[0][1]
   assert_equal 0, board[0][2]
   assert_equal 0, board[1][0]
   assert_equal 0, board[1][1]
   assert_equal 0, board[1][2]
   assert_equal 0, board[2][0]
   assert_equal 0, board[2][1]
   assert_equal 0, board[2][2]

   board[0][0] = 1
   board[0][1] = 2
   board[0][2] = 1
   board[1][0] = 2
   pp board

   assert_equal 1, board[0][0]
   assert_equal 2, board[0][1]
   assert_equal 1, board[0][2]
   assert_equal 2, board[1][0]

   board[0].clear
   pp board[0]
   assert_equal 3, board[0].size
   assert_equal 0, board[0][0]
   assert_equal 0, board[0][1]
   assert_equal 0, board[0][2]

   board.clear
   assert_equal 3, board.size
   assert_equal 3, board[0].size
   assert_equal 3, board[1].size
   assert_equal 3, board[2].size

   assert_equal 0, board[0][0]
   assert_equal 0, board[0][1]
   assert_equal 0, board[0][2]
   assert_equal 0, board[1][0]
   assert_equal 0, board[1][1]
   assert_equal 0, board[1][2]
   assert_equal 0, board[2][0]
   assert_equal 0, board[2][1]
   assert_equal 0, board[2][2]


   ##############################################
   ## try Array.of convenience helper

   board = Array.new( Array.new( Int, 3 ), 3 ).new
   pp board

   assert_equal 0, board[0][0]
   assert_equal 0, board[0][1]
   assert_equal 0, board[0][2]
   assert_equal 0, board[1][0]
   assert_equal 0, board[1][1]
   assert_equal 0, board[1][2]
   assert_equal 0, board[2][0]
   assert_equal 0, board[2][1]
   assert_equal 0, board[2][2]

   board[0][0] = 1
   board[0][1] = 2
   board[0][2] = 1
   board[1][0] = 2
   pp board

   assert_equal 1, board[0][0]
   assert_equal 2, board[0][1]
   assert_equal 1, board[0][2]
   assert_equal 2, board[1][0]
end
end # class TestArray
