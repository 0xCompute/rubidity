# Facet Next -  Critique / Ideas For A Better "Off-Chain" Compute Protocol


this page started with these comments / questions / critique:

> congrats to the new docs. 
>
>>  Finally, check out our new docs!
>>  https://docs.facet.org/
>
> if i may ask some tech questions 
> ( i know sorry maybe too early to tell for sure - kind of nostalgic about the idea of "solidity datatypes and abi-compatible neutral compute protocol"  in the old ethscriptions vm docs):
>
> - Q:  Is facet and are (dumb) contract tied to rubidity? 
> - Q: Any plans for a more "generic" compute engine / protocol?   e.g. the (facet) inscription create¹ and call op text looks "language-neutral".  except note 1) why add the source code in rubidity in an inscription (over and over again) if the vm (and indexer) itself is off-chain anyways?
> - Q:  Isn't the consequence  of not being a language "neutral" protocol that many more compute vms will follow / launch SOON? Any comments?  



let's try "to fix" the facet protocol step-by-step.


## 1) New Calldata Format - Don't Use Data URIs/URLs - Don't "Pollute" Classic Inscriptions (aka Ethscriptions)

> All Facet transactions are Ethscriptions. 
> However, the Ethscriptions Protocol is entirely separate from Facet. 
> Facet depends on Ethscriptions, but Ethscriptions users need-not use Facet
> (or even be aware it exists).
>
> -- [Facet Docs](https://docs.facet.org/how-facet-works/the-basic-idea#ethscriptions)


Why?

There's no point of trading (transfering) compute insccriptions? 
Or is there?

The facet data uri/url starts:

    data:application/vnd.facet.tx+json;esip6=true,


What's wrong?


Why "pollute" the classic inscription "namespace" and numbering
with useless compute inscriptions?

Let's change the calldata to its own "namespace". Why?

1. shorter! less bytes, clearer.
2. always allows duplicates.  no funny / silly esip-6=true opt-in flag on every inscribe.
3. remove the "facet" branding / trademark and let's go generic and public domain free for all
4.  the facet data uri/url looks like a data uri/url but defaults to non-standard utf8 extension and, thus, is in a strict rfc-2397 spec reading NOT a valid data uri/url


Here's the before

```
data:application/vnd.facet.tx+json;esip6=true,
{"op":"create",... "source_code": "...contract(:EtherBridgeV2 ...", ...}
```

becomes after:

```
CREATE EtherBridgeV2 ...     
```

or

```
CREATE EtherBridgeV2 CODE/1.0 ...
```

with CODE being the new generic protocol name anyone can use (no branding / trademark)
and 1.0 the protocol version.

and 

```
data:application/vnd.facet.tx+json;esip6=true,
{"op":"call", ... "function": "mint", ...}
```

becomes after:

```
CALL mint ...     
```

or

```
CALL mint CODE/1.0 ...
```

Yes, the facet protocol for now has only two operations, that is, CREATE and CALL.




## 2) New Payload Format - Is Text the New JSON?

Now what about all the other "stuff" in the facet inscriptions
that's encoded in java script object notation (JSON)?
Example.

```
data:application/vnd.facet.tx+json;esip6=true,
{"op":"create",
 "data":{"args":
           {"name":"Ether",
            "symbol":"ETH",
            "trustedSmartContract":"0x9d2f33af8610f1b53dd6fce593f76a2b4b402176"},
            "source_code":"pragma(:rubidity, \"1.0.0\")\ncontract(:ERC20, abstract: true)...","init_code_hash":"0x1e1ee21ee8811331d2aef4c19d508223d65ab1a3b35f902c78af6c5d37d26582"}}
```

How about:

```
CREATE EtherBridgeV2 CODE/1.0
name: Ether
symbol: ETH
trustedSmartContract: 0x9d2f33af8610f1b53dd6fce593f76a2b4b402176
```

Let's remove the "useless" source code and "init_code_hash" args. 
More important why use "useless" quotes around keys 
or why the "deep" nesting? let's keep it simple and go plain text 
(always utf8 encoded!)


Why not binary?  Good question.  
Let's do binary in version 2.0. Let's start simple.




To be continued...   a "generic" compute ("execution) model 
that is using solidity datatypes and solidity abi-compatible.

The biggie?  Why use / invent a new language? 

> Dumb Contracts are written in a new language called Rubidity, 
> which is a cross between Ruby and Solidity. 
> Rubidity uses Ruby syntax but Rubidity isn't always semantically valid Ruby. 
> Instead, before Rubidity can be executed, it is transpiled into Ruby. 

That's setting yourself up for failure.
Good luck with building out the Rubidity ecosystem! 
See here -> <https://www.tiobe.com/tiobe-index/>

Re(use) top languages and do NOT invent new ones. 







## Appendix

### More Before/After Samples


#### A simple ERC20 mint transaction:

```
data:application/vnd.facet.tx;rule=esip6,{
    "op": "call",
    "data": {
        "to": "0x1234eccd1000898941bc19d3f356322783941fa6",
        "function": "mint",
        "args": {
            "amount": "1000000000000000000000"
        }
    }
}
```

=> vs.

```
CALL mint@0x1234eccd1000898941bc19d3f356322783941fa6 CODE/1.0
amount: 1000000000000000000000
```



#### A more complicated UniswapV2-style swap:

```
data:application/vnd.facet.tx;rule=esip6,{
    "to": "0xcce2f1662d48863d57a973b95e1c49b485493511",
    "data": {
        "function": "swapExactTokensForTokens",
        "args": {
            "amountIn": "1000000000000000",
            "amountOutMin": "655554569872882432",
            "path": [
                "0xbff0ad0b619402df413b3f3420138b6db4d88ce8",
                "0xc0d04bb0beefc79159454b8cf8d7fc5e11f5d28a"
            ],
            "to": "0x9927e3e2e789497312c28D539D016b693CB2b622",
            "deadline": "1000000000000000000"
        }
    }
}
```

=> vs.

```
CALL swapExactTokensForTokens@0xcce2f1662d48863d57a973b95e1c49b485493511 CODE/1.0
amountIn: 1000000000000000
amountOutMin: 655554569872882432
path: 0xbff0ad0b619402df413b3f3420138b6db4d88ce8,
      0xc0d04bb0beefc79159454b8cf8d7fc5e11f5d28a
to: 0x9927e3e2e789497312c28D539D016b693CB2b622
deadline: 1000000000000000000
```




## Questions? Comments?

Join us in the [Rubidity & Rubysol (community) discord (chat server)](https://discord.gg/3JRnDUap6y). Yes you can.
Your questions and commentary welcome.

Or post them over at the [Help & Support](https://github.com/geraldb/help) page. Thanks.

