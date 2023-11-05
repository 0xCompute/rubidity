# More Uniswap V2 Notes


## todos / read later

<https://jeiwan.net/posts/programming-defi-uniswapv2-1/>

<https://jeiwan.net/posts/programming-defi-uniswapv2-2/>


soure part2 <https://github.com/Jeiwan/zuniswapv2/tree/part_2>

<https://github.com/Jeiwan/zuniswapv2>

<https://github.com/mgarcia01752/Q-Number-Format>


## more

q-format converter / calculator / etc.

<https://chummersone.github.io/qformat.html#converter>



## v3

uniswap v3
<https://jeiwan.net/posts/uniswap-v3-development-book-is-out/>


## Precision - Math Calculations - UQ112.112

Because Solidity does not have first-class support for non-integer numeric data types, the Uniswap v2 uses a simple binary fixed point format to encode and manipulate prices.

Specifically, prices at a given moment are stored as UQ112.112 numbers, meaning that 112 fractional bits of precision 
are specified on either side of the decimal point, with no sign.
These numbers have a range of [0, 2^112 − 1] 
and a precision of 1 / 2^112.

<https://en.wikipedia.org/wiki/Q_(number_format)>


source:
<https://github.com/Uniswap/v2-core/blob/master/contracts/libraries/UQ112x112.sol>

```solidity
pragma solidity =0.5.16;

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
```
