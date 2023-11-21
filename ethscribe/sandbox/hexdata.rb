####
#  to run use:
#   $ ruby sandbox/hexdata.rb


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
    [str].pack('H*').force_encoding( 'UTF-8' )
end



hex = utf8_to_hex( "data:image/png;base64,..." )
pp hex
pp hex.encoding   ## change encoding to binary - why? why not? or asscii-7bit

utf8 = hex_to_utf8( hex )
pp utf8
pp utf8.encoding


puts "---"

pp hex = utf8_to_hex( "Hello, World!" )
pp utf8 = hex_to_utf8( hex )
pp utf8.encoding

puts "---"

pp hex = utf8_to_hex( "\x00\x03" )
pp utf8 = hex_to_utf8( hex )
pp utf8.encoding

puts "bye"
