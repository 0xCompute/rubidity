
**DISCLAIMER:   the rubidity gem version is different 
from the rubidity built into the face vm / app and i (Gerald Bauer) 
am NOT affiliated with facet computing inc. (middlemarch et al) or paid to work on the rubidity gem.**



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


<details>
<summary markdown="1">Q: Is the Ethscriptions (ESC) Virtual Machine (VM) an Layer (L2)?</summary>

From [ESIP-4: The Ethscriptions Virtual Machine](https://docs.ethscriptions.com/esips/esip-4-the-ethscriptions-virtual-machine#is-the-esc-vm-an-l2)


The ESC VM is not an L2 (Layer 2). 
One way to understand this is to consider the two notions of consensus that exist on Ethereum:

1. Consensus over what transactions are included in each block and in what order.
2. Consensus over the aggregate impact (1) has on the state of the EVM.

The main idea behind Ethscriptions is that you can build a fully decentralized system by focusing on (1) because the state of the blockchain unambiguously and deterministically specifies the state of the EVM. Given the blockchain alone, anyone can verify EVM state independently and with complete certainty.

On the other hand, it is impossible to verify the "truth" of (1) because it is a non-deterministic process with no "right answer."

Having (1) and (2) together as in the Ethereum protocol is ideal. However the combination is too expensive for most applications. Ethscriptions sacrifices part (2) of the Ethereum Protocol and builds tools to make the deterministic computation of state convenient.

L2s, by contrast, take the opposite approach. Because L2 state is managed in the context of a blockchain, it more convenient to verify than the state of the Ethscriptions ecosystem.

However L2 verification is conditional. It says given X transactions were included in a block with ordering Y, we can infer the state of the blockchain should change to Z. But within the system of an L2 there is no way to verify that X and Y are correct.

And in the general case X and Y will only be fair when making them fair aligns with the goals of the organization that operates the L2. Corporations that operate L2s bear a fiduciary responsibility to value the interests of shareholders over the interests of L2 users. In the limit case, if the L2 no longer serves the corporation's interests, the L2 will be shut down.

Ethscriptions stand for the ideal that without decentralized consensus over non-deterministic questions like block inclusion and transaction ordering, a blockchain can never be considered secure.

Our goal with the ESC VM is to pair decentralization and security with functionality that approaches that of the EVM.

Conclusion

There is no one-size-fits-all solution for blockchain development. The goal of the ESC VM is not to replace Smart Contracts or L2s, but rather to provide lost cost computation when decentralization is a priority.

</details>



## What's Rubidity?

middlemarch (a.k.a. Tom Lehman) 
introduced dumb contracts on ethscriptions with the production code written in a dialect of Ruby called "Rubidity" in August 2023. 

Q: Why do you choose ruby for dump contracts? 

A: Because you can create a mini-language that's very similar to Solidity and will be easier for Solidity devs to use. 

For official doc(ument)s and sources see:

- <https://github.com/ethscriptions-protocol/ethscriptions-vm-server> - Source
- <https://docs.ethscriptions.com/v/ethscriptions-vm/rubidity/rubidity-by-example> - Documentation 
-  <https://docs.ethscriptions.com/esips/esip-4-the-ethscriptions-virtual-machine> - ESIP-4: The Ethscriptions Virtual Machine (ESC VM)
- <https://goerli.ethscriptionsvm.com/contracts> - Test Chain - Live!




Quotes / Hightlights from the docs:

> Writing Dumb Contracts
>
> Dumb Contracts are specified using Solidity code because programming
> languages communicate protocol logic more efficiently than English
> prose and Solidity is the most widely used and understood language in
> blockchain development.
>
> However everyone implementing the Dumb Contracts protocol can use
> whatever language they want as long as their implementation matches the
> behavior of the Solidity specification.

<!--
> [...]
>
>  Protocol implementations will be validated by their behavior,
>  not by what language they use or their execution environment.
-->

> Rubidity [Classic]: An Example Execution Environment
>
> In developing the Dumb Contracts protocol we built out an approach 
> to executing them using a Ruby Domain-Specific Language (DSL) 
> we call "Rubidity." The goal of Rubidity [Classic] is to create
> a line-by-line port of the Solidity language 
> that can run on any computer.





## What's Happening Here?

This is a rubidity sandbox by [Gerald Bauer](https://github.com/geraldb)

The idea here is to experiment with rubidity "off-chain"
and if time permits break the "majestic rails rubidity monolith"
also known as "facet vm" (formerly "ethscriptions vm") up into easier to (re)use modules.

For example, why not bundle up a "core" language "rubidity" gem with 
no dependencies on any blockchain and break out "core / standard" 
contracts samples and database (SQL) and runtime modules or such.



The first published modules / gems include:

- [~~**rubidity-typed**~~](rubidity-typed) - "zero-dependency" 100%-solidity compatible data type machinery incl. (frozen) string, address, uint, int, enum, struct, array, mapping, and more for rubidity - ruby for layer 1 (l1) contracts / protocols with "off-chain" indexer

- [**solidity-typed**](solidity-typed) (formerly known as rubidity-typed) -  "zero-dependency" 100%-solidity compatible data type and application binary interface (abi) machinery incl. bool, (frozen) string, address, bytes, uint, int, enum, struct, array, mapping, event, and more for solidity-inspired contract (blockchain) programming languages incl. rubidity et al



- [**rubidity**](rubidity) - ruby for layer 1 (l1) contracts / protocols with "off-chain" indexer 

- [**rubidity-contracts**](rubidity-contracts) - standard contracts (incl. erc20, erc721, etc) for ruby for layer 1 (l1) with "off-chain" indexer

- [**uniswap**](uniswap) - core uniswap v2 (dumb) contracts for ruby (rubidity) for layer 1 (l1) with "off-chain" indexer

- [**programming-uniswap**](programming-uniswap) - programming (decentralized finance - defi) uniswap v2 contracts, the ruby / rubidity edition



- [**rubidity-classic**](rubidity-classic) - rubidity classic / o.g. contract builder; trying the impossible and square the circle, that is, a rubidity "classic / o.g." dsl builder generating rubidity "more ruby-ish" contract classes. 




More:

- [~~**rubidity-simulacrum**~~](rubidity-simulacrum) - run (dumb) blockchain contracts in rubidity (with 100%-solidity compatible data types & abis) on an ethereum simulacrum in your own home for fun & profit (for free)

- [~~**redpaper**~~](redpaper) - Yes, you can. it's just ruby. Run the sample contracts from the [Red Paper](https://github.com/s6ruby/redpaper)
with rubidity and simulacrum!


- [**soliscript**](https://github.com/soliscript/soliscript) (formerly known as rubidity-simulacrum) - run blockchain contracts in rubidity (with 100%-solidity compatible data types & abis) on an ethereum simulacrum in your own home for fun & profit (for free)

- [**soliscript.starter**](https://github.com/soliscript/soliscript.starter) (formerly known as red paper contracts) -  run (blockchain) contracts in rubidity (with 100%-solidity compatible data types & abis) on an ethereum simulacrum in your own home for fun & profit (for free) incl. the red paper contracts e.g. satoshi dice (gambling), crowd funder, ballot (liquid delegate democracy)



- [**rubidity-by-example**](rubidity-by-example) - Rubidity By Example - an introduction to Rubidity with simple examples (inspired and mostly following Solidity By Example)

- [**learninminutes**](learninminutes) - Learn X in Y Minutes (Where X=Rubidity, Y=?)




For some ongoing (or historic) 
rubidity discussions & comments from 
the discord (chat server), see the [Changelog  - Good Morning](CHANGELOG.md).





## Bonus - More Blockchain (Crypto) Tools, Libraries & Scripts In Ruby

See [**/blockchain**](https://github.com/rubycocos/blockchain) 
at the ruby code commons (rubycocos) org.





## Questions? Comments?

Join us in the [Rubidity (community) discord (chat server)](https://discord.gg/3JRnDUap6y). Yes you can.
Your questions and commentary welcome.

Or post them over at the [Help & Support](https://github.com/geraldb/help) page. Thanks.

