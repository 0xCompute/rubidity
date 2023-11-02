# Rubidity O.G. Notes

## What's different?

(1) no upgradable contract used / removed

(2) import - file extenstion .rubidity removed

``` ruby
import './UniswapV2Factory.rubidity'
import './UnsafeNoApprovalERC20.rubidity'
import './UniswapV2Router.rubidity'
import './PublicMintERC20.rubidity'
```

after

``` ruby
import 'UniswapV2Factory'
import 'UnsafeNoApprovalERC20'
import 'UniswapV2Router'
import 'PublicMintERC20'
```


(3)  do-end required ({} not possible; sorry)

``` ruby
 constructor() {
    s.name = 'UniswapSetupZapV2'
  }
```

after

``` ruby
 constructor() do
    s.name = 'UniswapSetupZapV2'
  end
```


(4) calling super constructor via super

``` ruby
  constructor() {
    ERC20.constructor(
      name: "ScribeSwap V2",
      symbol: "SCR",
      decimals: 18
    )
  }
```

after

``` ruby
  constructor() do
    super(
      name: "ScribeSwap V2",
      symbol: "SCR",
      decimals: 18
    )
  end
```
