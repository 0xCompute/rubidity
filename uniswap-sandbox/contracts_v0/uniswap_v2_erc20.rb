class UniswapV2ERC20 < ERC20
  
  sig :constructor, []
  def constructor
    ERC20(
      name: "ScribeSwap V2",
      symbol: "SCR",
      decimals: 18
    )
  end
end
