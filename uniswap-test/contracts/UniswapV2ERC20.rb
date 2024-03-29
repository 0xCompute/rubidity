pragma :rubidity, "1.0.0"

import 'ERC20'

contract :UniswapV2ERC20, is: :ERC20, abstract: true do
  constructor() do
    super(
      name: "ScribeSwap V2",
      symbol: "SCR",
      decimals: 18
    )
  end
end
