# Rubidity Typed

rubidity-typed - "zero-dependency" type machinery incl. (frozen) string, address, uint256, contract and more for rubidity - ruby for layer 1 (l1) contracts with "off-chain" indexer


* home  :: [github.com/s6ruby/rubidity](https://github.com/s6ruby/rubidity)
* bugs  :: [github.com/s6ruby/rubidity/issues](https://github.com/s6ruby/rubidity/issues)
* gem   :: [rubygems.org/gems/rubidity-typed](https://rubygems.org/gems/rubidity-typed)
* rdoc  :: [rubydoc.info/gems/rubidity-typed](http://rubydoc.info/gems/rubidity-typed)



## What's Rubidity?!

middlemarch (a.k.a. Tom Lehman) 
introduced dumb contracts on ethscriptions with the production code written in a dialect of Ruby called "Rubidity". 

Q: Why do you choose ruby for dump contracts? 

A: Because you can create a mini-language that's very similar to Solidity and will be easier for Solidity devs to use. 

For official doc(ument)s and sources see:

- <https://github.com/ethscriptions-protocol/ethscriptions-vm-server> - Source
- <https://docs.ethscriptions.com/v/ethscriptions-vm/rubidity/rubidity-by-example> - Documentation 
- <https://goerli.ethscriptionsvm.com/contracts> - Test Chain - Live!



## What's Happening Here?

This is a rubidity sandbox by [Gerald Bauer](https://github.com/geraldb). 
The idea here is to experiment with rubidity "off-chain"
and if time permits break the "majestic rails rubidity monolith"
also known as "ethscriptions vm"
up into easier to (re)use modules / gems.

This is the "zero-dependency" rubidity-typed module / gem for the type machinery
incl. (frozen) string, address, uint256, contract and more 



## Data Types

### Available Value & Reference Types

Value Types

* `:string`: Text-based data. Rubidity strings are immutable (frozen).
* `:address`: Ethereum address (in hexadecimal).
* `:dumbContract`: A specific type of contract ID (hexadecimal).
* `:addressOrDumbContract`: Either an Ethereum address or a specific type of contract ID.
* `:ethscriptionId`: Unique identifiers for Ethscriptions (hexadecimal).
* `:bool`: Boolean values (true or false).
* `:uint256`: Unsigned 256-bit integers.
* `:int256`: Signed 256-bit integers.
* `:datetime`: Date and time (stored as unsigned 256-bit integers).

Reference Types

* `:mapping`: Key-value storage for different types.
* `:array`: Lists of other types.


### Zero (Default) Values

In Rubidity, every type comes with a zero (default) value 
that gets assigned when a variable is declared but not initialized. 
Understanding these defaults is crucial for avoiding unintended behavior in your code. 
Here is the rundown:

* **Integers (:int256, :uint256, :datetime)**: Default to `0`.
* **Address Types (:address, :addressOrDumbContract)**: Default to a zero-address, which is `0x0000000000000000000000000000000000000000`.
* **Contract Identifiers (:dumbContract, :ethscriptionId)**: Default to a zero-identifier, `0x0000000000000000000000000000000000000000000000000000000000000000`.
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
* **:dumbContract and :ethscriptionId**: Accepts hexadecimal strings matching specific patterns (`0x` followed by 64 hexadecimal characters).
* **:addressOrDumbContract**: Accepts either an address or a `:dumbContract`, again matching the relevant hexadecimal patterns.
* **:datetime**: Relies on `:uint256` type coercion, as it's represented as an unsigned integer internally.
* **:mapping**: Accepts a Hash and ensures that keys and values match the specified types. Coerces these into a typed mapping object (`TypedMapping`).
* **:array**: Accepts an array and ensures that the values match the specified type. Coerces these into a typed array object (`TypedArray`).



## Usage


Let's try some random low-level use:


``` ruby
require 'rubidity/typed'

pp Type::TYPES
#=> [:string,
#    :mapping,
#    :address,
#    :dumbContract,
#    :addressOrDumbContract,
#    :ethscriptionId,
#    :bool,
#    :address,
#    :uint256,
#    :int256,
#    :array,
#    :datetime]


pp Type.value_types   ## excludes mapping & array
#=> [:string,
#    :address,
#    :dumbContract,
#    :addressOrDumbContract,
#    :ethscriptionId,
#    :bool,
#    :address,
#    :uint256,
#    :int256,
#    :datetime]




t = Type.create( :string )
pp t
t = Type.create( :string )
pp t
t = Type.create( :string )
pp t

t = Type.create( :address )
pp t
pp t.default_value
pp t.zero


pp t.name

t = Type.create( :mapping, key_type: :addressOrDumbContract,
                           value_type: :uint256 )
# pp t.metadata 
pp t.name
pp t.format
pp t.key_type 
pp t.value_type


pp t.address?
pp t.array?
pp t.mapping?
pp t.uint256?
pp t.string?


t = StringType.instance 
pp t
pp t.format
pp t.to_s
pp t.name
pp t.inspect

t = BoolType.instance
pp t    ## uses t.pretty_print_inspect
p  t    ## uses t.inspect
pp t.format
pp t.to_s
pp t.name
pp t.zero
pp t.default_value

puts "hash:"
pp t.hash
pp t.hash
pp t.hash
pp t.inspect
pp t.is_value_type?
pp t.bool?
pp t.uint256?

pp BoolType.instance == BoolType.instance
pp BoolType.instance == Uint256Type.instance



str  =  TypedVariable.create(:string, 'hello, world!')
pp str
pp str.type
pp str.value
pp str.value.frozen?

str  =  TypedVariable.create(:string )
pp str
pp str.type
pp str.value
pp str.value.frozen?

addr =  TypedVariable.create(:address)  ## zero(0) / default address
pp addr
pp addr.type
pp addr.value
pp addr.value.frozen?

pp ADDRESS_ZERO
pp ADDRESS_ZERO.frozen?



name   = TypedVariable.create( :string ) 
symbol = TypedVariable.create( :string ) 

pp name
pp name.type
pp name.value
pp name.downcase
pp name.index( 'hello' )


puts
pp symbol
pp symbol.type
pp symbol.value

name.value = 'hello'
pp name
pp name.value
pp name.value.frozen?

puts "symbol:<" + symbol + ">- name:<" + name + ">"
puts "symbol:<#{symbol}>- name:<#{name}>"



decimals     = TypedVariable.create( :uint256 )
totalSupply  = TypedVariable.create( :uint256 )
pp decimals
pp totalSupply

decimals.value = 18
totalSupply.value = 21000000


pp decimals
pp totalSupply
pp totalSupply.serialize


balanceOf = TypedVariable.create :mapping, key_type:   :addressOrDumbContract,
                                           value_type: :uint256


pp balanceOf



balanceOf.value['0xC2172a6315c1D7f6855768F843c420EbB36eDa97'] = 21000000
balanceOf['0xC2172a6315c1D7f6855768F843c420EbB36eDa97'] = 21000000

pp balanceOf


old_state = balanceOf.serialize
puts old_state.class.name  
#=> Hash


balanceOf['0xC2172a6315c1D7f6855768F843c420EbB36eDa97'] = 0
pp balanceOf.serialize

puts "old_state:"
pp old_state

balanceOf.value = old_state


pp balanceOf.serialize


balanceOf.deserialize( {} )
pp balanceOf.serialize
```



And so on.  To be continued ...





## Bonus - More Blockchain (Crypto) Tools, Libraries & Scripts In Ruby

See [**/blockchain**](https://github.com/rubycocos/blockchain) 
at the ruby code commons (rubycocos) org.
