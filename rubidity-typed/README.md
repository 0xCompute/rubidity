# Rubidity Typed

rubidity-typed - "zero-dependency" 100%-solidity compatible data type machinery incl. (frozen) string, address, uint, int, enum, struct, array, mapping, and more for rubidity - ruby for layer 1 (l1) contracts / protocols with "off-chain" indexer



* home  :: [github.com/s6ruby/rubidity](https://github.com/s6ruby/rubidity)
* bugs  :: [github.com/s6ruby/rubidity/issues](https://github.com/s6ruby/rubidity/issues)
* gem   :: [rubygems.org/gems/rubidity-typed](https://rubygems.org/gems/rubidity-typed)
* rdoc  :: [rubydoc.info/gems/rubidity-typed](http://rubydoc.info/gems/rubidity-typed)



## What's Rubidity?!

See [**Rubidity - Ruby for Layer 1 (L1) Contracts / Protocols with "Off-Chain" Indexer**  »](https://github.com/s6ruby/rubidity)



## Data Types


### Available Value & Reference Types

Value Types

* `:string`: Text-based data (in utf8). Rubidity strings are immutable (frozen).
* `:address`: Ethereum address (in hexadecimal) - 20 bytes (40 hexchars).
* `:inscriptionId`: Unique identifiers for Inscriptions (hexadecimal) - 32 bytes (64 hexchars).
* `:bool`: Boolean values (true or false).
* `:uint`: Unsigned 256-bit integers.
* `:int`: Signed 256-bit integers.
* `:timestamp`: Date and time (stored as unsigned 256-bit integers. unix epoch starting in 1970).

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

* **Integers (:int, :uint, :timestamp)**: Default to `0`.
* **Address Types (:address)**: Default to a zero-address, which is `0x0000000000000000000000000000000000000000`.
* **Inscription Identifiers (:inscriptionId)**: Default to a zero-identifier, `0x0000000000000000000000000000000000000000000000000000000000000000`.
* **String (:string)**: Default to an empty string `''`.
* **Boolean (:bool)**: Default to `false`.
* **Mapping (:mapping)**: Default to an empty mapping object. The key and value types are set according to your specifications.
* **Array (:array)**: Default to an empty array object. The sub type is set according to your specification.



### Literals & Type Coercion and Validation

Rubidity employs a strong system of type validation and coercion to ensure that variables adhere to their declared types. This involves transforming literal values into the corresponding Rubidity types and reporting type mismatches.

Here's a brief rundown of Rubidity's type coercion rules:

* **:address**: Accepts hexadecimal strings that match the Ethereum address format (`0x` followed by 40 hexadecimal characters). The address is then normalized to lowercase.
* **:uint and :int**: These types accept both integer and string representations. Strings are attempted to be coerced into integers. uint and int cannot be out of the range of their Solidity counterparts.
* **:string**: Only accepts string literals. Note: strings are immutable (frozen).
* **:bool**: Accepts only `true` or `false`.
* **:inscriptionId**: Accepts hexadecimal strings matching specific patterns (`0x` followed by 64 hexadecimal characters).
* **:timestamp**: Relies on `:uint` type coercion, as it's represented as an unsigned integer internally.
* **:mapping**: Accepts a Hash and ensures that keys and values match the specified types. Coerces these into a typed mapping object (`TypedMapping`).
* **:array**: Accepts an array and ensures that the values match the specified type. Coerces these into a typed array object (`TypedArray`).




## Usage


Let's try some random use:




``` ruby
require 'rubidity/typed'


module Sandbox   ## note: "wrap" in sandbox (auto-)incl. (rubidity) types 

#####################################
#   frozen (immutable ) value types


#  note: (typed) strings always use utf-8 encoding AND
#               are frozen/immutable!!!
a = String.new                    #=> <val string:"">
a = String.new( 'hello, world!' ) #=> <val string:"hello, world!">


a = UInt.new                      #=> <val uint:0>
a = UInt.new( 100 )               #=> <val uint:100>
a += 100                               #=> <val uint:200>
a -= 100                               #=> <val uint:100>

#  use/add TypedNat(ural) (natural integer number) alias - why? why not?
#    check if natural numbers start at 0 (or exclude 0 ????)

a = Int.new                       #=> <val int:0>
a = Int.new( 100 )                #=> <val int:100>
a += 100                               #=> <val int:200>
a -= 100                               #=> <val int:100>

# 
#  idea  - use "plain" integer as TypedInt - why? why not?


a  = Bool.new                    #=> <val bool:false>
a  = Bool.new( true )            #=> <val bool:true>

# 
#  idea - use "plain" true|false  as TypedBool (frozen|typed)


a = Address.new
#=> <val address:"0x0000000000000000000000000000000000000000">
a = Address.new( '0x'+ 'aa'*20 )
#=> <val address:"0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa">


a = InscriptionId.new
#=> <val inscriptionId:"0x0000000000000000000000000000000000000000000000000000000000000000">
a = InscriptionId.new( '0x'+'ab'*32 )
#=> <val inscriptionId:"0xabababababababababababababababababababababababababababababababab">


a = Bytes32.new
#=> <val bytes32:"0x0000000000000000000000000000000000000000000000000000000000000000">
a = Bytes32.new( '0x'+'ab'*32 )
#=> <val bytes32:"0xabababababababababababababababababababababababababababababababab">

a = Timestamp.new               #=> <val timestamp:0>

#  use/change/rename to Timestamp - why? why not?
#    ALWAYS uses epoch time starting at 0 (no time zone or such)



#
#  todo/check:  is bytes a (mutabale)bytebuffer or a frozen/immutable?
a = Bytes.new                 #=> <val bytes:""> 


###########################
# reference types


# todo/check:  make build_class alias to new?
Array‹String› = Array.build_class( String )    
Array‹String›.type      #=> <type string[]>

a = Array‹String›.new   #=> <ref string[]:[]>

a = Array‹String›.new( ['zero', 'one', 'two'] )
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

Array‹UInt› = Array.build_class(  UInt )
Array‹UInt›.type      #=> <type uint[]>

a = Array‹UInt›.new   #=> <ref uint[]:[]>

a = Array‹UInt›.new( [0,1,2] )
#=> <ref uint[]:
#      [<val uint:0>, <val uint:1>, <val uint:2>]> 
a[0]               #=> <val uint:0>
a[1]               #=> <val uint:1>
a[2]               #=> <val uint:2>
a.length           #=> 3
a.push( 3 )
a[3]               #=> <val uint:3>
a[4] = 4
a[4]               #=> <val uint:4>
a.length           #=> 5
a.serialize        #=> [0, 1, 2, 3, 4]

#  todo/check:  add a "convenience" TypedUIntArray or TypedArray<UInt>
#                  use special unicode-chars for <>??


alice   = '0x'+ 'aa'*20
bob     = '0x'+ 'bb'*20
charlie = '0x'+ 'cc'*20


Mapping‹Address→UInt›  = Mapping.build_class( Address, UInt )
Mapping‹Address→UInt›.type    #=> <type mapping(address=>uint)>

a = Mapping‹Address→UInt›.new
#=> <ref mapping(address=>uint):{}>

a = Mapping‹Address→UInt›.new( { alice   =>  100,
                                                bob     =>  200 },
                                            )
#=> <ref mapping(address=>uint):
#     {<val address:"0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa">=><val uint:100>, 
#      <val address:"0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb">=><val uint:200>}>

a[ alice ]            #=> <val uint:100>
a[ bob ]              #=> <val uint:200> 
a[ charlie ]          #=> <val uint:0>
a[ charlie ] = 300
a[ charlie ]          #=> <val uint:300>

a.serialize
#=> {"0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"=>100,
#    "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"=>200,
#    "0xcccccccccccccccccccccccccccccccccccccccc"=>300}


#
# more - enums, structs, etc.

Color = Enum.build_class( :Color, :red, :green, :blue )
Color.type     #=> <type Color enum(red,green,blue)>

Color::RED     #=> <val Color enum(red,green,blue):red(0)>
Color.red      #=> <val Color enum(red,green,blue):red(0)>

Color::GREEN   #=> <val Color enum(red,green,blue):red(0)>
Color.green    #=> <val Color enum(red,green,blue):red(0)>

Color.min      #=> <val Color enum(red,green,blue):red(0)>
Color.max      #=> <val Color enum(red,green,blue):blue(2)>

color = Color.green
color.serialize   #=> 1 

color = Color.red
color.serialize   #=> 0



Bet = Struct.build_class( :Bet, 
                            user:    Address,
                            block:   UInt,
                            cap:     UInt,
                            amount:  UInt  )
Bet.type


bet = Bet.new
bet.user
bet.amount

bet.user   = Address.new( '0x'+'aa'*20 )
bet.amount = UInt.new( 123 )

bet.user   = '0x'+'bb'*20    ## literal assign (with typecheck)
bet.amount = 234             ## literal assign (with typecheck)

bet.serialize

bet = Bet.new( '0x'+'cc'*20,  0, 0, 456, 
bet.serialize

# ...

end  # module Sandbox
```


And so on.  To be continued ...





## Bonus - More Blockchain (Crypto) Tools, Libraries & Scripts In Ruby

See [**/blockchain**](https://github.com/rubycocos/blockchain) 
at the ruby code commons (rubycocos) org.
