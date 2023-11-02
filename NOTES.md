# Notes & Todos

## fix

-  fix as_data in event !!!
   return a hash with key/value (not only values)!!!

## more todo

- [ ]  remove / kill ContractBase - merge all in Contract !!!


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


notes on contract address - create, create2


Note: Yes, contracts have nonces. A nonce of a contract is only 
incremented when that contract creates another contract.


## create

The address for an Ethereum contract is deterministically computed 
- from the address of its creator (sender) and 
- how many transactions the creator has sent (nonce). 
The sender and nonce are RLP encoded and then hashed with Keccak-256.


see <https://github.com/ethereum/pyethereum/blob/782842758e219e40739531a5e56fff6e63ca567b/ethereum/utils.py>

    def mk_contract_address(sender, nonce):
      return sha3(rlp.encode([normalize_address(sender), nonce]))[12:]


In Solidity:

    nonce0= address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), _origin, bytes1(0x80))))));
    nonce1= address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), _origin, bytes1(0x01))))));


For sender 0x6ac7ea33f8831ea9dcc53393aaa88b25a785dbf0, the contract addresses that it will create are the following:

    nonce0= "0xcd234a471b72ba2f1ccf0a70fcaba648a5eecd8d"
    nonce1= "0x343c43a37d37dff08ae8c4a11544c718abb4fcf8"
    nonce2= "0xf778b86fa74e846c4f0a1fbd1335fe81c00a0c91"
    nonce3= "0xfffd933a0bc612844eaf0c6fe3e5b8e9b6c1d19c"


## create2

A new opcode, CREATE2 was added in EIP-1014 that is another way that a contract can be created.

For contract created by CREATE2 its address will be:

    keccak256( 0xff ++ address(this) ++ salt ++ keccak256(init_code))[12:]

More information will be added here and for the meantime see EIP-1014.
<https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1014.md>


Example 0
address 0x0000000000000000000000000000000000000000
salt 0x0000000000000000000000000000000000000000000000000000000000000000
init_code 0x00
gas (assuming no mem expansion): 32006
result: 0x4D1A2e2bB4F88F0250f26Ffff098B0b30B26BF38

Example 1
address 0xdeadbeef00000000000000000000000000000000
salt 0x0000000000000000000000000000000000000000000000000000000000000000
init_code 0x00
gas (assuming no mem expansion): 32006
result: 0xB928f69Bb1D91Cd65274e3c79d8986362984fDA3

Example 2
address 0xdeadbeef00000000000000000000000000000000
salt 0x000000000000000000000000feed000000000000000000000000000000000000
init_code 0x00
gas (assuming no mem expansion): 32006
result: 0xD04116cDd17beBE565EB2422F2497E06cC1C9833

Example 3
address 0x0000000000000000000000000000000000000000
salt 0x0000000000000000000000000000000000000000000000000000000000000000
init_code 0xdeadbeef
gas (assuming no mem expansion): 32006
result: 0x70f2b2914A2a4b783FaEFb75f459A580616Fcb5e

Example 4
address 0x00000000000000000000000000000000deadbeef
salt 0x00000000000000000000000000000000000000000000000000000000cafebabe
init_code 0xdeadbeef
gas (assuming no mem expansion): 32006
result: 0x60f3f640a8508fC6a86d45DF051962668E1e8AC7
