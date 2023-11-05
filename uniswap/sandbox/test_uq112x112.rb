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


class UQ112x112
    def initialize( num )
       @num = num
    end

    Q112 = 2**112

    def pretty_print( printer ) 
        ## quotient / remainder  ( int / frac )
        int, frac  =   @num.divmod( Q112 ) 
        
        ## convert frac to double here - how???
        

        printer.text( "<val uq112x112: #{int} x #{frac}, hex: #{@num.to_s(16)}>" )
    end
end    # class UQ112x112



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
pp UQ112x112.new( b2 )
pp b/2.0

puts "b/3:"
b3 = uqdiv( encode(b), 3 )
dump( b3 )
pp UQ112x112.new( b3 )
pp b/3.0


puts "---"
pp UQ112x112.new( encode(a) )
pp UQ112x112.new( encode(b) )
pp UQ112x112.new( encode(c) )


puts "bye"