# Notes & Todos


## todos

``` ruby
tick = tick.cast(:string)
    id = id.cast(:uint256)
    amt = amt.cast(:uint256)
```
add cast to ojbect ?? using this syntax - why? why not?

``` ruby
    tick = tick.cast( String )
    id = id.cast( UInt )
    amt = amt.cast( UInt )

## or alternate with global converter functions???

    tick = String( tick )
    id =   UInt( id )
    amt =  UInt( amt )
```

## more todos

- [ ] add event as a typed class!!! using build_class and such


## check


- change address(0) to Address(0) - why? why not?
-   make all Types in  Bet(0) - same as Bet.zero
-     Bool(0) ???, String(0), etc.
-     UInt(4),  Int(3)
-   will "forward" to convert!!!
-     different from ruby's (try_convert) WILL raise error/exception
-      if cannot convert!!!!!!!
-
-  for structs and enum only make ("global")
-     converter functions available only in scope - why? why not?



## Today's Todos

- [ ]  add test_enums (from enums) !!!
- [ ]  add mapping chaper / page to rubidity by example?
- [ ]  start  rubidity.starter   (quick starter with universum samples)
- [ ] add supplychain test runner script !!!!

- [ ]  make event into a struct-like typed class (with class builder)!!!!!!


## Todos

- [ ]   move Typed::Type to Type AND move AddressType, etc into Type NOT Types:: - why? why not?
      let's yo use Type instead of (ugly/weird) Typed::Type


- [ ]  add sig (or solsig? or abisig or abi?) to AddressType, UIntType and such
        ALWAYS return solidity abi sig!! e.g. uint256, 
        and tuple() for structs and uint8 for enums and such!!!


## More Todos

- [ ] move tests over from  universum safe structs!!!!
- [ ] convert uniswap familiy to (more ruby-ish) rubidity 


## Changelog

-  change Uint256, Int256 to Uint, Int for now!!
-  change Uint to UInt (same in swift, c#, ...)
-  change ethscriptionId to inscription id


## Todos

- [ ]  add (type) alias for :uint, :int (for uint256 and int256)


---

1.  add ERRORS.md  page
    - list all ruby errors/exceptions
    - ask what and if (custom) errors to add

2.  add  export to_abi_json (or such!!)
3.  add more conversion.rb  global conversion functions e.g. address(), string(), etc.


---

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
```
