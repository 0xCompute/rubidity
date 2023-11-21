# Ethscribe - Inscription / Inscribe (Ethscription Calldata) API Wrapper & Helpers for Ethereum & Co.

ethscribe  -  inscription / inscribe (ethscription calldata) api wrapper & helpers for Ethereum & co.



* home  :: [github.com/s6ruby/rubidity](https://github.com/s6ruby/rubidity)
* bugs  :: [github.com/s6ruby/rubidity/issues](https://github.com/s6ruby/rubidity/issues)
* gem   :: [rubygems.org/gems/ethscribe](https://rubygems.org/gems/ethscribe)
* rdoc  :: [rubydoc.info/gems/ethscribe](http://rubydoc.info/gems/ethscribe)



## What's Ethscription Calldata - Ethereum Inscription / Inscribe?!

See [Introducing Ethscriptions - A new way of creating and sharing digital artifacts on the Ethereum blockchain using transaction calldata »](https://medium.com/@dumbnamenumbers/introducing-ethscriptions-698b295d6f2a)



## Usage

This is a little "lite" wrapper around the ethscriptions.com api(s).


> The Ethscriptions.com API (v1) 
> does not require a key, however it is rate limited. 
> If you need more throughput, contact Middlemarch on Twitter.
>
> If you build something cool, also contact Middlemarch on Twitter!
>
> There is a goerli API and a mainnet API. The base URIs are:
>
> - https://goerli-api.ethscriptions.com/api
> - https://mainnet-api.ethscriptions.com/api
> 
> Append the below paths, plus a query string if you want, to access the API!
>
> -- [Introducing the Ethscriptions.com API (v1)](https://medium.com/@dumbnamenumbers/introducing-the-ethscriptions-com-api-v1-6d2c507d82cd)



The (ethereum) goerli testnet api is wrapped in `Ethscribe::Api.goerli` and
the (ethereum) mainnet api is wrapped in `Ethscribe::Api.mainnet`.

Let's try the mainnet:

```ruby
require 'ethscribe'

web = Ethscribe::Api.mainnet    # or Ethscribe::Api.goerli


## get latest 25 inscriptions (defaults: page_size=25, sort_order=desc)
pp web.ethscriptions

## get inscriptions page 1 (same as above)
pp web.ethscriptions( page: 1 ) 

# get inscriptions page 2
pp web.ethscriptions( page: 2 ) 

# get oldest first  - sort_order=asc
pp web.ethscriptions( page: 1, sort_order: 'asc' ) 
pp web.ethscriptions( page: 2, sort_order: 'asc' ) 


# get inscription by id or num
pp web.ethscription( 0 ) 
pp web.ethscription( 1 ) 
pp web.ethscription( 1000 ) 
pp web.ethscription( 1_000_000 ) 


# get inscriptions owend by <addresss>
address = '0x2a878245b52a2d46cb4327541cbc96e403a84791'
pp web.ethscriptions_owned_by( address ) 


# get inscription (decoded) content_data and content_type by id or num 
pp web.ethscription_data( 0 ) 
pp web.ethscription_data( 1 ) 
pp web.ethscription_data( 2 ) 


# check if content exists (using sha256 hash)
# inscribe no. 0
sha = '2817fd9cf901e4435253881550731a5edc5e519c19de46b08e2b19a18e95143e'
pp web.ethscription_exists( sha ) 

# inscribe no. ??
sha = '2817fd9cf901e4435253833550731a5edc5e519c19de46b08e2b19a18e95143e'
pp web.ethscription_exists( sha )  

# check the indexer (block) status
pp web.block_status
```


That's it for now.



## Bonus - More Blockchain (Crypto) Tools, Libraries & Scripts In Ruby

See [**/blockchain**](https://github.com/rubycocos/blockchain) 
at the ruby code commons (rubycocos) org.


## Questions? Comments?

Join us in the [Rubidity (community) discord (chat server)](https://discord.gg/3JRnDUap6y). Yes you can.
Your questions and commentary welcome.

Or post them over at the [Help & Support](https://github.com/geraldb/help) page. Thanks.

