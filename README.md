# Rubidity  -  Ruby for Layer 1 (L1) Contracts with "Off-Chain" Indexer

The idea -  only store ("serialized") method calls "on-chain" - 
the "state" and "transaction receipts" and so on are handled "off-chain" with indexers.

Why?  Way cheaper (> 4x!) only call data (no storage fees) 
and simpler than "classic" ethereum solidity contract, for example.



## What's Rubidity?

middlemarch (a.k.a. Tom Lehman) 
introduced dumb contracts on ethscriptions with the production code written in a dialect of Ruby called "Rubidity". 

Q: Why do you choose ruby for dump contracts? 

A: Because you can create a mini-language that's very similar to Solidity and will be easier for Solidity devs to use. 

For official doc(ument)s and sources see:

- <https://github.com/ethscriptions-protocol/ethscriptions-vm-server> - Source
- <https://docs.ethscriptions.com/v/ethscriptions-vm/rubidity/rubidity-by-example> - Documentation 
- <https://goerli.ethscriptionsvm.com/contracts> - Test Chain - Live!



## What's Happening Here?

This is a rubidity sandbox by [Gerald Bauer](https://github.com/geraldb) - not (yet) affiliated with 
ethscriptions or middlemarch (a.k.a. Tom Lehman).

The idea here is to experiment with rubidity "off-chain"
and if time permits break the "majestic rails rubidity monolith"
also known as "ethscriptions vm" up into easier to (re)use modules.

For example, why not bundle up a "core" language "rubidity" gem with 
no dependencies on any blockchain and break out "core / standard" 
contracts samples and database (SQL) and runtime modules or such.


The first published modules / gems include:

- [**rubidity-typed**](rubidity-typed) - "zero-dependency" type machinery incl. (frozen) string, address, uint256, (dumb) contract and more for rubidity - ruby for layer 1 (l1) contracts with "off-chain" indexer
- [**rubidity**](rubidity) - ruby for layer 1 (l1) contracts with "off-chain" indexer 
- [**rubidity-contracts**](rubidity-contracts) - standard contracts (incl. erc20, erc721, etc) for ruby for layer 1 (l1) with "off-chain" indexer




## Bonus - More Blockchain (Crypto) Tools, Libraries & Scripts In Ruby

See [**/blockchain**](https://github.com/rubycocos/blockchain) 
at the ruby code commons (rubycocos) org.


