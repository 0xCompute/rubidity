# Programming DeFi in Ruby: Uniswap V2. Part 2

written by Ivan Kuznetsov
([web / blog](https://jeiwan.net),
 [github](https://github.com/Jeiwan),
 [twitter](https://twitter.com/jeiwan7)
)


---

Note: This is an edited version by Gerald Bauer to change 
the code from Solidity (Ethereum VM) to Ruby / Rubysol.

---


## Introduction

Welcome back! Today we'll add the core functionality to our clone of [Uniswap V2](https://uniswap.org/)–swapping. Decentralized tokens exchanging is what Uniswap was created for, and today we'll see how it's done. We're still working on the core pair contract, which means that our implementation will be very low-level and minimal. There's no convenient interface and we won't even have price calculation at this point!

Also, we're going to implement a price oracle: the design of the pair contract allows to implement one with only a few lines.

Additionally, I'll explain some details and ideas behind the pair contract implementation, on which I didn't focus enough in the previous part.

Let's begin!


> You can find full source code of this part here: [source code, part 2](.).


## Tokens swapping

At this point, we have everything we need to perform actual tokens exchanging. Let's think how we will implement it.

Exchanging means giving away some amount of Token A in exchange for Token B. But we need some kind of a mediator that:

1. Provides actual exchange rates.
2. Guarantees that all exchanges are paid in full, i.e. all exchanges are made under correct rate.

We learned something about pricing of DEXes when we were working on liquidity provision: it's the amount of liquidity in a pool that defines exchange rates. In the [Uniswap V1 series](https://jeiwan.net/posts/programming-defi-uniswap-1/), I explained in details how the constant product formula works and what is the main condition for a successful swap. 
Namely: **the product of reserves after a swap must be equal or greater than that before the swap**. That's it: the constant product must remain the same, no matter what's the amount of reserves in pool. This is basically the only condition we must guarantee and, surprisingly, this condition frees us from calculating swap price.


As I mentioned in the introduction, the pair contract is a core contract, which means it must be as low-level and minimal as possible. This also affects how we send tokens to the contract. There a two ways of transferring tokens to someone:

1. By calling `transfer` method of the token contract and passing recipient's address and the amount to be sent.
2. By calling `approve` method to allow the other user or contract to transfer some amount of your tokens to their address. The other party would have to call `transferFrom` to get your tokens. You pay only for approving a certain amount; the other party pays for the actual transfer.

The approval pattern is very common in Ethereum applications: dapps ask users to approve spending of the maximum amount so users don't need to call `approve` again and again (which costs gas). This improves user experience. And this is not what we're looking for at this moment. So we'll go with the manual transferring to the pair contract.

Let's get to code!

The function takes two output amounts, one for each token. These are the amounts that caller wants to get in exchange for their tokens. Why doing it like that? Because we don't even want to enforce the direction of swap: caller can specify either of the amounts or both of them, and we'll just perform necessary checks.

``` ruby
sig [UInt, UInt, Address]
def swap( amount0Out:, amount1Out:, to: )
  assert amount0Out >= 0 || amount1Out >= 0, "Insufficient Output Amount"

  # ...
```

Next, we need to ensure that there are enough of reserves to send to user.

``` ruby
   #...

   reserve0, reserve1 = getReserves

   assert amount0Out <= reserve0  && amount1Out <= reserve1, "Insufficient Liquidity"

   #...
```

Next, we're calculating token balances of this contract minus the amounts we're expected 
to send to the caller. At this point, it's expected that the caller has sent tokens 
they want to trade in to this contract. So, either or both of the balances is expected to be greater than corresponding reserve.

``` ruby
   #...
   balance0 = ERC20(@token0).balanceOf(address(this)) - amount0Out
   balance1 = ERC20(@token1).balanceOf(address(this)) - amount1Out
   #...
``` 

And here's the constant product check we talked about above. We expect that this contract token balances are different than its reserves (the balances will be saved to reserves soon) and we need to ensure that their product is equal or greater than the product of current reserves. If this requirement is met then:

1. The caller has calculated the exchange rate correctly (including slippage).
2. The output amount is correct.
3. The amount transferred to the contract is also correct.

``` ruby
   #...
   assert balance0 * balance1 >= reserve0 * reserve1, "Invalid K"
   #...
```

It's now safe to transfer tokens to the caller and to update the reserves. 
The swap is complete.

``` ruby
   #...
   _update( balance0, balance1, reserve0, reserve1 )

   _safeTransfer( @token0, to, amount0Out )   if amount0Out > 0
   _safeTransfer( @token1, to, amount1Out )   if amount1Out > 0

   log Swap, sender: msg.sender, amount0Out: amount0Out, amount1Out: amount1Out, to: to
end
```

Feel free to write tests for this function. And don't forget about the case when both output amounts are specified. ;-) 

> Keep in mind that this implementation is not complete: the contract doesn't collect exchange fees and, as a result, liquidity providers don't get profit on their assets. We'll fill this gap after implementing price calculation.



## Price oracle

The idea of oracles, bridges that connect blockchain with off-chain services so that real-world data can be queried from smart contracts, has been around for quite a while. Chainlink, one of the biggest (or the biggest one?) oracle networks, was created in 2017 and, today, it's a crucial part of many DeFi applications.

Uniswap, while being an on-chain application, can also serve as an oracle. Each Uniswap pair contract that is regularly used by traders also attracts arbitrageurs, who make money on minimizing price differences between exchanges. Arbitrageurs make Uniswap prices as close to those on centralized exchanges as possible, which can also be seemed as feeding prices from centralized exchanges to blockchain. Why not use this fact to turn the pair contract into a price oracle? And this is what was done in Uniswap V2.

The kind of prices provided by the price oracle in Uniswap V2 is called **time-weighted average price**, or TWAP. It basically allows to get an average price between two moments in time. To make this possible, the contract stores accumulated prices: before every swap, it calculates current marginal prices (excluding fees), multiplies them by the amount of seconds that has passed since last swap, and adds that number to the previous one.

I mentioned marginal price in the previous paragraph–this is simply a relation of two reserves:


<!--
$$price_0 = \frac{reserve_1}{reserve_0}$$
or
$$price_1 = \frac{reserve_0}{reserve_1}$$
-->

     price0 = reserve1 / reserve0

or

     price1 = reserve0 / reserve1 


For the price oracle functionality, Uniswap V2 uses marginal prices, 
which don't include slippage and swap fee and also don't depend on swapped amount.

Since Rubysol doesn't support float point division, 
calculating such prices can be tricky: if, for example, the ratio of two reserves is
`2/3`, then the price is 0. We need to increase precision when calculating marginal prices, 
and Unsiwap V2 uses [UQ112.112](https://en.wikipedia.org/wiki/Q_(number_format)) 
numbers for that.

UQ112.112 is basically a number that uses 112 bits for the fractional part and 112 for the integer part. 112 bits were chosen to make storage of the reserve state variables more optimal (more on this in the next section)-that's why the variables use type uint (112 bits). Reserves, on the other hand, are stored as the integer part of a UQ112.112 number–this is why they're multiplied by `2**112` before price calculation.

<!-- Check out UQ112x112.sol for more details, it's very simple. -->

I hope this all will be clearer for you from code, so let's implement prices accumulation. 
We only need to add one state variable:

``` ruby
storage _blockTimestampLast: Timestamp
```

Which will store last swap (or, actually, reserves update) timestamp. 
And then we need to modify the reserves updating function:

``` ruby
sig [UInt, UInt, UInt, UInt]
def _update(
        balance0:,
        balance1:,
        reserve0:,
        reserve1: )
       
   #...
   timeElapsed = block.timestamp - @_blockTimestampLast

   if timeElapsed > 0 && reserve0 > 0 && reserve1 > 0
      @price0CumulativeLast += (reserve1 *2**112 / reserve0) * timeElapsed
      @price1CumulativeLast += (reserve0 *2**112 / reserve1) * timeElapsed
   end

   @_reserve0           = balance0
   @_reserve1           = balance1
   @_blockTimestampLast = block.timestamp

   #...
end
```

By multiplying a uint (112 bits) value by `2**112`, makes it a uint (224 bits) value. 
Then, it's divided by the other reserve and multiplied by timeElapsed. 
The result is added to the currently stored one-this makes it cumulative.


## Conclusion

That's it for today! I hope this part clarifies a lot in our implementation. Next time we'll continue with adding new features and contracts.


## Links
 
-  [Source code of part 2](.)
-  [UniswapV2 Whitepaper](https://uniswap.org/whitepaper.pdf) – worth reading and re-reading.
-  [Q (number format)](https://en.wikipedia.org/wiki/Q_(number_format))



## Meta

Find or read the original and unabridged article [Programming DeFi: Uniswap V2. Part 2](https://jeiwan.net/posts/programming-defi-uniswapv2-2/). 

Content of this article is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.