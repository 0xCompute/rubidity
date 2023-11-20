# 10 000 Punks - The Facet (Dumb) Contract Edition V1 / V2


The idea:

let's use the (bug fixed) cryptopunks v1 contract here -> https://github.com/cryptopunksnotdead/punks.contracts/blob/master/punks-v1/CryptoPunks.sol 
or the cryptopunks v2 contract here -> https://github.com/cryptopunksnotdead/punks.contracts/blob/master/punks-v2/CryptoPunksMarket.sol
and yes, why not?  let's convert to a (dumb) contract and deploy on facet.   that may be  the world's 1st punk collection AND built-in market on facet! and yes, like the historic punks (anno 2017) - the "facet" punks (anno 2023)  are free to claim (only pay calldata / inscription gas transaction fees)  comments? questions? 

ps: to avoid trademark / copyright claims - let's change the image hash to a new 10 000 punk (or phunk) image / set. 


Comments:

we would have to change the image hash because all 10k Cryptopunks and cryptophunks have been inscribed onchain. These can't be duplicated. We can't use the originals and mint those and flipping them left won't work because CryptoPhunks are already fully etched online. 


More:

ha. that's the beauty of (dumb) contracts or the punk (dumb) contract.  the composite all-in-one image will be "off-chain".  thus, no worries about duplicates.  if you get a punk via the (dumb) contract than you get a token with an index (e.g. 0,1,2,3, etc.) like in the original (anno 2017)!  and every inscription is a (dumb) contract inscription (no image ever etched). back to the future! 

and yes, of course the idea is to generate a new 10 000 punks set anyway
that automagically has a new hash.  


<details>
<summary markdown="1">10 000 punks candidates - all human in 10 skin tones, with ethscribe green skin tone, or neon light sketches, and more</summary>

i have done many (new!) 10 000 punk series already.  a great candidate might be the human series with 10 skin tones (using the google skin tone research sponsored dr. ellis monk skin tones  - see https://skintone.google/ ) and the script to generate all 10 000 (human) punks (no aliens, zombies, apes) -> 
https://github.com/cryptopunksnotdead/punks.sandbox/blob/master/humans/generate_10000.rb
  and here's an image preview of the first two hundred  

![](https://github.com/cryptopunksnotdead/punks.sandbox/raw/master/humans/i/humans_preview.png
)

or maybe using an ethscribe neon (ethscribe) green skin tone ;-) -> 

![](https://github.com/ordinalpunks/ordinalpunks.sandbox/raw/master/ethscribes/i/ethscribes.png)

or maybe using a neon effect on a black & white sketch  - the (bitcon) orange preview here to be changed to green ;-) -> 

![](https://github.com/ordinalpunks/ordinalpunks.sandbox/raw/master/neon/i/neons.png)   


anyways, for sure no 1:1 copy or a reshuffle or left-right flip. 

</details>




## Punk (Dumb) Contract

Todos

- [ ] change to rubidity / rubysol
- [ ] change image hash
- [ ] change known bug  - fix bug! or use v2?
- [ ] change ether (eth) to bridged ether or erc-20 token?
- [ ] maybe make into (standard) erc-721 token  (no wrapper needed) - why? why not?



Aside - What's the bug in the v1 contract?

> When CryptoPunks launched ([June 9, 2017 @ Block #3842489](https://etherscan.io/address/0x6Ba6f2207e343923BA692e5Cae646Fb0F566DB8D)), the contract was exploitable. 
> Sellers didn't get paid (buyers got both the punk and the ETH refunded).
> Matt & John (LarvaLabs) quickly launched 
> a fixed version of the contract ([June 22, 2017 @ Block #3914495](https://etherscan.io/address/0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb)), 
> which everyone uses.
>
> But the V1 "first-deploy" tokens are still out there.
>

<details>
<summary markdown="1">The bug (the details)</summary> 

> The bug:
>
> Inside the `buyPunk` function the line that 
> executes the function `punkNoLongerForSale(punkIndex)` 
> deserves some attention: 
>
> It updates the `punksOfferedForSale` array by its new values, 
> which seem to be legit: the position belonging 
> to the acquired Punk with index `punkIndex` gets reassigned 
> with the new Offfer: the punk is now no longer for sale, 
> it obtains now the address of the sender `msg.sender` as its owner, 
> and since it is no longer for sale, the minValue can be set to zero.
>
> Lets find the bug: Actually, things go wrong in `punkNoLongerForSale(punkIndex)`. Why?!
>
> We request a withdrawal for `offer.seller`. 
> And actually `offer.seller` is the seller field of offer
> and offer is a reference to `punksOfferedForSale[punkIndex]`.
> But we reassigned `punksOfferedForSale[punkIndex]` in `punkNoLongerForSale`
> with the value: `punksOfferedForSale[punkIndex] = Offer(false, punkIndex, msg.sender, 0, 0x0)`,
> hence `offer.sender` had already been overwritten by the address `msg.sender`, 
> so finally the Contract authorizes a withdrawal 
> to the senders (=buyers) address instead to the sellers address! 
>
> The underlying reason why this happened, is that by design Solidity 
> doesn't assign structs by values but by reference.

It's easier to understand if you see the code "unrolled" like this:

``` solidity
function buyPunk(uint punkIndex) {

   Offer offer = punksOfferedForSale[punkIndex];
   //...

   // unroll call to punkNoLongerForSale(punkIndex)
     punksOfferedForSale[punkIndex].isForSale  = false;
     punksOfferedForSale[punkIndex].punkIndex  = punkIndex;
     punksOfferedForSale[punkIndex].seller     = msg.sender;  // bug !!!!
     punksOfferedForSale[punkIndex].minValue   = 0; 
     punksOfferedForSale[punkIndex].onlySellTo = 0x0;

   // bug - offser.seller is changed to msg.sender (= buyer!) 
   pendingWithdrawals[offer.seller] += msg.value;
   //...
}
```

</details>



For the work-in-progress (dumb) contract V1, see [Punks.rb »](Punks.rb)


Aside - What's news in the v2 contract?

- [x] fixes the v1 bug ;-).
- [x] adds bids to punks e.g. `enterBidForPunk` (and `withdrawBidForPunk`) and `acceptBidForPunk`


For the work-in-progress (dumb) contract V2, see [PunksMarket.rb »](PunksMarket.rb)





## Timeline

- [ ] This (minimum) requires struct support in Rubidity! Wen?
- [ ] This (dumb) contracts needs to get accepted to the curated (trusted) contract set for going live / deployment on mainnet. Wen? 



## More Ideas

- [ ]  pass-in the image hash in the constructor? let's anyone deploy a new (punk) collection reusing the contract code!








## Questions? Comments?

Join us in the [Rubidity & Rubysol (community) discord (chat server)](https://discord.gg/3JRnDUap6y). Yes you can.
Your questions and commentary welcome.
