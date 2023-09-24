# Rubidity Typed

rubidity-typed - "zero-dependency" type machinery incl. (frozen) string, address, uint256, contract and more for rubidity - ruby for layer 1 (l1) contracts with "off-chain" indexer


* home  :: [github.com/s6ruby/rubidity](https://github.com/s6ruby/rubidity)
* bugs  :: [github.com/s6ruby/rubidity/issues](https://github.com/s6ruby/rubidity/issues)
* gem   :: [rubygems.org/gems/rubidity-typed](https://rubygems.org/gems/rubidity-typed)
* rdoc  :: [rubydoc.info/gems/rubidity-typed](http://rubydoc.info/gems/rubidity-typed)



## What's Rubidity?!

See [**Rubidity - Ruby for Layer 1 (L1) Contracts / Protocols with "Off-Chain" Indexer**  »](https://github.com/s6ruby/rubidity)



## Data Types

### Available Value & Reference Types

Value Types

* `:string`: Text-based data. Rubidity strings are immutable (frozen).
* `:address`: Ethereum address (in hexadecimal).
* `:ethscriptionId`: Unique identifiers for Ethscriptions (hexadecimal).
* `:bool`: Boolean values (true or false).
* `:uint256`: Unsigned 256-bit integers.
* `:int256`: Signed 256-bit integers.
* `:datetime`: Date and time (stored as unsigned 256-bit integers).

<!--
* `:dumbContract`: A specific type of contract ID (hexadecimal).
* `:addressOrDumbContract`: Either an Ethereum address or a specific type of contract ID.
-->


Reference Types

* `:mapping`: Key-value storage for different types.
* `:array`: Lists of other types.


### Zero (Default) Values

In Rubidity, every type comes with a zero (default) value 
that gets assigned when a variable is declared but not initialized. 
Understanding these defaults is crucial for avoiding unintended behavior in your code. 
Here is the rundown:

* **Integers (:int256, :uint256, :datetime)**: Default to `0`.
* **Address Types (:address)**: Default to a zero-address, which is `0x0000000000000000000000000000000000000000`.
* **Contract Identifiers (:ethscriptionId)**: Default to a zero-identifier, `0x0000000000000000000000000000000000000000000000000000000000000000`.
* **String (:string)**: Default to an empty string `''`.
* **Boolean (:bool)**: Default to `false`.
* **Mapping (:mapping)**: Default to an empty mapping object. The key and value types are set according to your specifications.
* **Array (:array)**: Default to an empty array object. The sub type is set according to your specification.



### Literals & Type Coercion and Validation

Rubidity employs a strong system of type validation and coercion to ensure that variables adhere to their declared types. This involves transforming literal values into the corresponding Rubidity types and reporting type mismatches.

Here's a brief rundown of Rubidity's type coercion rules:

* **:address**: Accepts hexadecimal strings that match the Ethereum address format (`0x` followed by 40 hexadecimal characters). The address is then normalized to lowercase.
* **:uint256 and :int256**: These types accept both integer and string representations. Strings are attempted to be coerced into integers. uint256 and int256 cannot be out of the range of their Solidity counterparts.
* **:string**: Only accepts string literals. Note: strings are immutable (frozen).
* **:bool**: Accepts only `true` or `false`.
* **:ethscriptionId**: Accepts hexadecimal strings matching specific patterns (`0x` followed by 64 hexadecimal characters).
* **:datetime**: Relies on `:uint256` type coercion, as it's represented as an unsigned integer internally.
* **:mapping**: Accepts a Hash and ensures that keys and values match the specified types. Coerces these into a typed mapping object (`TypedMapping`).
* **:array**: Accepts an array and ensures that the values match the specified type. Coerces these into a typed array object (`TypedArray`).




## Usage


Let's try some random use:




``` ruby
require 'rubidity/typed'

#####################################
#   frozen (immutable ) value types


#  note: (typed) strings always use utf-8 encoding AND
#               are frozen/immutable!!!
a = TypedString.new                    #=> <val string:"">
a = TypedString.new( "hello, world!" ) #=> <val string:"hello, world!">


a = TypedUint256.new                   #=> <val uint256:0>
a = TypedUint256.new(100)              #=> <val uint256:100>
a += 100                               #=> <val uint256:200>
a -= 100                               #=> <val uint256:100>

#  use/add TypedNat(ural) (natural integer number) alias - why? why not?
#    check if natural numbers start at 0 (or exclude 0 ????)

a = TypedInt.new                       #=> <val int256:0>
a = TypedInt.new( 100 )                #=> <val int256:100>
a += 100                               #=> <val int256:200>
a -= 100                               #=> <val int256:100>

# 
#  idea  - use "plain" integer as TypedInt - why? why not?


a  = TypedBool.new                    #=> <val bool:false>
a  = TypedBool.new( true )            #=> <val bool:true>

# 
#  idea - use "plain" true|false  as TypedBool (frozen|typed)


a = TypedAddress.new
#=> <val address:"0x0000000000000000000000000000000000000000">
a = TypedAddress.new( '0x'+ 'aa'*20 )
#=> <val address:"0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa">


a = TypedEthscriptionId.new
#=> <val ethscriptionId:"0x0000000000000000000000000000000000000000000000000000000000000000">
a = TypedEthscriptionId.new( '0x'+'ab'*32 )
#=> <val ethscriptionId:"0xabababababababababababababababababababababababababababababababab">


a = TypedBytes32.new
#=> <val bytes32:"0x0000000000000000000000000000000000000000000000000000000000000000">
a = TypedBytes32.new( '0x'+'ab'*32 )
#=> <val bytes32:"0xabababababababababababababababababababababababababababababababab">

a = TypedDatetime.new               #=> <val datetime:0>

#  use/change/rename to Timestamp - why? why not?
#    ALWAYS uses epoch time starting at 0 (no time zone or such)



#
#  todo/check:  is bytes a (mutabale)bytebuffer or a frozen/immutable?
a = TypedBytes.new                 #=> <val bytes:""> 


###########################
# reference types

a = TypedArray.new( sub_type: :string )
#=> <ref string[]:[]>
a.type    #=> <type string[]>

a = TypedArray.new( ['zero', 'one', 'two'], sub_type: :string )
#=>  <ref string[]:
#       [<val string:"zero">, <val string:"one">, <val string:"two">]>
a[0]                  #=> <val string:"zero">
a[1]                  #=> <val string:"one">
a[2]                  #=> <val string:"two"> 
a.length              #=> 3
a.push( 'three' )
a[3]                  #=> <val string:"three">
a[4] = 'four'
a[4]                  #=> <val string:"four">
a.length              #=> 5
a.serialize           #=> ["zero", "one", "two", "three", "four"]

#  todo/check:  add a "convenience" TypedStringArray or TypedArray<String>
#                  use special unicode-chars for <>??

a = TypedArray.new( sub_type: :uint256 )
#=> <ref uint256[]:[]>
a.type             #=> <type uint256[]>

a = TypedArray.new( [0,1,2], sub_type: :uint256 )
#=> <ref uint256[]:
#      [<val uint256:0>, <val uint256:1>, <val uint256:2>]> 
a[0]               #=> <val uint256:0>
a[1]               #=> <val uint256:1>
a[2]               #=> <val uint256:2>
a.length           #=> 3
a.push( 3 )
a[3]               #=> <val uint256:3>
a[4] = 4
a[4]               #=> <val uint256:4>
a.length           #=> 5
a.serialize        #=> [0, 1, 2, 3, 4]

#  todo/check:  add a "convenience" TypedUintArray or TypedArray<Uint>
#                  use special unicode-chars for <>??


alice   = '0x'+ 'aa'*20
bob     = '0x'+ 'bb'*20
charlie = '0x'+ 'cc'*20

a = TypedMapping.new( key_type: :address, value_type: :uint256 )
#=> <ref mapping(address=>uint256):{}>
a.type                #=> <type mapping(address=>uint256)>

a = TypedMapping.new( { alice   =>  100,
                        bob     =>  200 },
                       key_type: :address, value_type: :uint256 )
#=> <ref mapping(address=>uint256):
#     {<val address:"0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa">=><val uint256:100>, 
#      <val address:"0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb">=><val uint256:200>}>

a[ alice ]            #=> <val uint256:100>
a[ bob ]              #=> <val uint256:200> 
a[ charlie ]          #=> <val uint256:0>
a[ charlie ] = 300
a[ charlie ]          #=> <val uint256:300>

a.serialize
#=> {"0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"=>100,
#    "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"=>200,
#    "0xcccccccccccccccccccccccccccccccccccccccc"=>300}

```



And so on.  To be continued ...





## Bonus - More Blockchain (Crypto) Tools, Libraries & Scripts In Ruby

See [**/blockchain**](https://github.com/rubycocos/blockchain) 
at the ruby code commons (rubycocos) org.
