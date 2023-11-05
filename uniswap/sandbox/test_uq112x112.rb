##
#  try uq112x112 calculations "stand-alone" for understanding / testing


=begin
// a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))

// range: [0, 2**112 - 1]
// resolution: 1 / 2**112

library UQ112x112 {
    uint224 constant Q112 = 2**112;

    // encode a uint112 as a UQ112x112
    function encode(uint112 y) internal pure returns (uint224 z) {
        z = uint224(y) * Q112; // never overflows
    }

    // divide a UQ112x112 by a uint112, returning a UQ112x112
    function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {
        z = x / uint224(y);
    }
}
=end

### 112 = 14 byte (14*8=112),  28 hex chars!!

## 0x00 00 00 00 00 00 00 00 00 00 00 00 00 00


Q112 = 2**112
def encode( y )  y*Q112; end

#  divide a UQ112x112 by a uint112, returning a UQ112x112
# (uint224 x, uint112 y)  returns (uint224 z)
#
#  check if  uint224(y) needs to bitshift y or can stay as is?
##   use Integer.div here - why? why not? any differance from /???
def uqdiv( x, y )  x / y; end


def dump( num )
   print "  "
   print "dec: #{num}, "
   print "hex: #{num.to_s(16)},"
   ## print "bin: #{num.to_s(2)}"
   print "\n"
end




require_relative '../lib/uniswap/uq112x112'


puts "Q112: #{Q112}"

a = 1
b = 112
c = 4

puts "a:"
dump( a )
dump( encode( a ))

puts "b:"
dump( b )
dump( encode( b ))

puts "c:"
dump( c )
dump( encode( c ))

puts "b/8:"
b8 = uqdiv( encode(b), 8 )
dump( b8 )
pp UQ112x112.new( b8 )
pp b/8.0

puts "b/2:"
b2 = uqdiv( encode(b), 2 )
dump( b2 )
b2uq =  UQ112x112.new( b2 )
pp b2uq
pp b2uq.to_s 
pp b/2.0

puts "b/3:"
b3 = uqdiv( encode(b), 3 )
dump( b3 )
pp UQ112x112.new( b3 )
pp b/3.0


puts "---"
auq = UQ112x112.new( encode(a) )
pp auq
pp auq.to_s
pp UQ112x112.new( encode(b) )
pp UQ112x112.new( encode(c) )



puts
puts "---"
b = UQ112x112.encode( 112 )
pp b
pp b.to_hex
pp b.to_s
b3 = b.div( 3 )
pp b3
pp b3.to_hex
pp b3.to_s
pp b / 3
pp 112 / 3.0 


b = UQ112x112.encode( 1111111111 )
pp b
pp b.to_hex
pp b.to_s
b3 = b.div( 333 )
pp b3
pp b3.to_hex
pp b3.to_s
pp b / 333
pp 1111111111 / 333.0

bb3 = b3 + b3
pp bb3
pp 1111111111 / 333.0 * 2
bb3 = b3 * 2
pp bb3

puts "bye"