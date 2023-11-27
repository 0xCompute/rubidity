# Notes on Uniswap (Facetswap) Token DEX (Decentralized Exchange)


Middlemarch (a.k.a. Tom Lehman) writes / posts (in a [tweet thread](https://twitter.com/dumbnamenumbers/status/1699905065480311238)):


## Ethscriptions Update: Tokens, Splitting, Dumb Contracts, and You!

With Dumb Contracts approaching, Hirsch
and I wanted to share something we're extremely excited about 
in the world of Ethscriptions Tokens!


### What are Ethscriptions Tokens?

Inspired by Bitcoin inscriptions, tokens have become a huge part of the Ethscriptions ecosystem as well. Here is an example:

    data:,{"p":"erc-20","op":"mint","tick":"eths","id":"10944","amt":"1000"}

Although the base Ethscriptions Protocol treats these ethscriptions as if they were plain text, community consensus has rallied around the idea that holding one of these mint ethscriptions increases the holder's balance by 1000 and that transferring such an ethscription transfers 1000 from the sender to the receiver.


In fact, the community has embraced this idea with such enthusiasm that the current volume of all tokens on Ethscriptions has soared past an impressive 1500+ ETH!


### Token Splitting & $eths

As the ecosystem matures, the demand for trading these ethscription tokens in quantities smaller than 1000 has increased.

This is where token splitting comes into play. Splitting is the ability to hold and trade $eths (or any token) in quantities less than the mint ethscription (1000 in this case). That's why we're introducing an official solution: splitting through Dumb Contract bridges!

To make this a reality, each individual token would have its own bridge. Given the huge community support behind it, we're thrilled to announce that $eths will be the pioneer ethscriptions token to have its very own official bridge. We also intend to operate an official bridge for ETH and potentially other assets.

Here is an example of how a bridge for the $eths token would work:

1. User transfers a mint ethscription to Bridge Smart Contract

2. Bridge Smart Contract ("BSC") sends an ethscription to Bridge Dumb Contract ("BDC") notifying the BDC that BSC has received an ethscription.

3. BDC validates that the ethscription that BSC received is a valid mint ethscription for token $eths.

4. If it is, BDC mints to the user 1000 Dumb Contract $eths tokens. Note: this is a Dumb Contract-native asset.

5. User buys / sells / uses these Dumb Contract tokens.


6. If the user wants to get their mint ethscription back, they make a call to the Bridge Dumb Contract that burns their Dumb Contract $eths token and notifies the bridge operator to let the user withdraw the mint ethscription.

7. The bridge operator creates a signature that the user can present to the Smart Contract Bridge in order to withdraw the mint ethscription.

We are actively developing this technology. You can see our current progress (not production ready) here: <https://github.com/0xFacet/facet-vm>


### Introducing: DEXs

The ability to split tokens on Dumb Contracts is only meaningful if you can trade them. That's why we're excited to announce that we're building out a full-featured Dumb Contract DEX that anyone can deploy. Specifically, we are currently planning to implement a port of UniswapV2.

This DEX architecture will empower users to swap ethscriptions-based tokens, bridged ETH, and Dumb Contract-native tokens seamlessly.

Just like our bridge, we'll deploy and manage an official DEX. Stay tuned for coming update


### Centralized Exchanges (CEXs)

Furthermore, centralized exchanges will also be able to list Dumb Contract tokens. The Dumb Contract token standard aligns with ERC20, making it familiar to CEXs. We're committed to collaborating with CEXs to ensure a smooth integration process.


### What About Other Splitting Approaches?

As the Ethscriptions ecosystem evolves, community consensus on important matters becomes crucial. That is why we are devoting all our energy to making Dumb Contracts safe and full of features and establishing it as the official token splitting method.


### Conclusion

Dumb Contracts have gone from an idea to being live on testnet in less than a month. 
Hirsch and I are proud to deliver progress as or more quickly than our competitors, 
who have the benefit of larger teams and sometimes billions of dollars.

However, as the old saying goes, "Rome wasn't built in a day." We kindly request the community's patience and support by actively participating on testnet. We are working to make Dumb Contracts as solid and long-lived as Ethereum and community participation is essential.

We have laid out our official vision in this post. However, Ethscriptions is a decentralized protocol and no one can force you to follow our guidance. Dumb Contracts too will be decentralized, and anyone will be free to create their own bridges and DEXs, just like we can.

