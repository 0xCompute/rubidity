# Programming DeFi: Uniswap V2. Part 1

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

Uniswap is a decentralized exchange running on the Ethereum blockchain. It's fully automated, not managed, and decentralized. It has come through multiple iterations of development: first version was launched in November 2018; second version–in May 2020; and final, third, version was launched in March 2021.

In my previous series on Uniswap V1,
I showed how to build it from scratch and explained its core mechanics. This blog post begins a series of posts devoted to Uniswap V2: likewise, we'll build its copy from scratch and will learn the core principles of a decentralized exchange. Unlike the previous series, I won't go into much details on the constant product formula and related core mathematics of Uniswap–if you want to learn about that, please read the V1 series.


## Tooling

In this series, I'll be using Ruby / Rubysol for contracts. It allows to write tests in Ruby. Yes, we'll use Ruby for both writing contracts and testing them and you'll see that this is much cleaner and handier than writing tests in Javascript (JS).

I'll also use the rubysol-contracts library (gem) for ERC20 implementation.



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
 
    storage _reserve0: UInt,
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
Think about this: how many LP-token do we need to issue when there's no liquidity in the pool? Uniswap V1 used the amount of deposited ethers, which made the initial amount of LP-tokens dependent on the ratio at which liquidity was deposited. But nothing forces users to deposit at the correct ratio that reflects actual prices at that moment. Moreover, Uniswap V2 now supports arbitrary ERC20 token pairs, which means there might be no prices valued in ETH at all.

For initial LP-amount, Uniswap V2 ended up using geometric mean of deposited amounts:

<!--  $$Liquidity_{minted} = \sqrt{Amount_0*Amount_1}$$  -->

    liquidity_minted = sqrt( amount0 * amount1 )

The main benefit of this decision is that such formula ensures that the initial liquidity ratio doesn't affect the value of a pool share.

Now, let's calculate LP-tokens issued when there's already some liquidity. The main requirement here is that the amount is:

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
This protects from someone making one pool token share (1e-18, 1 wei) too expensive, which would turn away small liquidity providers. 1000 wei of LP-tokens is a negligible amount for most of pools, but if someone tries to make the cost of one pool token share too expensive (say, $100), they'd have to burn 1000 times of such cost (that is, $100,000).

To solidify our understanding of minting, let's write tests.

## Writing tests in Rubysol

As I said above, I'll be using ruby to test our dumb contracts–this will allow us to quickly set up our tests and not have any business with JavaScript. Our dumb contracts tests will simply be ruby scripts. That's it: ruby scripts that test dumb contracts.

This is all we need to set up testing of the pair contract:

``` ruby
class TestUniswapV2Pair < Minitest::Test

  ALICE = '0x'+'a'*40  # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'

  def _setup_contracts
    token0 = PublicMintERC20.construct(
      name: "Token A",
      symbol: "TKNA",
      maxSupply: 21.e24,  
      perMintLimit: 21.e24,
      decimals: 18 )

    token1 = PublicMintERC20.construct(
      name: "Token B",
      symbol: "TKNB",
      maxSupply: 21.e24,
      perMintLimit: 21.e24,
      decimals: 18 )

    pair = UniswapV2Pair.construct( token0: address(token0),
                                    token1: address(token1) ) 

    Runtime.msg.sender = ALICE
    token0.mint( 10.ether )   
    token1.mint( 10.ether ) 

    [token0, token1, pair]
  end

  # Any method starting with "test" is a test case.
end
```

Let's add a test for pair bootstrapping (providing initial liquidity):

```ruby
def test_MintBootstrap
    token0, token1, pair =  _setup_contracts

    token0.transfer( address(pair), 1.ether ) 
    token1.transfer( address(pair), 1.ether )

    pair.mint

    assert  pair.balanceOf( ALICE ) == 1.ether - 1000
    reserves = pair.getReserves
    assert reserves[0] == 1.ether
    assert reserves[1] == 1.ether
    assert pair.totalSupply == 1.ether
end
```

1 ether of `token0` and 1 ether of `token1` 
are added to the test pool. As a result, 1 ether of LP-tokens is issued and we get 1 ether - 1000 (minus the minimal liquidity). Pool reserves and total supply get changed accordingly.

What happens when balanced liquidity is provided to a pool that already has some liquidity? Let's see:

```ruby
def test_MintWhenTheresLiquidity
    token0, token1, pair =  _setup_contracts

    token0.transfer( address(pair), 1.ether )
    token1.transfer( address(pair), 1.ether )

    pair.mint  # + 1 LP

    token0.transfer( address(pair), 2.ether )
    token1.transfer( address(pair), 2.ether )

    pair.mint    #  + 2 LP

    assert pair.balanceOf(address( ALICE )) == 3.ether - 1000
    assert pair.totalSupply == 3.ether
    reserves = pair.getReserves
    assert reserves[0] == 3.ether
    assert reserves[1] == 3.ether
end
```

Everything looks correct here. 
Let's see what happens when unbalanced liquidity is provided:

``` ruby
def test_MintUnbalanced
    token0, token1, pair =  _setup_contracts

    token0.transfer( address(pair), 1.ether )
    token1.transfer( address(pair), 1.ether )

    pair.mint  #  + 1 LP
    
    assert pair.balanceOf( ALICE ) == 1.ether - 1000
    reserves = pair.getReserves
    assert reserves[0] == 1.ether
    assert reserves[1] == 1.ether

    token0.transfer( address(pair), 2.ether )
    token1.transfer( address(pair), 1.ether )

    pair.mint   # + 1 LP

    assert pair.balanceOf( ALICE ) == 2.ether - 1000
    reserves = pair.getReserves
    assert reserves[0] == 3.ether
    assert reserves[1] == 2.ether
end
```

This is what we talked about: even though user provided more `token0` 
liquidity than `token1` liquidity, they still got only 1 LP-token.

Alright, liquidity provision looks good. Let's now move to liquidity removal.


## Removing liquidity

Liquidity removal is opposite to provision. Likewise, burning is opposite to minting. Removing liquidity from pool means burning of LP-tokens in exchange for proportional amount of underlying tokens. The amount of tokens returned to liquidity provided is calculated like that:

<!-- $$Amount_{token}=Reserve_{token} * \frac{Balance_{LP}}{TotalSupply_{LP}}$$  -->

    amount_token = reserve_token * balance_lp / totalsupply_lp

In plain English: the amount of tokens returned is proportional to the amount of LP-tokens held over total supply of LP tokens. The bigger your share of LP-tokens, the bigger share of reserve you get after burning.

And this is all we need to know to implement burn function:


``` ruby
sig []
def burn 
    balance0 = ERC20(@token0).balanceOf( address(this) ) 
    balance1 = ERC20(@token1).balanceOf( address(this) ) 
    liquidity = @balanceOf[msg.sender]

    amount0 = (liquidity * balance0) / @totalSupply
    amount1 = (liquidity * balance1) / @totalSupply

    assert amount0 > 0 && amount1 > 0, "Insufficient Liquidity Burned"

    _burn( msg.sender, liquidity )
        
    _safeTransfer( @token0, msg.sender, amount0 )
    _safeTransfer( @token1, msg.sender, amount1 )

    balance0 = ERC20(@token0).balanceOf( address(this) ) 
    balance1 = ERC20(@token1).balanceOf( address(this) ) 

    _update( balance0, balance1 )

    log Burn, sender: msg.sender, amount0: amount0, amount1: amount1
end
```

As you can see, UniswapV2 doesn't support partial removal of liquidity.

> Update: the above statement is wrong! I made a logical bug in this function, 
> can you spot it? If not, I explained and fixed it in Part 4.

Let's test it:

``` ruby
def test_Burn
  token0, token1, pair =  _setup_contracts

  token0.transfer( address(pair), 1.ether )
  token1.transfer( address(pair), 1.ether )

  pair.mint
  pair.burn

  assert pair.balanceOf(address( ALICE )) == 0
  reserves = pair.getReserves
  assert reserves[0] == 1000
  assert reserves[1] == 1000
  assert pair.totalSupply == 1000
  assert token0.balanceOf(address( ALICE )), 10.ether - 1000
  assert token1.balanceOf(address( ALICE )), 10.ether - 1000
end
```

We see that the pool returns to its uninitialized state except the minimum liquidity that was sent to the zero address– it cannot be claimed.

Now, let's see what happens when we burn after providing unbalanced liquidity:

``` ruby
def test_BurnUnbalanced
  token0, token1, pair =  _setup_contracts

  token0.transfer( address(pair), 1.ether )
  token1.transfer( address(pair), 1.ether )

  pair.mint

  token0.transfer( address(pair), 2.ether )
  token1.transfer( address(pair), 1.ether )

  pair.mint   # + 1 LP

  pair.burn

  assert pair.balanceOf(address(ALICE)) == 0
  reserves = pair.getReserves
  assert reserves[0] == 1500
  assert reserves[1] == 1000
  assert pair.totalSupply == 1000
  assert token0.balanceOf( address( ALICE )) == 10.ether - 1500
  assert token1.balanceOf( address( ALICE )) == 10.ether - 1000
end
```

What we see here is that we have lost 500 wei of `token0`! This is the punishment for price manipulation we talked above. But the amount is ridiculously small, it doesn't seem significant at all. This so because our current user (the test contract) is the only liquidity provider. What if we provide unbalanced liquidity to a pool that was initialized by another user? Let's see:


```ruby
def test_BurnUnbalancedDifferentUsers
  token0, token1, pair =  _setup_contracts

  Runtime.msg.sender = BOB
  token0.transfer( address(pair), 1.ether )
  token1.transfer( address(pair), 1.ether )
  pair.mint

  assert pair.balanceOf(address( ALICE )) == 0
  assert pair.balanceOf(address( BOB )) == 1.ether - 1000
  assert pair.totalSupply == 1.ether


  Runtime.msg.sender = ALICE
  token0.transfer( address(pair), 2.ether )
  token1.transfer( address(pair), 1.ether )
  pair.mint    # + 1 LP

  pair.burn

  # this user is penalized for providing unbalanced liquidity
  assert  pair.balanceOf(address( ALICE)) == 0
  reserves = pair.getReserves
  assert reserves[0] == 1.5.ether
  assert reserves[1] == 1.ether
  assert pair.totalSupply == 1.ether
  assert token0.balanceOf(address(ALICE)), 10.ether - 0.5.ether 
  assert token1.balanceOf(address(ALICE)), 10.ether
end
```

This looks completely different! We've now lost 0.5 ether of `token0`, 
which is 1/4 of what we deposited. Now that's a significant amount!

Try to figure out who eventually gets that 0.5 ether: the pair or the test user? ;-).



## Conclusion

Well, enough for today. Feel free experimenting with the code and, for example, choosing the bigger amount of LP-tokens when adding liquidity to a pool.

## Links
 
- [Source code of part 1](.)
- [UniswapV2 Whitepaper](https://uniswap.org/whitepaper.pdf) – worth reading and re-reading.
- [Rubidity & Rubysol GitHub repo](https://github.com/s6ruby/rubidity)
- [Programming DeFi: Uniswap V1](https://jeiwan.net/posts/programming-defi-uniswap-1/)



## Meta

Find or read the original and unabridged article [Programming DeFi: Uniswap V2. Part 1](https://jeiwan.net/posts/programming-defi-uniswapv2-1/). 

Content of this article is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.



