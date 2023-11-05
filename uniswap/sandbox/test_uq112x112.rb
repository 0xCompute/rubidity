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


def dump( num )
   print "  "
   print "dec: #{num}, "
   print "hex: #{num.to_s(16)},"
   ## print "bin: #{num.to_s(2)}"
   print "\n"
end

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



puts "bye"