
require 'datauris'    ##  e.g. first pull-in zero-dependeny gem incl. DataUri.parse/build helpers  incl. base64 

require 'cocos'       ##  e.g. read/write_blob/json etc.


## our own code
require_relative 'calldata/version'    # let version go first



## add/use global helpers - why? why not?

## hexdata encode/decode   (hex string NOT binary, utf8-encoded string)
##   utf8-to-hex, hex-to-utf8

def utf8_to_hex( utf8 )  ## use bin_to_hex - why? why not?
    utf8.unpack('H*').first
end


def hex_to_utf8( hex )  ## use hex_to_bin - why? why not?
    ### cut-off optionial 0x/0X
    hex = hex[2..-1]   if hex.start_with?( '0x' ) || hex.start_with?( '0X' ) 
    
    ## note:  ethscriptions specifies that \u0000 
    ##             (that is, \x00 - 0 byte) gets deleted/removed (even if valid utf-8)
    ##         reason given:  0 byte in utf-8 messes up postgresql storage!

    ## fix-fix-fix - todo: add support for cleanup / fix corrup utf8 encoding - why? why not?
    ##   unless utf8_string.valid_encoding?
    ##     utf8_string = utf8_string.encode('UTF-8', 
    ##                           invalid: :replace, 
    ##                           undef: :replace, 
    ##                           replace: "\uFFFD")
    ##   end
    ##    check what's the replace char -> "\uFFFD"         

    # note: about string#delete
    #   Returns a copy of str with all characters of its arguments deleted. 
    #   Uses the same rules for building the set of characters as String#count.

    [hex].pack('H*').force_encoding( 'UTF-8' ).delete( "\u0000" )
end



##
## note: change Calldata to a base class with concrete/subclasses!!

class Calldata
   def self.encode( utf8 )
     raise TypeError, "Calldata.encode - String expected; got #{utf8.inspect} : #{utf8.class.name}" unless utf8.is_a?( String )
     ## note: no 0x upfront for now - why? why not?
     utf8_to_hex( utf8 )      
   end
   
   def self.decode( hex )
      raise TypeError, "Calldata.decode - String expected; got #{hex.inspect} : #{hex.class.name}"  unless hex.is_a?( String )
      raise ArgumentError, "Calldata.decode - hexstring expected; got #{hex}"   unless valid_hex?( hex )
      ## todo/check -  add a regex/format check here - why? why not?
      ##  must be string and hexchars only (0x/0X)
      hex_to_utf8( hex )
   end


   HEXCHARS_RX = /\A[0-9a-fA-F]{2,}\z/
     
   def self.valid_hex?( hex )  
      ### cut-off optionial 0x/0X
      hex = hex[2..-1]   if hex.start_with?( '0x' ) || hex.start_with?( '0X') 
   
      ## allow 0x/0X - that is zero? as valid - why? why not?
      return true    if hex.empty?

      match = HEXCHARS_RX.match( hex)
   
      ## note: a byte requires two hexchars (hexchars must be even!! 2,4,6,8,etc.)
      ##   enforce this even requirement - why? why not?
      ##    or turn a into a0 and  0 int 00 and so on - why? why not?
      match && hex.length.even?
   end

 
   ## add alias convenience names - why? why not?
   class << self 
      alias_method :encode_utf8, :encode
      alias_method :decode_hex,  :decode
      alias_method :is_hex?,     :valid_hex?
      alias_method :hex?,        :valid_hex?  
   end
end  # class Calldata



## more of our own code
require_relative 'calldata/parser'




puts   Calldata.banner    ## say hello