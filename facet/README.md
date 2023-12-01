# Facet 


## Contract (Create & Call) Indexer / Profiler / Logger / Formater / Printer


How to use?

### Step 1: Build or (Re)Use a database built with scribelite (e.g. scribe.db, facet.db, etc.)

New to scribelite?!  see [scribelite »](../scribelite) 


let's use ethscriptions from mainnet as an example:

``` ruby
require 'scribelite'


ScribeDb.open( './facet.db' )


ScribeDb.sync_facet_txns   ## will use newer_ethscriptions api via ethscriptions.com 


puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"
#=>   66245 scribe(s)
#=>   66245 tx(s)
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
limit = 200

Scribe.facet.order( :num ).limit( 200 ).each do |scribe|
  buf = facet.format( scribe ) 
  puts buf

  log << buf
end

write_text( "facet.log", log )
```

resulting in:

```
==> CREATE PublicMintERC20    @ 2316476 - 2023-11-22 15:14:23 UTC   (3.35 KB) ...
       txid: 0xd8596d5f2a8a967bb672030d8dd08cb9628cc68a33d38e61c4f8c2ebeb2805e3
       address: ???
{"name"=>"CAT",
 "symbol"=>"CAT",
 "maxSupply"=>"1000000000000000000000000000000",
 "perMintLimit"=>"100000000000000000000000000",
 "decimals"=>"18"}

==> CALL ???.swapExactTokensForTokens    @ 2634297 - 2023-11-29 13:53:47 UTC   (419 Bytes) ...
      to (contract): 0x82dd9ceed833f78d45dd54e2a3755e022b0bad70, args:
{"amountIn"=>"300000000000000000",
 "amountOutMin"=>"3622785418876239612766",
 "path"=>
  ["0x5f5e099e59720e515114ae82b855fbcfb9bd07a9",
   "0xb324c3fccd5da0bad69d2709752044c6bd9adf1f"],
 "to"=>"0x34333Ed158f50d7AE32873C83b908Af52c48a8a9",
 "deadline"=>"1000000000000000000"}

==> CREATE PublicMintERC20    @ 2661614 - 2023-11-30 11:11:59 UTC   (3.34 KB) ...
       txid: 0x0b574217fa7d6f4bbf3540875358ac7f7c363cd70283bd15a35c7d5c447ad100
       address: ???
{"name"=>"justnike",
 "symbol"=>"fwd",
 "maxSupply"=>"21000000000000000000000000000",
 "perMintLimit"=>"1000000000000000000000",
 "decimals"=>"18"}

==> CREATE PublicMintERC20    @ 2661733 - 2023-11-30 11:20:47 UTC   (3.34 KB) ...
       txid: 0x56fddbee920c3ee681b53c6120e6594f9a49b783c69aa39a206c6fef17c4545b
       address: ???
{"name"=>"justnike",
 "symbol"=>"fwd",
 "maxSupply"=>"21000000000000000000000000000",
 "perMintLimit"=>"1000000000000000000000",
 "decimals"=>"18"}

==> CREATE PublicMintERC20    @ 2662482 - 2023-11-30 14:04:47 UTC   (3.34 KB) ...
       txid: 0x4889124d8488f72e3bbacfa24813932709f033d10563b7517c2b7cf3953b0fb5
       address: ???
{"name"=>"ethx",
 "symbol"=>"ethx",
 "maxSupply"=>"21000000000000000000000000",
 "perMintLimit"=>"1000000000000000000000",
 "decimals"=>18}

==> CREATE PublicMintERC20    @ 2662483 - 2023-11-30 14:04:59 UTC   (3.34 KB) ...
       txid: 0x9a2ae7976d05a26bcae63696ff2151f6f361cb2480ba6527fbc29b32a07fc967
       address: ???
{"name"=>"18684900",
 "symbol"=>"18684900",
 "maxSupply"=>"18684900000000000000000000",
 "perMintLimit"=>"100000000000000000000",
 "decimals"=>"18"}

==> CREATE PublicMintERC20    @ 2662484 - 2023-11-30 14:04:59 UTC   (3.34 KB) ...
       txid: 0xca80594ee32374a9901c47af5144a1e2a7cd85a47102a61d665418eda5044c33
       address: ???
{"name"=>"FacE7",
 "symbol"=>"FacE7",
 "maxSupply"=>"21000000000000000000000000",
 "perMintLimit"=>"1000000000000000000000",
 "decimals"=>"18"}

==> CREATE PublicMintERC20    @ 2662485 - 2023-11-30 14:04:59 UTC   (3.35 KB) ...
       txid: 0x5bc9f04b4eacacf2268e752d199f0c6b5dc658dca9275e2f87b37c4502c31e0f
       address: ???
{"name"=>"thenewworld",
 "symbol"=>"tnw",
 "maxSupply"=>"21000000000000000000000000000000",
 "perMintLimit"=>"1000000000000000000000",
 "decimals"=>"18"}

==> CREATE PublicMintERC20    @ 2662486 - 2023-11-30 14:04:59 UTC   (3.34 KB) ...
       txid: 0x16b263a2515556d8db5b9da7d602a6cf9805843c86febd687c47b684cf294799
       address: ???
{"name"=>"ethx",
 "symbol"=>"ethx",
 "maxSupply"=>"21000000000000000000000000",
 "perMintLimit"=>"1000000000000000000000",
 "decimals"=>18}

==> CREATE PublicMintERC20    @ 2662487 - 2023-11-30 14:05:11 UTC   (3.35 KB) ...
       txid: 0x26a4a8fed2e60ad5919c332d01b2741ba35fc4fcd8468dcc68e2879a264eb6c6
       address: ???
{"name"=>"facetworld",
 "symbol"=>"fwd",
 "maxSupply"=>"21000000000000000000000000000",
 "perMintLimit"=>"1000000000000000000000",
 "decimals"=>"18"}

==> CREATE PublicMintERC20    @ 2662488 - 2023-11-30 14:05:11 UTC   (3.35 KB) ...
       txid: 0xdda5f87b8de16c9ec222865f6263cf7426f3a697dd07ba4077d27ac2aba04a11
       address: ???
{"name"=>"thenewworld",
 "symbol"=>"tnw",
 "maxSupply"=>"21000000000000000000000000000000",
 "perMintLimit"=>"1000000000000000000000",
 "decimals"=>"18"}

==> CREATE PublicMintERC20    @ 2662489 - 2023-11-30 14:05:11 UTC   (3.34 KB) ...
       txid: 0x93ea51222f41418dad2159517b4f82dd02e52c766a3a528f587acf1035b8d94d
       address: 0xd5d49b065b6c187b799073ffbb52f93a6dfdc758
{"name"=>"18684900",
 "symbol"=>"18684900",
 "maxSupply"=>"18684900000000000000000000",
 "perMintLimit"=>"100000000000000000000",
 "decimals"=>"18"}

==> CREATE PublicMintERC20    @ 2662490 - 2023-11-30 14:05:11 UTC   (3.34 KB) ...
       txid: 0x26bc4d798c64c73caa74a1100de986c2dea5b15a25a3b03fa650b7f31be7630a
       address: 0x2535c89c8329bd40736151ad09cc79c5e5646bbb
{"name"=>"FacE7",
 "symbol"=>"FacE7",
 "maxSupply"=>"21000000000000000000000000",
 "perMintLimit"=>"1000000000000000000000",
 "decimals"=>"18"}

==> CREATE PublicMintERC20    @ 2662491 - 2023-11-30 14:05:11 UTC   (3.34 KB) ...
       txid: 0x3a7a90e289280ca7d1d8df5c1326083e3088784a2fd0b6739d928c226a25db88
       address: 0x345448777295920dad4ded8ab4eaa452b4206d9f
{"name"=>"ethx",
 "symbol"=>"ethx",
 "maxSupply"=>"21000000000000000000000000",
 "perMintLimit"=>"1000000000000000000000",
 "decimals"=>18}

==> CREATE AirdropERC20    @ 2662492 - 2023-11-30 14:05:11 UTC   (4.42 KB) ...
       txid: 0x58875411afb6c4b69b85e3890557739ec88c26a8c1daf14c9d58489215b53d64
       address: 0x6146b2e1179204e7e5aca73f9b216484b530a0fe
{"name"=>"PAMP",
 "symbol"=>"PAMP",
 "owner"=>"0xaf4ec0E8905fa9d0187A5143152d8d2771dE0a66",
 "maxSupply"=>"1000000000000000000000000000",
 "perMintLimit"=>"200000000000000000000000000",
 "decimals"=>"18"}

==> CREATE AirdropERC20    @ 2662493 - 2023-11-30 14:05:11 UTC   (4.42 KB) ...
       txid: 0xeed227d94d3be6aa585d74c52e3ab47192a8c421d3d96cffaa131cdfb2711413
       address: 0xa38ad4c62a70e14619fa56548bb5e11381d58ff6
{"name"=>"PAMP",
 "symbol"=>"PAMP",
 "owner"=>"0xaf4ec0E8905fa9d0187A5143152d8d2771dE0a66",
 "maxSupply"=>"1000000000000000000000000000",
 "perMintLimit"=>"200000000000000000000000000",
 "decimals"=>"18"}

==> CREATE AirdropERC20    @ 2662494 - 2023-11-30 14:05:11 UTC   (4.42 KB) ...
       txid: 0x352d317f35364346a85116b2d1aac54287b6ace90c84c7b3746ba6037954fbc3
       address: 0x1a4fe4ae8dd9fb265a6d0680d47bfaa5268fbee9
{"name"=>"PAMP",
 "symbol"=>"PAMP",
 "owner"=>"0xaf4ec0E8905fa9d0187A5143152d8d2771dE0a66",
 "maxSupply"=>"1000000000000000000000000000",
 "perMintLimit"=>"200000000000000000000000000",
 "decimals"=>"18"}

==> CREATE AirdropERC20    @ 2662495 - 2023-11-30 14:05:11 UTC   (4.42 KB) ...
       txid: 0x5dc22f0034ae99e10ea35201cca0031472adb33030baff14268124f969365208
       address: 0xb8d284fa0dbfe85882498e433a4345bd9cc444e6
{"name"=>"PAMP",
 "symbol"=>"PAMP",
 "owner"=>"0xaf4ec0E8905fa9d0187A5143152d8d2771dE0a66",
 "maxSupply"=>"1000000000000000000000000000",
 "perMintLimit"=>"200000000000000000000000000",
 "decimals"=>"18"}

==> CREATE PublicMintERC20    @ 2662496 - 2023-11-30 14:05:23 UTC   (3.35 KB) ...
       txid: 0x5afce8c03a888785f9deeef0cc65a11c4c2f55d7db3991085b4d7782d4b63bbc
       address: ???
{"name"=>"thenewworld",
 "symbol"=>"tnw",
 "maxSupply"=>"21000000000000000000000000000000",
 "perMintLimit"=>"1000000000000000000000",
 "decimals"=>"18"}

==> CREATE PublicMintERC20    @ 2662498 - 2023-11-30 14:05:23 UTC   (3.34 KB) ...
       txid: 0xa1b348bca633c1d9aa604632f714ca2cce02ff8c428fff0bdcc0b377778c0b38
       address: 0xeb9c4863a1d57d87dcd385873e261083cc171d4f
{"name"=>"ethx",
 "symbol"=>"ethx",
 "maxSupply"=>"21000000000000000000000000",
 "perMintLimit"=>"1000000000000000000000",
 "decimals"=>18}

==> CREATE EtherBridge    @ 2662499 - 2023-11-30 14:05:23 UTC   (5.58 KB) ...
       txid: 0x0d589992fcaafc848de21613cd38235c6cbd0f671b8b1ccaa8b6bad946c83885
       address: 0x1673540243e793b0e77c038d4a88448eff524dce
{"name"=>"Facet Ether",
 "symbol"=>"FETH",
 "trustedSmartContract"=>"0xD729345aA12c5Af2121D96f87B673987f354496B"}

==> CREATE AirdropERC20    @ 2662500 - 2023-11-30 14:05:23 UTC   (4.42 KB) ...
       txid: 0x53289d4ae9398bd94a4071aea3fe2c887ffb44feda4029032f4f0498cfd229ef
       address: 0xd533625b23add7c44d526a3e5e5306235cb9c305
{"name"=>"PAMP",
 "symbol"=>"PAMP",
 "owner"=>"0xaf4ec0E8905fa9d0187A5143152d8d2771dE0a66",
 "maxSupply"=>"1000000000000000000000000000",
 "perMintLimit"=>"200000000000000000000000000",
 "decimals"=>"18"}

==> CREATE PublicMintERC20    @ 2662501 - 2023-11-30 14:05:23 UTC   (3.32 KB) ...
       txid: 0xd38e2afd7eb7ba63ae5d35112a08fd577b885fb5898e4393cb79ebcbb14dbe9b
       address: 0x55a082c7e9f72c3dfdadb7ffa98cf5464335d00f
{"name"=>"FacE7",
 "symbol"=>"FacE7",
 "maxSupply"=>"21000000000000",
 "perMintLimit"=>"1000000000",
 "decimals"=>"6"}

==> CREATE EthscriptionERC20Bridge    @ 2662502 - 2023-11-30 14:05:35 UTC   (6.01 KB) ...
       txid: 0xe770699a37c2651116affffd1baa7fd17148e2c7eb08d8e03103184043d74552
       address: 0x55ab0390a89fed8992e3affbf61d102490735e24
{"name"=>"Eths Token",
 "symbol"=>"ETHS",
 "mintAmount"=>"1000",
 "trustedSmartContract"=>"0x03f84C2b50442332802b7ca8DBbEfAd1633F2547"}

==> CREATE PublicMintERC20    @ 2662503 - 2023-11-30 14:05:35 UTC   (3.34 KB) ...
       txid: 0xae9faf7e1ad31e3007f27f38a48dae5e8efb8048a6c75ae11b11b3f8d975fc40
       address: 0xcbe9556f1dd0b6eb2bb050a7e477b548b8618610
{"name"=>"FLOOR",
 "symbol"=>"FLR",
 "maxSupply"=>"1000000000000000000000000",
 "perMintLimit"=>"500000000000000000000",
 "decimals"=>"18"}

==> CREATE AirdropERC20    @ 2662504 - 2023-11-30 14:05:35 UTC   (4.42 KB) ...
       txid: 0x9b95b2409c4db3700682ee8c5806e5e030f670b2f0ec6ed175699f425d5a711a
       address: 0x75c1cc882c1464eb097d2a8795ab0e6191ab8c86
{"name"=>"PAMP",
 "symbol"=>"PAMP",
 "owner"=>"0xaf4ec0E8905fa9d0187A5143152d8d2771dE0a66",
 "maxSupply"=>"1000000000000000000000000000",
 "perMintLimit"=>"200000000000000000000000000",
 "decimals"=>"18"}

==> CREATE NameRegistry    @ 2662505 - 2023-11-30 14:06:11 UTC   (26.2 KB) ...
       txid: 0xec5d415d7edfcfd78c9927ba2dc04eb1e8cd334af49a2deef674d43ed2264dab
       address: 0xde11257ac24e96b8e39df45dbd4d3cf32237d63d
{"name"=>"Facet Cards",
 "symbol"=>"CARD",
 "owner"=>"0x0C051103f51C0C5d81209fE6057468B3F6297969",
 "usdWeiCentsInOneEth"=>"200000000000000000000000",
 "charCountToUsdWeiCentsPrice"=>
  [31709791983764584,
   3170979198376458,
   1585489599188229,
   317097919837645,
   31709791983764],
 "cardTemplate"=>"a",
 "_WETH"=>"0x1673540243e793b0e77c038d4a88448eff524dce"}

...
```

or see the written out sample [facet.log](facet.log).



That's it for now.




## Questions? Comments?

Join us in the [Rubidity (community) discord (chat server)](https://discord.gg/3JRnDUap6y). Yes you can.
Your questions and commentary welcome.

Or post them over at the [Help & Support](https://github.com/geraldb/help) page. Thanks.

