# Notes


## Fix

check if global  address() or uint256() conversion functions
conflict with  "storage" type helper in contract e.g.

``` ruby
uint256 :public, :totalSupply
address :public, :owner
# and so on
```




## Todos

- [ ]  add config option for search path for contracts; defaults to ./contracts
- [ ]  add support for returns with more than one output type!!!!!



## Ideas

maybe add an export to write-out the "converted" contract code as text - why? why not?