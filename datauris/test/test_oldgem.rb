###
#  to run use
#    $ ruby -I ./lib -I ./test test/test_oldgem.rb

##
## reuse/try the test from the data-uri gem
##  https://github.com/dball/data_uri/blob/master/test/test_data_uri.rb


require 'helper'


class TestOldGem < Minitest::Test

  # a base64 encoded image/gif data URI
  def test_gif
     base64 = "R0lGODlhAQABAIABAAAAAP///yH5BAEAAAEALAAAAAABAAEAQAICTAEAOw=="
     uri    = "data:image/gif;base64,#{base64}"
 
     ## "should parse as a URI::Data object
     assert   DataUri.valid?( uri )

     mediatype, data = DataUri.parse( uri )
     assert_equal 'image/gif', mediatype            ## should have a content_type of image/gif
     assert_equal Base64.strict_decode64( base64 ), data   ## should have data
  end    

  # a text/plain data URI
  def test_text
     uri = "data:,A%20brief%20note"

     ## "should parse as a URI::Data object
     assert   DataUri.valid?( uri )

     mediatype, data = DataUri.parse( uri )
 
     ## should have a content_type of text/plain - fix - add default if empty - why? why not?
     assert_equal '', mediatype    # 'text/plain'
     assert_equal 'A brief note',  data
  end

  # a text/html data URI with a charset" do
   def test_html  
      uri = "data:text/html;charset=utf-8,%3C%21DOCTYPE%20html%3E%0D%0A%3Chtml%20lang%3D%22en%22%3E%0D%0A%3Chead%3E%3Ctitle%3EEmbedded%20Window%3C%2Ftitle%3E%3C%2Fhead%3E%0D%0A%3Cbody%3E%3Ch1%3E42%3C%2Fh1%3E%3C%2Fbody%3E%0A%3C%2Fhtml%3E%0A%0D%0A"

      ## "should parse as a URI::Data object
      assert   DataUri.valid?( uri )

      mediatype, data = DataUri.parse( uri )
      # should have a content_type of text/html" - fix - incl. parameters - why? why not?
      assert_equal 'text/html;charset=utf-8', mediatype    
      assert_equal "<!DOCTYPE html>\r\n<html lang=\"en\">\r\n<head><title>Embedded Window</title></head>\r\n<body><h1>42</h1></body>\n</html>\n\r\n", data
  end

  # a big data binary data URI
  def test_big
     bin = Array.new(100000) { rand(256) }.pack('c*')
     uri = "data:application/octet-stream;base64,#{Base64.strict_encode64(bin)}"
     pp uri

      ## "should parse as a URI::Data object
      assert   DataUri.valid?( uri )

      mediatype, data = DataUri.parse( uri )
      assert_equal 'application/octet-stream', mediatype    
      assert_equal bin, data
 end


  # an invalid data URI
  def test_error    
    assert_raises ArgumentError do 
      DataUri.parse( "This is not a data URI" ) 
    end
    assert_raises ArgumentError do 
      DataUri.parse( "data:Neither this" ) 
    end
 end
end   # class TestOldGem

