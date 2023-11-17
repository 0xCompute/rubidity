# Proof Of Time  - "Gas-Less" Decentralized "Turing-Complete" Computing with "Normalized" Timeouts  

by [Gerald Bauer](https://github.com/geraldb),  November 2023


DRAFT - DRAFT - DRAFT  (Version 0.1)


Let's try to square the circle and solve the halting problem of "turing-complete" computing
with "normalized" timeouts.


The idea:

Every transaction gets time measured / profiled and if a max time is hit the transaction is halted / stopped and marked as invalid / reverted / aborted.


The problem:

(Compute) Time is relative!


Let's make (transaction processing) time absolute with mathematics / statistics (within a +/- window). 

The idea - the rubidity / rubysol / et al runtime gets hard-core benchmarked
using industry-strength benchmarks (example [rubybench](https://rubybench.org/) and other).

The benchmarks of rubidity / rubysol / et al runtimes 
get collected and published in public.


Using the benchmark the rubidity / rubysol node can calculate
a "standard" (adjust) time factor.

When running the time meassured / profiled for the max time
gets adjusted by the time factor.

Consensus on time outs.

If a time out candidate happens the transaction with time out data
gets published to the network for verification to a "time out transaction pool". 

Plus the runtime MUST publish a mean time 
by rerunning the transaction 100x (or 1000x) to avoid one time outliers.

In the beginning the "lead" indexer / node MUST publish the 
rubidity / rubysol et al runtime benchmarks and
the transaction "standard" measured time / profiles.  

In the beginng the "lead" indexer / node will be the "source of truth" 
for edge / conflicting time outs.  

Over time with collecting more public time out and benchmark data
the algorithm and machinery can get refined with real-world experience in production 
to square the circle and decentralize.


Note: To make it work in a decentralized way the "standard" time out
will have a tolerance "window" +/- delta. 





## Meta

The proof-of-time decentralized "halting problem" algo is dedidicated to the public domain.



## Questions? Comments?

Join us in the [Rubidity & Rubysol (community) discord (chat server)](https://discord.gg/3JRnDUap6y). Yes you can.
Your questions and commentary welcome.

Or post them over at the [Help & Support](https://github.com/geraldb/help) page. Thanks.

