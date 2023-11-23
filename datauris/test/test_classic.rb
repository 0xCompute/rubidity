###
#  to run use
#    $ ruby -I ./lib -I ./test test/test_classic.rb


require 'helper'


class TestClassic < Minitest::Test

def test_wikipedia

   ###
   # example no. 1
   uri = "data:text/vnd-example+xyz;foo=bar;base64,R0lGODdh"

   assert DataUri.valid?( uri )  
   
   mediatype, data = DataUri.parse( uri )
   assert_equal 'text/vnd-example+xyz;foo=bar', mediatype
   pp data
   assert_equal "GIF87a", data

   ###
   # example no. 2
   uri = "data:text/plain;charset=UTF-8;page=21,the%20data:1234,5678"
   assert DataUri.valid?( uri )  
   
   mediatype, data = DataUri.parse( uri )
   assert_equal 'text/plain;charset=UTF-8;page=21', mediatype
   pp data
   assert_equal "the data:1234,5678", data

   ###
   # example no. 3
   #  invalid base64  --  add / at end to make valid!!!
      uri = "data:image/jpeg;base64,/9j/4AAQSkZJRgABAgAAZABkAAD/"
   assert DataUri.valid?( uri )  
   
   mediatype, data = DataUri.parse( uri )
   assert_equal 'image/jpeg', mediatype
   pp data
   assert_equal "\xFF\xD8\xFF\xE0\x00\x10JFIF\x00\x01\x02\x00\x00d\x00d\x00\x00\xFF".b, data
end

end   # class TestClassic

