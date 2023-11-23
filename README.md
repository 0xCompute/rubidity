
**DISCLAIMER:   the rubidity gem version is different 
from the rubidity built into the facet vm / app and i (Gerald Bauer) 
am NOT affiliated with facet computing inc. (middlemarch et al) or paid to work on the rubidity gem.**



# Rubidity & Rubysol  -  Rubies for Layer 1 (L1) Contracts / Protocols with "Off-Chain" Indexer


This is a rubidity & rubysol sandbox by [Gerald Bauer](https://github.com/geraldb)

The idea here is to experiment with rubidity "off-chain"
and if time permits break the "majestic rails rubidity monolith"
also known as "facet vm" (formerly "ethscriptions vm") up into easier to (re)use modules.

For example, why not bundle up a "core" language "rubidity" gem with 
no dependencies on any blockchain and break out "core / standard" 
contracts samples and database (SQL) and runtime modules or such.


Updates  

- What's in a name?  See [What's Rubidity!? What's Rubysol!? »](NAMES.md)

- For an alternate approach that look's at the "majestic rails rubidity monolith" code as-is (that is, not suggesting new or alternate syntax or semantics)
and simply tries to break out and start to (re)package / modular-ize code in "place holder" gems (waiting for adoption by the founders) such as 0xfacet and 0xfacet-typed and 0xfacet-rubidity see [Rubidity O.G. (Dumb Contracts) Public Code Review / (More) Tests / Gems & More »](https://github.com/s6ruby/rubidity.review)



Aside - Rubidity vs Rubysol - What's the difference (in a nutshell)? 

- [Rubidity tries to be as close as possible in syntax to solidity](https://www.rubydoc.info/gems/rubidity) and 
- [Rubysol tries to be as close as possible in syntax to ruby](https://www.rubydoc.info/gems/rubysol)




The first published modules / gems include:

- ~~**rubidity-typed**~~ - "zero-dependency" 100%-solidity compatible data type machinery incl. (frozen) string, address, uint, int, enum, struct, array, mapping, and more for rubidity - ruby for layer 1 (l1) contracts / protocols with "off-chain" indexer

- [**solidity-typed**](solidity-typed) (formerly known as rubidity-typed) -  "zero-dependency" 100%-solidity compatible data type and application binary interface (abi) machinery incl. bool, (frozen) string, address, bytes, uint, int, enum, struct, array, mapping, event, and more for solidity-inspired contract (blockchain) programming languages incl. rubidity, rubysol et al


- ~~**rubidity ("next")**~~ - ruby for layer 1 (l1) contracts / protocols with "off-chain" indexer 

- [**rubysol**](rubysol) - (formerly known as rubidity ("next")) ruby for layer 1 (l1) contracts / protocols with "off-chain" indexer 



- [**rubysol-contracts**](rubysol-contracts) - standard contracts (incl. erc20, erc721, etc) for ruby for layer 1 (l1) with "off-chain" indexer

- [**uniswap**](uniswap) - core uniswap v2 (dumb) contracts for ruby (rubysol) for layer 1 (l1) with "off-chain" indexer

- [**programming-uniswap**](programming-uniswap) - programming (decentralized finance - defi) uniswap v2 contracts article series, the ruby / rubysol edition
  - [Programming DeFi in Ruby: Uniswap V2. Part 1](programming-uniswap/part1)
  - [Programming DeFi in Ruby: Uniswap V2. Part 2](programming-uniswap/part2)
  - [Programming DeFi in Ruby: Uniswap V2. Part 3](programming-uniswap/part3)


- [**punks**](punks) -  10 000 punks - the facet (dumb) contract edition v1 / v2 (in ruby / rubysol / rubidity)



- ~~**rubidity-classic**~~ - rubidity classic / o.g. contract builder; trying the impossible and square the circle, that is, a rubidity "classic / o.g." dsl builder generating rubidity "more ruby-ish" contract classes. 


- [**rubidity**](rubidity) - (formerly known as rubidity classic) rubidity "classic / o.g." contract builder; trying the impossible and square the circle, that is, a rubidity "classic / o.g." dsl builder generating rubysol "more ruby-ish" contract classes. 


- [**datauris**](datauris) - helpers to parse (decode) and build (encode) data uris incl. base64-encoded images and more

- [**calldata**](calldata) - Calldata.encode / Calldata.decode using utf8_to_hex and hex_to_utf8 helpers and more for inscriptions / inscribes for ethereum & co

- [**ethscribe**](ethscribe) -  inscription (ethscription calldata) api wrapper & helpers for ethereum & co.

- [**scribelite**](scribelite)  - inscription / inscribe (ethscription calldata) database for ethereum & co; let's you query via sql and more





More:

- ~~**rubidity-simulacrum**~~ - run (dumb) blockchain contracts in rubidity (with 100%-solidity compatible data types & abis) on an ethereum simulacrum in your own home for fun & profit (for free)

- ~~**redpaper**~~ - Yes, you can. it's just ruby. Run the sample contracts from the [Red Paper](https://github.com/s6ruby/redpaper)
with rubidity and simulacrum!


- [**soliscript**](https://github.com/soliscript/soliscript) (formerly known as rubidity-simulacrum) - run blockchain contracts in rubysol (with 100%-solidity compatible data types & abis) on an ethereum simulacrum in your own home for fun & profit (for free)

- [**soliscript.starter**](https://github.com/soliscript/soliscript.starter) (formerly known as red paper contracts) -  run (blockchain) contracts in rubysol (with 100%-solidity compatible data types & abis) on an ethereum simulacrum in your own home for fun & profit (for free) incl. the red paper contracts e.g. satoshi dice (gambling), crowd funder, ballot (liquid delegate democracy)



- [**rubysol-by-example**](rubysol-by-example) - Rubysol By Example - an introduction to Rubysol with simple examples (inspired and mostly following Solidity By Example)

- [**learninminutes**](learninminutes) - Learn X in Y Minutes (Where X=Rubysol, Y=?)




For some ongoing (or historic) 
rubidity discussions & comments from 
the discord (chat server), see the [Changelog  - Good Morning](CHANGELOG.md).



## White Papers  

### Proof Of Time  - "Gas-Less" Decentralized "Turing-Complete" Computing with "Normalized" Timeouts  

DRAFT - DRAFT - DRAFT  (Version 0.1)

Let's try to square the circle and solve the halting problem of "turing-complete" computing
with "normalized" timeouts.

The idea:

Every transaction gets time measured / profiled and if a max time is hit the transaction is halted / stopped and marked as invalid / reverted / aborted.

The problem:

(Compute) Time is relative!

Let's make (transaction processing) time absolute with mathematics / statistics (within a +/- window)...

[**Read More »**](PROOF-OF-TIME.md)




## Bonus - More Blockchain (Crypto) Tools, Libraries & Scripts In Ruby

See [**/blockchain**](https://github.com/rubycocos/blockchain) 
at the ruby code commons (rubycocos) org.





## Questions? Comments?

Join us in the [Rubidity & Rubysol (community) discord (chat server)](https://discord.gg/3JRnDUap6y). Yes you can.
Your questions and commentary welcome.

Or post them over at the [Help & Support](https://github.com/geraldb/help) page. Thanks.

