###
#  to run use
#    $ ruby -I ./lib -I ./test test/test_classic.rb


require 'helper'


class TestClassic < Minitest::Test


def test_mozilla
   # The text/plain data Hello, World!.
   # Note how the comma is URL encoded as %2C, and the space character as %20.
   uri = "data:,Hello%2C%20World%21"
   assert DataUri.valid?( uri )  
   
   data, mediatype  = DataUri.parse( uri )
   assert_equal "", mediatype
   assert_equal "Hello, World!", data


   # base64-encoded version of the above
   uri = "data:text/plain;base64,SGVsbG8sIFdvcmxkIQ=="
   assert DataUri.valid?( uri )  
   
   data, mediatype = DataUri.parse( uri )
   assert_equal "text/plain", mediatype
   assert_equal "Hello, World!", data
  

   # An HTML document with <h1>Hello, World!</h1>
   uri = "data:text/html,%3Ch1%3EHello%2C%20World%21%3C%2Fh1%3E"
   assert DataUri.valid?( uri )  
   
   data, mediatype = DataUri.parse( uri )
   assert_equal "text/html", mediatype
   assert_equal "<h1>Hello, World!</h1>", data
   

   # An HTML document with <script>alert('hi');</script> 
   #  that executes a JavaScript alert. 
   # Note that the closing script tag is required.
   uri = "data:text/html,%3Cscript%3Ealert%28%27hi%27%29%3B%3C%2Fscript%3E"
   assert DataUri.valid?( uri )  
   
   data, mediatype = DataUri.parse( uri )
   assert_equal "text/html", mediatype
   assert_equal "<script>alert('hi');</script>", data  
end



def test_rfc2397
   uri = "data:,A%20brief%20note"
   assert DataUri.valid?( uri )  
   
   data, mediatype = DataUri.parse( uri )
   assert_equal "", mediatype
   assert_equal "A brief note", data


   uri = "data:image/gif;base64,R0lGODdhMAAwAPAAAAAAAP///ywAAAAAMAAwAAAC8IyPqcvt3wCcDkiLc7C0qwyGHhSWpjQu5yqmCYsapyuvUUlvONmOZtfzgFzByTB10QgxOR0TqBQejhRNzOfkVJ+5YiUqrXF5Y5lKh/DeuNcP5yLWGsEbtLiOSpa/TPg7JpJHxyendzWTBfX0cxOnKPjgBzi4diinWGdkF8kjdfnycQZXZeYGejmJlZeGl9i2icVqaNVailT6F5iJ90m6mvuTS4OK05M0vDk0Q4XUtwvKOzrcd3iq9uisF81M1OIcR7lEewwcLp7tuNNkM3uNna3F2JQFo97Vriy/Xl4/f1cf5VWzXyym7PHhhx4dbgYKAAA7"
   assert DataUri.valid?( uri )  
   
   data, mediatype = DataUri.parse( uri )
   assert_equal "image/gif", mediatype
   pp data
   write_blob( "./tmp/larry.gif", data )

  ###
  ## fix - ArgumentError: invalid %-encoding (%be%fg%be)
  ##   ruby/3.2.0/uri/common.rb:370:in `_decode_uri_component'
   
=begin
  # can be used for a short sequence of greek characters 
   uri = "data:text/plain;charset=iso-8859-7,%be%fg%be"
   assert DataUri.valid?( uri )  
   
   data, mediatype = DataUri.parse( uri )
   assert_equal "text/plain;charset=iso-8859-7", mediatype
   ## fix-fix-fix  - change the carset encoding of data!!!
   pp data
   pp data.encoding
=end 
   
  uri = "data:application/vnd-xxx-query,select_vcount,fcol_from_fieldtable/local"
  assert DataUri.valid?( uri )  
   
  data, mediatype = DataUri.parse( uri )
  assert_equal "application/vnd-xxx-query", mediatype
  assert_equal "select_vcount,fcol_from_fieldtable/local", data
end


def test_wikipedia

   ###
   # example no. 1
   uri = "data:text/vnd-example+xyz;foo=bar;base64,R0lGODdh"

   assert DataUri.valid?( uri )  
   
   data, mediatype = DataUri.parse( uri )
   assert_equal 'text/vnd-example+xyz;foo=bar', mediatype
   pp data
   assert_equal "GIF87a", data

   ###
   # example no. 2
   uri = "data:text/plain;charset=UTF-8;page=21,the%20data:1234,5678"
   assert DataUri.valid?( uri )  
   
   data, mediatype = DataUri.parse( uri )
   assert_equal 'text/plain;charset=UTF-8;page=21', mediatype
   pp data
   assert_equal "the data:1234,5678", data

   ###
   # example no. 3
   #  invalid base64  --  add / at end to make valid!!!
      uri = "data:image/jpeg;base64,/9j/4AAQSkZJRgABAgAAZABkAAD/"
   assert DataUri.valid?( uri )  
   
   data, mediatype = DataUri.parse( uri )
   assert_equal 'image/jpeg', mediatype
   pp data
   assert_equal "\xFF\xD8\xFF\xE0\x00\x10JFIF\x00\x01\x02\x00\x00d\x00d\x00\x00\xFF".b, data


   ###
   # web examples
   # - html - An HTML fragment embedding a picture of a small red dot
   
    uri = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==" 
    assert DataUri.valid?( uri )  
   
    data, mediatype = DataUri.parse( uri )
    assert_equal 'image/png', mediatype
    pp data
    write_blob( "./tmp/reddot.png", data )

   # - css - A Cascading Style Sheets (CSS) rule that includes a background image
   uri = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQAQMAAAAlPW0iAAAABlBMVEUAAAD///+l2Z/dAAAAM0lEQVR4nGP4/5/h/1+G/58ZDrAz3D/McH8yw83NDDeNGe4Ug9C9zwz3gVLMDA/A6P9/AFGGFyjOXZtQAAAAAElFTkSuQmCC"
   assert DataUri.valid?( uri )  
   
    data, mediatype = DataUri.parse( uri )
    assert_equal 'image/png', mediatype
    pp data
    write_blob( "./tmp/background.png", data )

    # - js - A JavaScript statement that opens an embedded subwindow, as for a footnote link
    js = '<!DOCTYPE html>'+
    '<html lang="en">'+
    '<head><title>Embedded Window</title></head>'+
    '<body><h1>42</h1></body>'+
    '</html>' 
    uri = "data:text/html;charset=utf-8," +
               URI.encode_uri_component( js ) # Escape for URL formatting
        
    data, mediatype = DataUri.parse( uri )
    assert_equal 'text/html;charset=utf-8', mediatype
    assert_equal js, data

    # - svg - A Scalable Vector Graphic image containing an embedded JPEG image 
    #         encoded in Base64
    uri = "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDADIiJSwlHzIsKSw4NTI7S31RS0VFS5ltc1p9tZ++u7Kfr6zI4f/zyNT/16yv+v/9////////wfD/////////////2wBDATU4OEtCS5NRUZP/zq/O////////////////////////////////////////////////////////////////////wAARCAAYAEADAREAAhEBAxEB/8QAGQAAAgMBAAAAAAAAAAAAAAAAAQMAAgQF/8QAJRABAAIBBAEEAgMAAAAAAAAAAQIRAAMSITEEEyJBgTORUWFx/8QAFAEBAAAAAAAAAAAAAAAAAAAAAP/EABQRAQAAAAAAAAAAAAAAAAAAAAD/2gAMAwEAAhEDEQA/AOgM52xQDrjvAV5Xv0vfKUALlTQfeBm0HThMNHXkL0Lw/swN5qgA8yT4MCS1OEOJV8mBz9Z05yfW8iSx7p4j+jA1aD6Wj7ZMzstsfvAas4UyRHvjrAkC9KhpLMClQntlqFc2X1gUj4viwVObKrddH9YDoHvuujAEuNV+bLwFS8XxdSr+Cq3Vf+4F5RgQl6ZR2p1eAzU/HX80YBYyJLCuexwJCO2O1bwCRidAfWBSctswbI12GAJT3yiwFR7+MBjGK2g/WAJR3FdF84E2rK5VR0YH/9k="

    data, mediatype = DataUri.parse( uri )
    assert_equal 'image/jpeg', mediatype
    pp data
    write_blob( "./tmp/visual.jpeg", data )
end

end   # class TestClassic

