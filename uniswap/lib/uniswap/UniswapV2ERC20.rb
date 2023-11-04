
class UniswapV2ERC20 < ERC20   # abstract: true 
  sig []
  def constructor
    super(
      name: "ScribeSwap V2",
      symbol: "SCR",
      decimals: 18
    )
  end
end   # class UniswapV2ERC20

