###
#  to run use
#     ruby -I ./lib -I ./test test/test_inscribes.rb


require 'helper'


class TestInscribes < Minitest::Test

def test_erc20
  ## tx 0xc67fcf47748a9bb14ace0b6439cb981b9a36af13ccba3c826c56263ab57ea50c
  ##
  data_uri = %Q<data:,{"p":"erc-20","op":"mint","tick":"eths","id":"16888","amt":"1000"}>
  hex  = "0x646174613a2c7b2270223a226572632d3230222c226f70223a226d696e74222c227469636b223a2265746873222c226964223a223136383838222c22616d74223a2231303030227d"

  data = Calldata.parse_data( data_uri )
  assert_equal 'erc-20', data[ 'p' ] 
  assert_equal 'mint', data[ 'op' ] 

  data = Calldata.parse_hex( hex )
  assert_equal 'erc-20', data[ 'p' ] 
  assert_equal 'mint', data[ 'op' ] 

end


end  # class TestInscribes
