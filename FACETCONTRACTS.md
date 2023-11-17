# Facet (Dumb) Contracts  


Countdown to Facet mainnet on block 18684900! - <https://etherscan.io/block/countdown/18684900> - Estimated Target Date: Thu November, 30 2023 15:04:08




## Frequently Asked Questions (F.A.Q.s) and Answers



### Q: might be a dumb (lol) question, but does facet include the ability to deploy arbitrary dumb contract bytecode or is it limited to the set of contracts that currently display on the facetscan website?

A: 

> Based on my latest understanding, there will only be predefined contracts by Middlemarch/Hirsch; however, 
> the idea is for it to be extensible/open in the future 
> and anyone can deploy a dumb contract (just like smart contracts are done today).

Hirsch:  Correct!
Anyone can deploy from the curated list. But we are making it where eventually anyone can deploy custom contracts.

Middlemarch:  This is correct though in the latest version you do deploy contracts by sending the "byte code equivalent"  So it would just be a matter of removing the check for "supported contracts" for it to work with any contract

Here is an example of such a tx [inscription] -> https://goerli.etherscan.io/tx/0xcd3beeeb5a2cdf2080b27a2882e77c475c7ad1aca626dfb54e3c9bf817eb806b


```
data:application/vnd.facet.tx+json;esip6=true,
{"op":"create",
 "data":{"args":
           {"name":"Ether",
            "symbol":"ETH",
            "trustedSmartContract":"0x9d2f33af8610f1b53dd6fce593f76a2b4b402176"},
            "source_code":"pragma(:rubidity, \"1.0.0\")\ncontract(:ERC20, abstract: true)...","init_code_hash":"0x1e1ee21ee8811331d2aef4c19d508223d65ab1a3b35f902c78af6c5d37d26582"}}
```




### Q: Wen Facet on mainnet?

A: Middlemarch writes / posts on Nov, 17th <https://twitter.com/dumbnamenumbers/status/1725289872876032457>

Exciting Facet Update!

The Facet Virtual Machine is feature-complete, and we are thrilled to announce that it launches on mainnet on block 18684900!

In the meantime:

- We will launch a release candidate on Goerli.
- Join our $25k BUG BASH! 
- And more!

Our release candidate represents a substantial improvement over the version of the protocol we have been testing on Goerli.

However, it is not compatible, which means that in order to test the new version, 
we will need to "reset" everything currently on Goerli.

On Monday morning ET, the VM will transition to the release candidate protocol version. 
Bridge balances will be airdropped to their owners.

Thank you to our Goerli testers for the amazing feedback! We appreciate your patience as we prepare to test the production protocol.


**BUG BASH!**

Starting now, if you find a bug that could result in the loss of funds in the Facet VM, 
a Dumb Contract, or any of our bridge Smart Contracts, you can win up to $25k USDC!

Stay tuned for more details, but start hunting now! 

https://github.com/0xFacet/facet-vm/tree/rc1

The Facet thesis: Smart Contracts are unnecessary. Eliminate them and unlock Ethereum's full potential at a fraction of the cost.

Regardless of whether this thesis resonates with you or seems utterly insane, one thing is certain: if it proves to be true, it will spark a Blockchain Revolution.

We will discover the truth in just a few weeks!

Thank you to the Facet community, who has supported our vision from the very beginning!

The Blockchain Revolution commences on November 30...


