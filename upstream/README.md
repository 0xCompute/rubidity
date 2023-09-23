# Upstream

Upsream?!  The idea is to track the upstream code 
in the <https://github.com/ethscriptions-protocol/ethscriptions-vm-server> repo.

- [/contracts](contracts)   - has a copy of [app/models/contracts](https://github.com/ethscriptions-protocol/ethscriptions-vm-server/tree/main/app/models) 
- [/lang](lang)        - has a copy of [app/models](https://github.com/ethscriptions-protocol/ethscriptions-vm-server/tree/main/app/models) 
- [/test](test)        - has a copy of [spec/models](https://github.com/ethscriptions-protocol/ethscriptions-vm-server/tree/main/spec/models)



## What's News? Upstream Change Log

- no more AddressOrDumpContract type; always Address
- DumpContract type removed its now an Address 
  (note: internally there a new ContractType)



## Design Notes / Quotes

Writing Dumb Contracts

Dumb Contracts are specified using Solidity code because programming languages communicate protocol logic more efficiently than English prose and Solidity is the most widely used and understood language in blockchain development.

However everyone implementing the Dumb Contracts protocol can use whatever language they want as long as their implementation matches the behavior of the Solidity specification.




## More Notes About Rubidity & Ethscriptions VM (Server)


ESIP-4: The Ethscriptions Virtual Machine - Dumb Contracts: "So dumb, they're smart" - <https://docs.ethscriptions.com/esips/esip-4-the-ethscriptions-virtual-machine>


Ethscriptions Virtual Machine Docs  - <https://docs.ethscriptions.com/v/ethscriptions-vm/getting-started/welcome-to-ethscriptions-vm>




History


