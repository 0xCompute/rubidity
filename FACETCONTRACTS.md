# Facet (Dumb) Contracts  


## Frequently Asked Questions (F.A.Q.s) and Answers


Q: might be a dumb (lol) question, but does facet include the ability to deploy arbitrary dumb contract bytecode or is it limited to the set of contracts that currently display on the facetscan website?

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



