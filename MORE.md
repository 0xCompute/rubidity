# More

"Old" Readme Introduction about Rubidity



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




