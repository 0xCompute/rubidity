# Rubidity  -  Ruby for Layer 1 (L1) Contracts with "Off-Chain" Indexer


The idea -  only store ("serialized") method calls "on-chain" - 
the "state" and "transaction receipts" and so on are handled "off-chain" with indexers.

Why?  Way cheaper (> 4x!) only call data (no storage fees) 
and simpler than "classic" ethereum solidity contract, for example.



