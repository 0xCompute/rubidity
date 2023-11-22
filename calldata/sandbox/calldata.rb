####
#  to run use:
#   $ ruby sandbox/calldata.rb


$LOAD_PATH.unshift( './lib' )
require 'calldata'



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
