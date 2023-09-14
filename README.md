
> The future of decentralized processing is here.
> Revolutionizing computation with (dumb) contracts / protocols (and "off-chain" indexer) 
> one block at a time.
>
> -- [Ethereum Inscriptions (Ethscriptions) Virtual Machine (VM)](https://goerli.ethscriptionsvm.com/)



# Rubidity  -  Ruby for Layer 1 (L1) Contracts / Protocols with "Off-Chain" Indexer


The idea -  only store ("serialized") method calls "on-chain" - 
the "state" and "transaction receipts" and so on are handled "off-chain" with indexer.

Bonus:  Offer an ever growing library of built-in (standard) contracts / protocols. Contract / protocol security through reuse and standardization 
PLUS "auto-magically" upgradable (because "off-chain" in indexer).



Why?  

- Way cheaper (> 4x!) because only call data "on-chain" (no storage fees because there's no "on-chain" storage ). 

- Way simpler than "classic" ethereum solidity contracts because you can (re)use (built-in) "standard" contracts / protocols.  


<details>
<summary markdown="1">The classic: let's start a new token in a minute.</summary>

yes, you can. only requires a deploy inscribe (constructor contract call) because you can (re)use (built-in) token contracts / protocols. Example: 

This rubidity (script) ...

``` ruby
PublicMintToken.construct( name:         'My Fun Token',    # string
                           symbol:       'FUN',             # string
                           maxSupply:    21000000,          # uint256
                           perMintLimit: 1000               # uint256
                          )
```

... maps to a inscribe / inscription in text-style

```
deploy PublicMintToken
name: My Fun Token 
symbol: FUN        
maxSupply: 21000000
perMintLimit: 1000 
```

or in json-style

``` json
{
  "protocol": "PublicMintToken",
  "constructor": {
    "name":      "My Fun Token",
    "symbol":    "FUN",
    "maxSupply":  210000000,
    "perMintLimit": 1000
  }  
}
```

or in json5-style (why? why not?)

``` json5
{
  protocol: "PublicMintToken",
  constructor: {
    name:      "My Fun Token",   # string
    symbol:    "FUN",            # string
    maxSupply:   210000000,      # uint256
    perMintLimit: 1000           # uint256
  }  
}
```

</details>


Layer 1 (L1)?!

Yes, it's layer 1 (L1), that is, happening right on ethereum layer 1 (L1) - 
no layer 2 (L2) "side-chain" needed. 





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

- [**rubidity-typed**](rubidity-typed) - "zero-dependency" type machinery incl. (frozen) string, address, uint256, (dumb) contract and more for rubidity - ruby for layer 1 (l1) contracts / protocols with "off-chain" indexer
- [**rubidity**](rubidity) - ruby for layer 1 (l1) contracts / protocols with "off-chain" indexer 
- [**rubidity-contracts**](rubidity-contracts) - standard contracts (incl. erc20, erc721, etc) for ruby for layer 1 (l1) with "off-chain" indexer




## Bonus - More Blockchain (Crypto) Tools, Libraries & Scripts In Ruby

See [**/blockchain**](https://github.com/rubycocos/blockchain) 
at the ruby code commons (rubycocos) org.


