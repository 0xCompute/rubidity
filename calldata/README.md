# Calldata Coders & Helpers

calldata - Calldata.encode / Calldata.decode using utf8_to_hex and hex_to_utf8 helpers and more for inscriptions / inscribes for ethereum & co


* home  :: [github.com/s6ruby/rubidity](https://github.com/s6ruby/rubidity)
* bugs  :: [github.com/s6ruby/rubidity/issues](https://github.com/s6ruby/rubidity/issues)
* gem   :: [rubygems.org/gems/calldata](https://rubygems.org/gems/calldata)
* rdoc  :: [rubydoc.info/gems/calldata](http://rubydoc.info/gems/calldata)



## What's Ethscription Calldata - Ethereum Inscription / Inscribe?!

See [Introducing Ethscriptions - A new way of creating and sharing digital artifacts on the Ethereum blockchain using transaction calldata »](https://medium.com/@dumbnamenumbers/introducing-ethscriptions-698b295d6f2a)



## Usage

[Calldata](#calldata) • [DataUri](#datauri)


### Calldata

Let's start with the Calldata encode/decode helpers.
In an inscribe the data gets incode in the the calldata (hexdata notes) of a transaction.
The calldata is a binary blob. 
Note: This gem uses hexstrings for binary blobs.

Option 1: Use the "low-level" global `utf8_to_hex` and `hex_to_utf8` helper methods:

```ruby
require 'calldata'

hex = utf8_to_hex( "data:image/png;base64,..." )
#=>  "646174613a696d6167652f706e673b6261736536342c2e2e2e"
utf8 = hex_to_utf8( "646174613a696d6167652f706e673b6261736536342c2e2e2e" )
#=>  "data:image/png;base64,..."

hex = utf8_to_hex( "Hello, World!" )
#=>  "48656c6c6f2c20576f726c6421"
utf8 = hex_to_utf8( "48656c6c6f2c20576f726c6421" )
#=>  "Hello, World!"
```

Option 2: Use the `Calldata` module helper methods `encode/encode_utf8` and `decode/decode_hex`:

``` ruby
hex = Calldata.encode( "data:image/png;base64,..." )   
#=>  "646174613a696d6167652f706e673b6261736536342c2e2e2e"
utf8 = Calldata.decode( "0x646174613a696d6167652f706e673b6261736536342c2e2e2e" )    
#=>  "data:image/png;base64,..."

hex = Calldata.encode( "Hello, World!" )
#=>  "48656c6c6f2c20576f726c6421"
utf8 = Calldata.decode( "0x48656c6c6f2c20576f726c6421" )
#=>  "Hello, World!"
```

Note: The `hex_to_utf8` helper (incl. `Calldata.decode`) 
works with or without leading `0x` in  hexstrings.



### DataUri

Let's continue with the DataUri helpers.
A valid inscribe must use a valid data uri in the calldata.

The "useless" (null) minimum is:

``` ruby

uri = "data:,"

DataUri.valid?( uri )  
#=> true
mediatype, data = DataUri.parse( uri )    ## returns mediatype (1) mimetype+parameters, 2) data)
#=> "", ""
```

Let's try the (genesis) inscribe no. 0:

``` ruby
uri = "data:,data:image/jpeg;base64,/9j/4AAQSkZJRgABAgAAZABkAAD/7AARRHV..."

DataUri.valid?( uri )  
#=> true
mediatype, data = DataUri.parse( uri )    ## returns mediatype (1) mimetype+parameters, 2) data)
#=> "image/jpeg", "<blob>"

## let's save the jpeg image (blob)
write_blob( "0.jpeg", data )
```

and voila!

![](i/0.jpeg)


Let's try the inscribe no. 15:

``` ruby
uri = "data:image/png;base64,/9j/4gxYSUNDX1BST0ZJTEUAAQEAAAxITGlubwIQAAB..."

DataUri.valid?( uri )  
#=> true
mediatype, data = DataUri.parse( uri )    ## returns mediatype (1) mimetype+parameters, 2) data)
#=> "image/png", "blob>"

## let's save the jpeg image (blob)
write_blob( "15.jpeg", data )
```

and voila!

![](i/15.png)



That's it for now.






## Bonus - More Blockchain (Crypto) Tools, Libraries & Scripts In Ruby

See [**/blockchain**](https://github.com/rubycocos/blockchain) 
at the ruby code commons (rubycocos) org.


## Questions? Comments?

Join us in the [Rubidity (community) discord (chat server)](https://discord.gg/3JRnDUap6y). Yes you can.
Your questions and commentary welcome.

Or post them over at the [Help & Support](https://github.com/geraldb/help) page. Thanks.

