# (Awesome)  Facet (VM & Dumb Contracts) Ecosystem  




## Official (Facet Computing Inc.)

by [Tom Lehman](https://github.com/RogerPodacter) &  [Michael Hirsch](https://github.com/mikeahirsch)


Open (Source) Infrastructure

- Facet VM  [(Source)](https://github.com/0xFacet/facet-vm)
- Facet Scan [(Source)](https://github.com/0xFacet/facetscan)


Products & Services

- Facet Cards  [(Web)](https://facet.cards)
  - [Facet Cards Intro & F.A.Q](FACETCARDS.md)
- Facet Swap  (with Rewards) [(Web)](https://facetswap.com)
  - [Facet Swap Intro](FACETSWAP.md)
  - [Facet Swap Reward Intro](FACETREWARDS.md)


## Analytics

### Facet Bridge ( "Stacked / Locked" Ether)

contract @ <https://etherscan.io/address/0xD729345aA12c5Af2121D96f87B673987f354496B>

Facet Bridge Dashboard - <https://dune.com/richass12/facet>






## More


[**Rubysol**](/rubysol)   by [Gerald Bauer](https://github.com/geraldb)  - rubysol (formerly known as rubidity "next") "gem-ified" and modular contract lang runtime incl. structs, enums, array of structs, etc.




## Upcoming / Announcements


### Scorpio Ethscriptions Relayer

Scorpio is the core product of Orion in the Ethscriptions ecosystem. It carries the transformative mission of redefining Ethscriptions transactions by directly and seamlessly connecting smart contracts and dumb contracts. <https://twitter.com/ScorpioEths/status/1723208297128554925>


<details>
<summary markdown="1">More</summary>

The purpose of Facet VM (formerly ESC VM) is to enhance 
the programmability and scalability of the Ethscriptions protocol by enabling it to act as a general-purpose computing engine.

Scorpio Ethscriptions Relayer passes messages between Ethereum smart contracts and dumb contracts. In this scheme, users sign messages (not transactions) containing information about a transaction they would like to execute.

On the contrary, Layer 2 takes a different approach. In Layer 2, states are managed within the context of the blockchain, which makes validation easier. However, the validation in Layer 2 is conditional.

The logic is that if it is known that X number of transactions are included in a certain block and their order is Y, then it can be inferred that the state of the blockchain should become Z.

While Facet Virtual Machine differs from Layer 2 (second-layer scaling) solutions, it plays a crucial role in the Ethereum ecosystem.

But the problem is that within the Layer 2 system, there is no way to verify whether X and Y are correct.

Relayers are then responsible for signing valid Ethereum transactions with this information and sending them to Dumb Contracts.

</details>


