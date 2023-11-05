
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


## rename to UQ112 - why? why not?
##    integer for now allows overflow in integer part
##     only fraction is fixed with 112 bit(s).


class UQ112x112
    Q112 = 2**112

    # encode a "normal" uint(112) as a UQ112x112
    def self.encode( y ) 
      new( y * Q112 )
    end

    def initialize( x )
       @x = x
    end

    def pretty_print( printer ) 
      printer.text( "<val uq112x112: #{to_s}, hex: #{to_hex}>" )
    end

    #  divide a UQ112x112 by a uint112, returning a UQ112x112
    # (uint224 x, uint112 y)  returns (uint224 z)
    #
    #  check if  uint224(y) needs to bitshift y or can stay as is?
    ##   use Integer.div here - why? why not? any differance from /???
    def div( y ) 
       raise ArgumentError, "integer required for uq112x112 division; got #{y.inspect}" unless y.is_a?( Integer )
       UQ112x112.new( @x / y )
    end
    alias_method :/, :div

    def mul( y ) 
       raise ArgumentError, "integer required for uq112x112 multiplication; got #{y.inspect}" unless y.is_a?( Integer )
       UQ112x112.new( @x * y )
    end
    alias_method :*, :mul


    def add( y )
        raise ArgumentError, "uq112x112 required for uq112x112 addition; got #{y.inspect}" unless y.is_a?( UQ112x112 )
        UQ112x112.new( @x + y.instance_variable_get( :@x ) )
    end
    alias_method :+, :add

    ## add sub - not used in uniswap v2 - why? why not?
    def sub( y )
        raise ArgumentError, "uq112x112 required for uq112x112 subtraction; got #{y.inspect}" unless y.is_a?( UQ112x112 )
        UQ112x112.new( @x - y.instance_variable_get( :@x ) )
    end
    alias_method :-, :sub


    def to_hex
      ## start with 0x - why? why not?  
      '0x%056x' % @x
    end
    alias_method :hex, :to_hex

    def to_s
      ## return dec number as string - why? why not?
      ## quotient / remainder  ( int / frac )
      int, remainder  =  @x.divmod( Q112 ) 
      ## calc frac in decimal (use precision of 10**6) - why? why not?
      frac = remainder * 10**6 / Q112

      ## puts "  [debug] #{'%06d' % frac}  - #{frac} - #{remainder} * 10**6 / Q112"

      "#{int}.#{'%06d' % frac}"
    end
end    # class UQ112x112





