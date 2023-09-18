# Rubidity Lang Notes


## Ideas

change

``` ruby
mapping ({ addressOrDumbContract: :uint256 }), :balanceOf
mapping ({ addressOrDumbContract: mapping(addressOrDumbContract: :uint256) }), :allowance
```

to

``` ruby
mapping [:addressOrDumbContract, :uint256],  :balanceOf 
mapping [:addressOrDumbContract, mapping[:addressOrDumbContract, :uint256]], :allowance
```

why? why not?


## Todos

- [ ]  change TypedVariable to "stand-alone" legacy creator only
       and use new Typed class for base, is_a?(Typed)
       and all .new MUST be per class (no "generic") available for now - why? why not?

- use later Typed.var( ) for generic create or such? - why? why not?


## More


ContractImplementation

move #mock with Contract db use out of lang??


more contract samples with source
see

https://goerli.ethscriptionsvm.com/contracts







---
notes from discord:

```
We definitely need off-chain for testing the on-chain 
and we have the start of a decent solution here: 
https://github.com/ethscriptions-protocol/ethscriptions-vm-server/blob/main/app/models/contract_test_helper.rb#L42. 
If you call this method you don't have to know anything about the chain. 
But right now this is only for testing purposes. 
In order for a user to deploy and call DCs in their browser etc 
they need to use Goerli and we should change this!

I also agree that the importance of this tech goes beyond blockchain applications, but I try to keep most grandiose thoughts to myself.

I definitely agree that we should extract Rubidity into its own gem; it's definitely a mess now.

Finally, BIG QUESTION: do you know how we could create a "sandbox"-type thing 
that we could use to prevent DC [dump contracts]s from infinite loops 
in a deterministic (ie gas-based not time-based) way? 
If we could do this we could run arbitrary DCs which would actually finally be "game over"!
```
