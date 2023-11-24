
require 'datauris'    ##  e.g. first pull-in zero-dependeny gem incl. DataUri.parse/build helpers  incl. base64 

require 'cocos'       ##  e.g. read/write_blob/json etc.




## add/use global helpers - why? why not?

## hexdata encode/decode   (hex string NOT binary, utf8-encoded string)
##   utf8-to-hex, hex-to-utf8

def utf8_to_hex( utf8 )  ## use bin to hex - why? why not?
    # str.unpack('U'*str.length).map {|b| b.to_s(16) }.join
    # str.unpack('H*').first
    ## note: 0 or 3 must be 00 or 03 with padding!!
    ##  or use rjust( 2, '0' ) - why? why not?
    # str.each_byte.map { |b| '%02x' % b }.join
    utf8.unpack('H*').first
end


def hex_to_utf8( hex )  ## use hex to bin - why? why not?
    # str.scan(/../).map { |x| x.hex }.pack('c*')
    ## fix: will NOT work for multi-byte chars
    ## str.scan(/../).map { |x| x.hex.chr }.join

    ### cut-off optionial 0x/0X
    hex = hex[2..-1]   if hex.start_with?( '0x' ) || hex.start_with?( '0X') 
    
    ## note:  ethscriptios specifies that \u0000 
    ##             (that is, \x00 - 0 byte) gets deleted/removed (even if valid utf-8)
    ##         reason given:  0 byte in utf-8 messes up postgresql storage!

    [hex].pack('H*').force_encoding( 'UTF-8' ).gsub( "\u0000", '' )
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
      raise ArgumentError, "Calldata.decode - hexstring expected; got #{hex}"   unless valid?( hex )
      ## todo/check -  add a regex/format check here - why? why not?
      ##  must be string and hexchars only (0x/0X)
      hex_to_utf8( hex )
   end


   HEXCHARS_RX = /\A[0-9a-fA-F]{2,}\z/
     
   def self.valid?( hex )  
      ### cut-off optionial 0x/0X
      hex = hex[2..-1]   if hex.start_with?( '0x' ) || hex.start_with?( '0X') 
   
      ## allow 0x/0X - that is zero? as valid - why? why not?
      return true    if hex.empty?

      match = HEXCHARS_RX.match( hex)
   
      ## note: a byte requires two hexchars (hexchars must be even!! 2,4,6,8,etc.)
      match && hex.length.even?
   end


   ## add alias convenience names - why? why not?
   class << self 
      alias_method :encode_utf8, :encode
      alias_method :decode_hex,  :decode
      alias_method :is_valid?,   :valid?
      alias_method :is_hex?,     :valid?
      alias_method :hex?,        :valid?
   end
end  # class Calldata

