# SPDX-License-Identifier: public domain


class UniswapV2SwapExamples < Contract

  UNISWAP_V2_ROUTER = '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D'

  WETH = '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2'
  DAI  = '0x6B175474E89094C44Da98b954EedeAC495271d0F'
  USDC = '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48'

  # IUniswapV2Router private router = IUniswapV2Router(UNISWAP_V2_ROUTER);
  # IERC20 private weth = IERC20(WETH);
  # IERC20 private dai = IERC20(DAI);

  storage router: Address, 
          weth:   Address, 
          dai:    Address


    sig :constructor, []
    def constructor
        @router = UNISWAP_V2_ROUTER
        @weth   = WETH 
        @dai    = DAI
    end

    # Swap WETH to DAI
    sig :swapSingleHopExactAmountIn, [UInt, UInt], returns: [UInt]
    def swapSingleHopExactAmountIn(
        amountIn:,
        amountOutMin: )
     
        IERC20(@weth).transferFrom( msg.sender, address(this), amountIn )
        IERC20(@weth).approve( address(router), amountIn )

        path = array( Address, 2 ).new   # new address[](2)
        path[0] = WETH
        path[1] = DAI

        amounts = IUniswapV2Router(router).swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            msg.sender,
            block.timestamp
        )

        #  amounts[0] = WETH amount, amounts[1] = DAI amount
        amounts[1]
    end


    #  Swap DAI -> WETH -> USDC
    sig :swapMultiHopExactAmountIn, [UInt, UInt], returns: [UInt]   
    def swapMultiHopExactAmountIn(
        amountIn:
        amountOutMin: )
  
        IERC20(@dai).transferFrom(msg.sender, address(this), amountIn)
        IERC20(@dai).approve(address(router), amountIn)

        path = array( Address, 3 ).new   # new address[](3)
        path[0] = DAI
        path[1] = WETH
        path[2] = USDC

        amounts = IUniswapV2Router(router).swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            msg.sender,
            block.timestamp
        )

        # amounts[0] = DAI amount
        # amounts[1] = WETH amount
        # amounts[2] = USDC amount
        amounts[2]
    end


    #  Swap WETH to DAI
    sig :swapSingleHopExactAmountOut, [UInt, UInt], returns: [UInt] 
    def swapSingleHopExactAmountOut(
        amountOutDesired:
        amountInMax: ) 
    
        IERC20(@weth).transferFrom(msg.sender, address(this), amountInMax)
        IERC20(@weth).approve(address(router), amountInMax)

        path = array( Address, 2 ).new   # new address[](2)
        path[0] = WETH
        path[1] = DAI

        amounts = IUniswapV2Router(router).swapTokensForExactTokens(
            amountOutDesired,
            amountInMax,
            path,
            msg.sender,
            block.timestamp
        )

        ## Refund WETH to msg.sender
        if amounts[0] < amountInMax 
            IERC20(@weth).transfer(msg.sender, amountInMax - amounts[0])
        end

        amounts[1]
    end


    #  Swap DAI -> WETH -> USDC
    sig :swapMultiHopExactAmountOut, [UInt, UInt], returns: UInt
    def swapMultiHopExactAmountOut(
        amountOutDesired:,
        amountInMax: )
 
        IERC20(@dai).transferFrom(msg.sender, address(this), amountInMax)
        IERC20(@dai).approve(address(router), amountInMax)

        path = array( Address, 3 ).new  # new address[](3)
        path[0] = DAI
        path[1] = WETH
        path[2] = USDC

        amounts = IUniswapV2Router( router ).swapTokensForExactTokens(
            amountOutDesired,
            amountInMax,
            path,
            msg.sender,
            block.timestamp
        )

        # Refund DAI to msg.sender
        if amounts[0] < amountInMax
            IERC20(@dai).transfer(msg.sender, amountInMax - amounts[0])
        end

        return amounts[2]
    end
end




__END__

interface IUniswapV2Router {
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
}

interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

interface IWETH is IERC20 {
    function deposit() external payable;

    function withdraw(uint amount) external;
}
