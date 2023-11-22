

require 'base64'   ## pull in base40 encode/decode (standard) module



## add/use global helpers - why? why not?

## hexdata encode/decode   (hex string NOT binary, utf8-encoded string)
##   utf8-to-hex, hex-to-utf8

def utf8_to_hex( str )  ## use bin to hex - why? why not?
    # str.unpack('U'*str.length).map {|b| b.to_s(16) }.join
    # str.unpack('H*').first
    ## note: 0 or 3 must be 00 or 03 with padding!!
    ##  or use rjust( 2, '0' ) - why? why not?
    # str.each_byte.map { |b| '%02x' % b }.join
    str.unpack('H*').first
end


def hex_to_utf8( str )  ## use hex to bin - why? why not?
    # str.scan(/../).map { |x| x.hex }.pack('c*')
    ## fix: will NOT work for multi-byte chars
    ## str.scan(/../).map { |x| x.hex.chr }.join

    ### cut-off optionial 0x/0X
    str = str[2..-1]   if str.start_with?( '0x' ) || str.start_with?( '0X') 
    
    ## note:  ethscriptios specifies that \u0000 
    ##             (that is, \x00 - 0 byte) gets deleted/removed (even if valid utf-8)
    ##         reason given:  0 byte in utf-8 messes up postgresql storage!

    [str].pack('H*').force_encoding( 'UTF-8' ).gsub( "\u0000", '' )
end


##
## move into call data (or keep as global helper) - why? why not?
##   check conflict with  hex/String#hex extension in hex/bytes gem??
def is_hex?( str )
    ### cut-off optionial 0x/0X
    str = str[2..-1]   if str.start_with?( '0x' ) || str.start_with?( '0X') 
    
    ## allow 0x/0X - that is zero? as valid - why? why not?
    return true    if str.empty?
 
    hexchars_match = str.match( /\A[0-9a-fA-F]{2,}\z/)
    
    ## note: a byte requires two hexchars (hexchars must be even!! 2,4,6,8,etc.)
    hexchars_match && str.length.even?
end



module Calldata
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

   def self.valid?( hex )  
      is_hex?( hex )
   end

   ## add alias convenience names - why? why not?
   class << self 
      alias_method :encode_utf8, :encode
      alias_method :decode_hex,  :decode
      alias_method :is_valid?,   :valid?
   end
end  # module Calldata




module DataUri
    REGEX = %r{
      \Adata:
      (?<mediatype>
        (?<mimetype> .+? / .+? )?
        (?<parameters> (?: ; .+? = .+? )* )
      )?
      (?<extension>;base64)?
      ,
      (?<data>.*)\z
    }x

    def self._parse( str ) REGEX.match( str ); end

    def self.parse( str )
        m = _parse( str ) 
  
        if m
          ## 1) return mediatype (mimetype PLUS optional parameters)
          ## 2) return data (base64 decoded or not)
  
          mediatype = m[:mediatype]  
          data      = if m[:extension]   ## assume base64 encoded
                         Base64.strict_decode64(m[:data])
                      else
                         m[:data]
                      end
          [mediatype, data]
        else
           raise ArgumentError, "invalid datauri - cannot match regex; sorry"
        end
    end


    def self.valid?( str )
      m = _parse( str )
      if m 
        if m[:extension]   ## assume base64
            begin
              Base64.strict_decode64(m[:data])
              true
            rescue ArgumentError
              false
            end
          else
            true
          end
      else
         false
      end
    end

    ## add alias convenience names - why? why not?
    class << self 
      alias_method :is_valid?,   :valid?
    end
end  # module  DataUri

