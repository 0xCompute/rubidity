# Uniswap V2 - Core (Dumb) Contracts (Rubidity Edition)


uniswap - core uniswap v2 (dumb) contracts for ruby (rubidity) for layer 1 (l1) with "off-chain" indexer



* home  :: [github.com/s6ruby/rubidity](https://github.com/s6ruby/rubidity)
* bugs  :: [github.com/s6ruby/rubidity/issues](https://github.com/s6ruby/rubidity/issues)
* gem   :: [rubygems.org/gems/uniswap](https://rubygems.org/gems/uniswap)
* rdoc  :: [rubydoc.info/gems/uniswap](http://rubydoc.info/gems/uniswap)


## What's Solidity?! What's Rubidity?!

See [**Solidity - Contract Application Binary Interface (ABI) Specification** »](https://docs.soliditylang.org/en/latest/abi-spec.html)

See [**Rubidity - Ruby for Layer 1 (L1) Contracts / Protocols with "Off-Chain" Indexer**  »](https://github.com/s6ruby/rubidity)



## What's Uniswap?! What's Facetswap?!

See the [**Uniswap V2 White Paper (PDF), March 2020**](https://uniswap.org/whitepaper.pdf) or
the [**Uniswap V2 Core Contracts (in Solidity)**](https://github.com/Uniswap/v2-core).

See the [**Facetswap App / Service**](https://facetswap.com) 
(running Uniswap V2 contracts in Rubidity).




## Usage

Available contracts include:

- [ERC20](lib/uniswap/ERC20.rb)
- [PublicMintERC20 (is ERC20)](lib/uniswap/PublicMintERC20.rb)
- [UniswapV2ERC20 (is ERC20)](lib/uniswap/UniswapV2ERC20.rb)
- [UniswapV2Pair (is UniswapV2ERC20)](lib/uniswap/UniswapV2Pair.rb)
- [UniswapV2Factory](lib/uniswap/UniswapV2Factory.rb)
- ...

And so on.  To be continued ...



## Aside - What is the binary fixed point UQ112.112 format (used for price calculations)? 

UQ112. 112 is basically an (unsigend) number that uses 112 bits 
for the fractional part and 112 for the integer part.

From the Uniswap V2 White Paper (on Precision):

> Because Solidity does not have first-class support 
> for non-integer numeric data types, the Uniswap v2 
> uses a simple binary fixed point format to encode and manipulate prices.
>
> Specifically, prices at a given moment are stored 
> as UQ112.112 numbers, meaning that 112 fractional bits of precision
> are specified on either side of the decimal point, 
> with no sign. These numbers 
> have a range of [0, 2^112 − 1 = 5192296858534827628530496329220096] 
> and a precision of 1 / 2^112 = 1 / 5192296858534827628530496329220096.

> 




## Bonus - More Blockchain (Crypto) Tools, Libraries & Scripts In Ruby

See [**/blockchain**](https://github.com/rubycocos/blockchain) 
at the ruby code commons (rubycocos) org.


## Questions? Comments?

Join us in the [Rubidity (community) discord (chat server)](https://discord.gg/3JRnDUap6y). Yes you can.
Your questions and commentary welcome.

Or post them over at the [Help & Support](https://github.com/geraldb/help) page. Thanks.

