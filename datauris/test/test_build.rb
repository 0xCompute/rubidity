###
#  to run use
#    $ ruby -I ./lib -I ./test test/test_build.rb

require 'helper'


class TestBuild < Minitest::Test


def test_gif

    bin = "GIF89a\001\000\001\000\200\000\000\377\377\377\000\000\000!\371\004\000\000\000\000\000,\000\000\000\000\001\000\001\000\000\002\002D\001\000;".b
  
    # given data and an explicit content_type
    uri = DataUri.build( bin, 'image/gif' ) 
    assert_equal "data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==", uri
end 

def test_simple
   # given data and no content_type" do
    uri = DataUri.build( "foobar" )
    pp uri
    assert_equal "data:,foobar", uri 

    uri = DataUri.build( "foobar", base64: true ) 
    pp uri
    assert_equal "data:;base64,Zm9vYmFy", uri
end

end  # class TestBuild




__END__

## to be done - reuse spec from old gem


describe "building" do

    before do
      @data = "GIF89a\001\000\001\000\200\000\000\377\377\377\000\000\000!\371\004\000\000\000\000\000,\000\000\000\000\001\000\001\000\000\002\002D\001\000;"
    end

    it "given data and an explicit content_type" do
      uri = URI::Data.build(:content_type => 'image/gif', :data => StringIO.new(@data))
      uri.to_s.must_equal 'data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw=='
    end

    it "given data with an implicit content_type" do
      io = StringIO.new(@data)
      (class << io; self; end).instance_eval { attr_accessor :content_type }
      io.content_type = 'image/gif'
      uri = URI::Data.build(:data => io)
      uri.to_s.must_equal 'data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw=='
    end

    it "given data and no content_type" do
      io = StringIO.new("foobar")
      uri = URI::Data.build(:data => io)
      uri.to_s.must_equal 'data:;base64,Zm9vYmFy'
    end

  end