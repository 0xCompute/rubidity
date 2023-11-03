# Notes on Uniswap


What is Uniswap V2?

Uniswap V2 allows traders to directly swap from one ERC-20 token to another ERC-20 token. Traders don't trade directly with each other. Instead, they trade with a token pool that has both tokens reserved. This token pool is called "Liquidity Pool".

What is the difference between Uniswap V2 and V3?

Uniswap V2 was the current version of Uniswap 
before the launch of Uniswap V3 in May 2021. The major changes between the two versions focus on improving user experience, fees and overall performance.


docs

Deep dive into UniswapV2 : UniswapV2Pair
by Parichaya Thanawuthikrai
<https://coinsbench.com/deep-dive-into-uniswapv2-uniswapv2pair-e88f0ed3bb6e>


Purposes
- Pool for exchanging token
- Provide mint, burn, swap function
- Provide price oracle (act as automated market makers)

related variables

MINIMUM_LIQUIDITY : A minimum number of liquidity tokens that always exist which are owned by account ZERO for preventing cases of division by zero.

factory : The factory contract that created this pool.

token0 , token1 : ERC-20 tokens that can be exchanged by pool.

reserve0 , reserve1 : Reserves of pool for each token. → assume that reserve0 = reserve1, so the value of token0 = (reserve1 * token 1)/reserve0

blockTimestampLast : The timestamp for the last block in which an exchange occurred

price0CumulativeLast , price1CumulativeLast : The cumulative costs for each token, are used to calculate the price for each toke in pool

kLast : The value of reserve0 * reserve1, which is required to remain unchanged during trades.

Price oracle

UniswapV2 acts as automated market makers, which can be computer the marginal price by dividing the reserve of token a by reserve of token b

     p_t = r^a_t / r^b_t


The cumulative price can be calculated by accumulating each price times the amount of time that has passed since the last block in which it was updated.

    a_t  = \sum^t_i=1{ p_i }


The price can be calculated by subtracting the first cumulative price from the second(p2-p1) and divided by the number of seconds elapsed(t2-t1).


Implementation

Price oracle in Uniswap V2 is implemented in _update function by using 3 variables: price0CumulativeLast, price1CumulativeLast, blockTimestampLast, which represents the current state of each cumulative price.


To calculate the price, UniswapV2 uses the formula above that is

    price0CumulativeLast - price0CumulativeOld / blockTimestampLast - blockTimestampOld

You might be curious where is the calculating price function in the core contract? how do they get the old one to calculate the price?

the answers can be found here:

_update function is called when tokens are deposited or withdrawn. In this function, it checks the block timestamp for updating the cumulative prices, and updates reserves value, block timestamp latest value.

- balance0, balance1 are retrieved from each ERC20 token balance.
- _reserve0 and _reserve1 are retrieved from previously known reserve balances.


In UniswapV2, traders are required to pay a 0.3% fee on all trades. and factory contract can take some of those fees if we turn on to get protocol fee.

> If the feeTo address (factory contract) is set, the protocol will begin charging a 5-basis-point fee, which is taken as a 1/6 cut of the 30-basis-point fees earned by liquidity providers. That is, traders will continue to pay a 0.30% fee on all trades; 83.3% of that fee (0.25% of the amount traded) will go to liquidity providers, and 16.6% of that fee (0.05% of the amount traded) will go to the feeTo address. : https://uniswap.org/whitepaper.pdf



Implementation
Protocol fee calculation is implemented in _mintFee function, which is called from the mint and burn function.



External Function

### mint
mint function is called when a liquidity provider deposits liquidity to the pool.


- get reserve0, reserve1 and calculate How much was added of each token through actual token balance - previous reserve balance → amount0, amount1
- Calculate the protocol fee and get feeOn status. Inside this _mintFee function, it can re-calculate totalSupply via _mint() (it is explained how this function works in the protocol fee section).
- if totalSupply of pool is 0 → first deposit , we calculate liquidity and mint MINIMUM_LIQUIDITY to address 0 for preventing division by 0 in calculations (make sure that the token balance of LP is not ZERO).
- if it is not the first time, we expect that liquidity provider provide sufficient value for both tokens → if the liquidity provider deposits just one type of toke, it cannot produce any LP token and will revert this transaction since liquidity = 0
- mint LP token to to address then update states through _update function


### burn
burn function is called when a liquidity provider withdraws liquidity to the pool. this function is the mirror image of mint function

- get reserve0, reserve1, balance0, balance1, liquidity
- Calculate the protocol fee and get feeOn status. Inside this _mintFee function, it can re-calculate totalSupply via _mint() (it is explained how this function works in the protocol fee section).
- Calculate the amount to withdraw resulting in amount0, amount1
- burn LP token and transfer withdraw amounts to liquidity provider then update states through _update function


### swap
swap function is used to swap tokens.

- Check conditions, if everything is OK, we transfer to the trader address → we can do this because if the conditions aren’t met later in the call we revert out of it and any changes it created.
- at IUniswapV2Callee(to).uniswapV2Call(msg.sender, amount0Out, amount1Out, data);, this task is to interact with to address if requested.
- Sanity check:
  Ensure that the code changes introduced are working as expected

  we make sure that the amount received > 0 (amount0In, amount1In) and after trading kLast value(reserve0 * reserve1) should not be decreased.

- update states through _update function


References
- https://ethereum.org/en/developers/tutorials/uniswap-v2-annotated-code/
- https://uniswap.org/whitepaper.pdf
- https://betterprogramming.pub/uniswap-smart-contract-breakdown-ea20edf1a0ff
- https://docs.uniswap.org/protocol/V2/concepts/protocol-overview/how-uniswap-works#:~:text=Uniswap%20is%20an%20automated%20liquidity,%2C%20censorship%20resistance%2C%20and%20security
- https://medium.com/@epheph/using-uniswap-v2-oracle-with-storage-proofs-3530e699e1d3


---


Uniswap V2 Explained (Beginner Friendly)
by Leo Zhang

https://medium.com/@chiqing/uniswap-v2-explained-beginner-friendly-b5d2cb64fe0f#:~:text=Uniswap%20V2%20allows%20traders%20to,is%20called%20%E2%80%9CLiquidity%20Pool%E2%80%9D.

Uniswap allows anyone to make market and swap tokens. The first version — Uniswap V1, was released in 2018 as a proof of concept. Version 2 was a production version released in 2020. And Version 3, which is currenty the latest version, was launched in 2021.

Liquidity Pool
Uniswap V2 allows traders to directly swap from one ERC-20 token to another ERC-20 token. Traders don’t trade directly with each other. Instead, they trade with a token pool that has both tokens reserved. This token pool is called "Liquidity Pool". But the question is where are the tokens reserved in the pool originally from?

The tokens in the liquidity pool are added by users, called "Liquidity Providers".

Why do "Liquidity Provider" add their tokens to Liquidity Pool? Because they can earn fees when traders swap their tokens with the Liquidity Pool. We will see later.

Each Uniswap liquidity pool is a trading venue for a pair of ERC-20 tokens. Since there are lots of pairs, Uniswap will route the traders and liquidity providers to the corresponding liquidity pool for their transactions.

...


---

How Uniswap works

<https://docs.uniswap.org/contracts/v2/concepts/protocol-overview/how-uniswap-works#:~:text=Uniswap%20is%20open%2Dsource%20software,in%20return%20for%20pool%20tokens.>



Contracts

<https://docs.uniswap.org/contracts/v2/reference/smart-contracts/factory>


<https://github.com/Uniswap/v2-core/tree/master/contracts>

UniswapV2Factory.sol
<https://github.com/Uniswap/v2-core/blob/master/contracts/UniswapV2Factory.sol>

UniswapV2Pair.sol
<https://github.com/Uniswap/v2-core/blob/master/contracts/UniswapV2Pair.sol>



