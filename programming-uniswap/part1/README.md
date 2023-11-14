# Programming DeFi: Uniswap V2. Part 1

written by Ivan Kuznetsov
([web / blog](https://jeiwan.net),
 [github](https://github.com/Jeiwan),
 [twitter](https://twitter.com/jeiwan7)
)


---

Note: This is an edited version by Gerald Bauer to change 
the code from Solidity (Ethereum VM) to Ruby / Rubidity (Facet VM).

---

## Introduction

Uniswap is a decentralized exchange running on the Ethereum blockchain. It's fully automated, not managed, and decentralized. It has come through multiple iterations of development: first version was launched in November 2018; second version–in May 2020; and final, third, version was launched in March 2021.

In my previous series on Uniswap V1,
I showed how to build it from scratch and explained its core mechanics. This blog post begins a series of posts devoted to Uniswap V2: likewise, we'll build its copy from scratch and will learn the core principles of a decentralized exchange. Unlike the previous series, I won't go into much details on the constant product formula and related core mathematics of Uniswap–if you want to learn about that, please read the V1 series.


## Tooling

In this series, I'll be using Ruby / Rubidity for contracts developing and testing. Rubidity is a modern Ethereum Layer 1 (L1) via Ethscriptions (Calldata) and Facet VM  
toolkit written in Ruby by Tom Lehman et al.  It allows to write tests in Ruby. Yes, we'll use Ruby for both writing contracts and testing them and you'll see that this is much cleaner and handier than writing tests in Javascript (JS).

I'll also use the rubidity-contracts library (gem) for ERC20 implementation.


## Architecture of Uniswap V2

The core architectural idea of Uniswap V2 is pooling: liquidity providers are available to stake their liquidity in a contract; that staked liquidity allows anyone else to trade in a decentralized way. Similarly to Uniswap V1, traders pay a small fee, which gets accumulated in a contract and then gets shared by all liquidity providers.

The core contract of Uniswap V2 is [UniswapV2Pair](https://github.com/Uniswap/v2-core/blob/master/contracts/UniswapV2Pair.sol). 
"Pair" and "Pool" are interchangeable terms, they mean the same thing–`UniswapV2Pair` contract. That contract's main purpose is to accept tokens from users and use accumulated reserves of tokens to perform swaps. This is why it's a pooling contract. Every 'UniswapV2Pair' contract can pool only one pair of tokens and allows to perform swaps only between these two tokens–this is why it's called "pair".

The codebase of Uniswap V2 contracts is split into two repositories:

- [core](https://github.com/Uniswap/v2-core), and
- [periphery](https://github.com/Uniswap/v2-periphery).

The core repository stores these contracts:

1. `UniswapV2ERC20` – an extended ERC20 implementation that's used for LP-tokens. It additionally implements [EIP-2612](https://eips.ethereum.org/EIPS/eip-2612) to support off-chain approval of transfers.
2. `UniswapV2Factory` – similarly to V1, this is a factory contract that creates pair contracts and serves as a registry for them. The registry uses `create2` to generate pair addresses–we'll see how it works in details.
3. `UniswapV2Pair` – the main contract that's responsible for the core logic. It's worth noting that the factory allows to create only unique pairs to not dilute liquidity.

The periphery repository contains multiple contracts that make it easier to use Uniswap. Among them is `UniswapV2Router`, which is the main entrypoint for the Uniswap UI and other web and decentralized applications working on top of Uniswap. This contracts has an interface that's very close to that of the exchange contract in Uniswap V1.

Another important contract in the periphery repository is `UniswapV2Library`, which is a collection of helper functions that implement important calculations. We`ll implement both of these contracts.

We'll start our journey with the core contracts to focus on the most important mechanics first. We'll see that these contracts are very general and their functions require preparatory steps–this low-level structure reduces the attack surfaces and makes the whole architecture more granular.

Alright, let's begin!


## Pooling liquidity

No trades are possible without liquidity. Thus, the first feature we need to implement is liquidity pooling. How does it work?

Liquidity pools are simply contracts that store token liquidity and allow to perform swaps that use this liquidity. So, "pooling liquidity" means sending tokens to a dumb-contract and storing them there for some time.

As you probably already know, every contract has its own storage, and the same is true for ERC20 tokens–each of them has a mapping that connects addresses and their balances. And our pools will have their own balances in ERC20 contracts. Is this enough to pool liquidity? As it turns out, no.

The main reason is that relying only on ERC20 balances would make price manipulations possible: imaging someone sending a big amount of tokens to a pool, makes profitable swaps, and cashes out in the end. To avoid such situations, we need to track pool reserves on our side, and we also need to control when they're updated.

We'll use reserve0 and reserve1 variable to track reserves in pools:

``` ruby
class UniswapV2Pair < ERC20
    #...
 
    storage _reserve0: UInt
            _reserve1: UInt

    #...
end        
```

>  I omit a lot of code for brevity. [Check the GitHub repo](.) for full code.

If you followed my UniswapV1 series, you probably remember 
that we implemented `addLiquidity` function that counted new liquidity and issued LP-tokens. Uniswap V2 implements an identical function in periphery contract `UniswapV2Router`, 
and, in the pair contract, this functionality is implemented at a lower level: liquidity management is simply viewed as LP-tokens management. When you add liquidity to a pair, the contract mints LP-tokens; when you remove liquidity, LP-tokens get burned. As I explained earlier, core contracts are lower-level contracts that perform only core operations.

So, here's the low-level function for depositing new liquidity:

``` ruby
sig []
def mint
    
    balance0 = ERC20(@token0).balanceOf( address(this) ) 
    balance1 = ERC20(@token1).balanceOf( address(this) )   
    amount0 = balance0 - @_reserve0
    amount1 = balance1 - @_reserve1

    liquidity = 0

    if @totalSupply == 0
        liquidity = ???
        _mint( address(0), MINIMUM_LIQUIDITY )
    else 
        liquidity = ???
    end

    assert liquidity > 0, "Insufficient Liquidity Minted"

    _mint( msg.sender, liquidity )

    _update( balance0, balance1 )

    log Mint, sender: msg.sender, amount0: amount0, amount1: amount1
end
```

First, we need to calculate newly deposited amounts that haven't yet been counted (saved in reserves). Then, we calculate the amount of LP-tokens that must be issued as a reward for provided liquidity. Then, we issue the tokens and update reserves 
(function `_update` simply saves balances to the reserve variables). 
The function is quite minimal, isn't it?


As you can see from the code, liquidity is calculated differently when initially deposited into pool (the `totalSupply == 0` branch). 
Think about this: how many LP-token do we need to issue when there’s no liquidity in the pool? Uniswap V1 used the amount of deposited ethers, which made the initial amount of LP-tokens dependent on the ratio at which liquidity was deposited. But nothing forces users to deposit at the correct ratio that reflects actual prices at that moment. Moreover, Uniswap V2 now supports arbitrary ERC20 token pairs, which means there might be no prices valued in ETH at all.

For initial LP-amount, Uniswap V2 ended up using geometric mean of deposited amounts:

<!--  $$Liquidity_{minted} = \sqrt{Amount_0*Amount_1}$$  -->

    liquidity_minted = sqrt( amount0 * amount1 )

The main benefit of this decision is that such formula ensures that the initial liquidity ratio doesn't affect the value of a pool share.

Now, let's calculate LP-tokens issued when there’s already some liquidity. The main requirement here is that the amount is:

1. proportional to the deposited amount,
2. proportional to the total issued amount of LP-tokens.

Recall this formula from the V1 series:

<!-- $$Liquidity_{minted} = TotalSupply_{LP} * \frac{Amount_{deposited}}{Reserve}$$ -->

    liquidity_minted = totalsupply_lp * amount_deposited / reserve


New amount of LP-tokens, that's proportional to the deposited amount of tokens, gets minted. But, in V2, there are two underlying tokens–which of them should we use in the formula?

We can choose either of them, but there's interesting pattern: the closer the ratio of deposited amounts to the ratio of reserves, the smaller the difference. Consequently, if the ratio of deposited amounts is different, LP amounts will also be different, and one of them will be bigger than the other. If we choose the bigger one, then we'll incentivize price changing via liquidity provision and this leads to price manipulation. If we choose the smaller one, we'll punish for depositing of unbalanced liquidity (liquidity providers would get fewer LP-tokens). It's clear that choosing smaller number is more benefitial, 
and this is what Uniswap is doing. Let's fill the gaps in the above code:

```ruby
if @totalSupply == 0
    liquidity = Math.sqrt( amount0 * amount1) - MINIMUM_LIQUIDITY
    _mint( address(0), MINIMUM_LIQUIDITY )
 else 
    liquidity = Math.min(
                     (amount0 * @totalSupply) / reserve0,
                     (amount1 * @totalSupply) / reserve1
                    )
end
```

In the first branch, we're subtracting MINIMUM_LIQUIDITY 
(which is a constant 1000, or 1e-15) when initial liquidity is provided. 
This protects from someone making one pool token share (1e-18, 1 wei) too expensive, which would turn away small liquidity providers. 1000 wei of LP-tokens is a negligible amount for most of pools, but if someone tries to make the cost of one pool token share too expensive (say, $100), they’d have to burn 1000 times of such cost (that is, $100,000).

To solidify our understanding of minting, let’s write tests.





To be continued...




## Conclusion

Well, enough for today. Feel free experimenting with the code and, for example, choosing the bigger amount of LP-tokens when adding liquidity to a pool.

## Links
 
- [Source code of part 1](.)
- [UniswapV2 Whitepaper](https://uniswap.org/whitepaper.pdf) – worth reading and re-reading.
- [Rubidity GitHub repo](https://github.com/s6ruby/rubidity)
- [Programming DeFi: Uniswap V1](https://jeiwan.net/posts/programming-defi-uniswap-1/)



## Meta

Find or read the original and unabridged article [Programming DeFi: Uniswap V2. Part 1](https://jeiwan.net/posts/programming-defi-uniswapv2-1/). 

Content of this article is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.



