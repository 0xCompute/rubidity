# Facet 


## Contract (Create & Call) Indexer / Profiler / Logger / Formater / Printer


How to use?

### Step 1: Build or (Re)Use a database built with scribelite (e.g. scribe.db, facet.db, etc.)

New to scribelite?!  see [scribelite »](../scribelite) 


let's use ethscriptions from goerli (testnet) as an example:

``` ruby
require 'scribelite'


ScribeDb.open( './facet.db' )

## switch to goerli testnet for now
Ethscribe.config.chain = 'goerli'

# page size = 25,  25*40 = 1000 ethscriptions
(1..40).each do |page|
    ScribeDb.import_ethscriptions( page: page, sort_order: 'desc' )
end

puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"
#=>   1000 scribe(s)
#=>   1000 tx(s)
```



## Step 2: Query Facet Inscriptions for Fun (& Profit)


Using the Scribe facet "scope" query helper 
you can filter out all facet inscriptions with the mediatype `application/vnd.facet.tx+json`.


``` ruby
require 'scribelite'


ScribeDb.open( './facet.db' )

puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"

facet_count  = Scribe.facet.count
pp facet_count


require_relative 'facet'   ## pullin facet (pretty) printer et al
facet = FacetPrinter.new

log = ''

Scribe.facet.order( :num ).each do |scribe|
  buf = facet.format( scribe ) 
  puts buf

  log << buf
end

write_text( "facet.log", log )
```

resulting in:

```
==> CALL PublicMintERC20.approve    @ 454702 - 2023-11-25 12:36:12 UTC   (273 Bytes) ...
      to (contract): 0xb9b5c20291293b0a136fb279cc3ed4c106cfff38, args:
["0x82dd9ceed833f78d45dd54e2a3755e022b0bad70",
 "57896044618658097711785492504343953926634992332820282019728792003956564819968"]

==> CREATE PublicMintERC20    @ 454711 - 2023-11-25 12:41:48 UTC   (3.34 KB) ...
       txid: 0x4f248c3d19f94d613f608d045e526d8faf22733a52e8f166b8aadb25da33ee58
       address: 0xa4a94f89858ff103562aaaa4b4cd362f1c0b8dfd
{"name"=>"Facet",
 "symbol"=>"Facet",
 "maxSupply"=>"21000000000000000000000000",
 "perMintLimit"=>"1000000000000000000000",
 "decimals"=>"18"}

==> CALL EthscriptionERC20Bridge.bridgeIn    @ 454779 - 2023-11-25 12:55:36 UTC   (213 Bytes) ...
      to (contract): 0xd633259f580af1fa7ae335d2f7a83746a57633c7, args:
{"to"=>"0x46b70f26bb08c20e137eb8795c16bcc4c5e90303", "amount"=>"1"}

==> CALL EtherBridge.bridgeIn    @ 454783 - 2023-11-25 13:06:12 UTC   (229 Bytes) ...
      to (contract): 0x5f5e099e59720e515114ae82b855fbcfb9bd07a9, args:
{"to"=>"0x3d540826abb85e64d76e22dbff4081b5123e163b",
 "amount"=>"100000000000000000"}

==> CALL EtherBridge.approve    @ 454785 - 2023-11-25 13:09:48 UTC   (273 Bytes) ...
      to (contract): 0x5f5e099e59720e515114ae82b855fbcfb9bd07a9, args:
["0x82dd9ceed833f78d45dd54e2a3755e022b0bad70",
 "57896044618658097711785492504343953926634992332820282019728792003956564819968"]

==> CALL FacetSwapV1Pair.approve    @ 454786 - 2023-11-25 13:10:24 UTC   (273 Bytes) ...
      to (contract): 0x8e3e671cc6d78e62797ae616ef07efcdd04c144e, args:
["0x82dd9ceed833f78d45dd54e2a3755e022b0bad70",
 "57896044618658097711785492504343953926634992332820282019728792003956564819968"]

==> CALL PublicMintERC20.approve    @ 454787 - 2023-11-25 13:10:36 UTC   (273 Bytes) ...
      to (contract): 0xeb78b8e2901c360f21ca47f7541a150320e3fee5, args:
["0x82dd9ceed833f78d45dd54e2a3755e022b0bad70",
 "57896044618658097711785492504343953926634992332820282019728792003956564819968"]

==> CALL PublicMintERC20.approve    @ 454788 - 2023-11-25 13:12:12 UTC   (273 Bytes) ...
      to (contract): 0x11c12e9b79237f2bb2d66f4cf87791a40e87a9fd, args:
["0x82dd9ceed833f78d45dd54e2a3755e022b0bad70",
 "57896044618658097711785492504343953926634992332820282019728792003956564819968"]

==> CALL PublicMintERC20.approve    @ 454789 - 2023-11-25 13:13:00 UTC   (273 Bytes) ...
      to (contract): 0xb9b5c20291293b0a136fb279cc3ed4c106cfff38, args:
["0x82dd9ceed833f78d45dd54e2a3755e022b0bad70",
 "57896044618658097711785492504343953926634992332820282019728792003956564819968"]

==> CALL FacetSwapV1Router.swapExactTokensForTokens    @ 454791 - 2023-11-25 13:18:12 UTC   (411 Bytes) ...
      to (contract): 0x82dd9ceed833f78d45dd54e2a3755e022b0bad70, args:
{"amountIn"=>"10000000000000000",
 "amountOutMin"=>"464915635885227",
 "path"=>
  ["0x5f5e099e59720e515114ae82b855fbcfb9bd07a9",
   "0x5419b2dbdcd9e5e9c45cf3089d001d3fcb4d3cf9"],
 "to"=>"0x3D540826aBb85E64D76e22Dbff4081b5123E163b",
 "deadline"=>"1000000000000000000"}

==> CALL PublicMintERC20.approve    @ 454792 - 2023-11-25 13:20:48 UTC   (273 Bytes) ...
      to (contract): 0x382bd41f02c93121a05422fa35a514896459ee57, args:
["0x82dd9ceed833f78d45dd54e2a3755e022b0bad70",
 "57896044618658097711785492504343953926634992332820282019728792003956564819968"]

==> CALL EtherBridge.bridgeIn    @ 454793 - 2023-11-25 13:22:24 UTC   (228 Bytes) ...
      to (contract): 0x5f5e099e59720e515114ae82b855fbcfb9bd07a9, args:
{"to"=>"0x5fa6f9a1cb05837f4a22184b8d02c275afdb64f3",
 "amount"=>"20000000000000000"}

==> CALL EtherBridge.approve    @ 454794 - 2023-11-25 13:24:24 UTC   (273 Bytes) ...
      to (contract): 0x5f5e099e59720e515114ae82b855fbcfb9bd07a9, args:
["0x82dd9ceed833f78d45dd54e2a3755e022b0bad70",
 "57896044618658097711785492504343953926634992332820282019728792003956564819968"]

==> CALL EtherBridge.bridgeIn    @ 454800 - 2023-11-25 13:34:48 UTC   (229 Bytes) ...
      to (contract): 0x5f5e099e59720e515114ae82b855fbcfb9bd07a9, args:
{"to"=>"0x1b95d89ca2e23d52fe87d151de8e1513bb2c806a",
 "amount"=>"100000000000000000"}

==> CALL EtherBridge.bridgeOut    @ 454806 - 2023-11-25 13:35:24 UTC   (179 Bytes) ...
      to (contract): 0x5f5e099e59720e515114ae82b855fbcfb9bd07a9, args:
{"amount"=>"50000000000000000"}

==> CALL EtherBridge.approve    @ 454823 - 2023-11-25 13:36:12 UTC   (273 Bytes) ...
      to (contract): 0x5f5e099e59720e515114ae82b855fbcfb9bd07a9, args:
["0x82dd9ceed833f78d45dd54e2a3755e022b0bad70",
 "57896044618658097711785492504343953926634992332820282019728792003956564819968"]

==> CALL FacetSwapV1Router.swapExactTokensForTokens    @ 454824 - 2023-11-25 13:37:12 UTC   (419 Bytes) ...
      to (contract): 0x82dd9ceed833f78d45dd54e2a3755e022b0bad70, args:
{"amountIn"=>"10000000000000000",
 "amountOutMin"=>"16262286099184090592353",
 "path"=>
  ["0x5f5e099e59720e515114ae82b855fbcfb9bd07a9",
   "0xb324c3fccd5da0bad69d2709752044c6bd9adf1f"],
 "to"=>"0x1b95D89CA2e23D52FE87d151dE8E1513BB2c806A",
 "deadline"=>"1000000000000000000"}

...
```

or see the written out sample [facet.log](facet.log).



That's it for now.




## Questions? Comments?

Join us in the [Rubidity (community) discord (chat server)](https://discord.gg/3JRnDUap6y). Yes you can.
Your questions and commentary welcome.

Or post them over at the [Help & Support](https://github.com/geraldb/help) page. Thanks.

