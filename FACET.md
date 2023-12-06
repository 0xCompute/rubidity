# More Facet Notes


middlemarch on the facet vm and rubidity (Dec 6th, 2023):

Q: What's the "simulate" function service about?

A: 
a better way to look at it is not simulating a transaction, 
but rather "declaring your intention to transact." 
If I know your intention, as well as the intention of everyone before you, 
I can work out if your "transaction" succeeded or not.

In your example, the indexer would look back and see if anyone had declared the intention to interact with that contract before you. 
If it noticed someone had, it would know to disregard your intention.

Practically speaking you can't look back at everything 
to evaluate every proposed transaction and so indexers 
(like the reference one) will keep track of state and 
update it after every block to make validating easier.

Does this help?
The idea is that telling smart contract Y "Mint me X tokens" is fundamentally 
the exact same thing as telling the WORLD "I want smart contract Y to mint me X tokens"

Q: What about this? I couldn't see any difference worth mentioning 
between the two languages solidity and rubidity (except their syntax)

A: Exactly! Though it's not really in another EVM as it avoids the EVM entirely because of cost. 
The EVM isn't a dependency, it's more like a competitor!

Only Rubidity works, though we could change this in the future. 
Solidity is just too hard (for me) to get working in a non-chain "thing you can run on Heroku" environment. Plus with Rubidity you get native string interpolation haha.
Also we have native built-in upgradeable contract support, 
so we will never be truly EVM-compatible... sigh...
