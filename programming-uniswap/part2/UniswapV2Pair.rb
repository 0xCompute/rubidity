# import "solmate/tokens/ERC20.sol";
# import "./libraries/Math.sol";
# import "./libraries/UQ112x112.sol";
#
# interface IERC20 {
#    function balanceOf(address) external returns (uint256);
#
#    function transfer(address to, uint256 amount) external;
# }
#
# error BalanceOverflow();
# error InsufficientLiquidityMinted();
# error InsufficientLiquidityBurned();
# error InsufficientOutputAmount();
# error InsufficientLiquidity();
# error InvalidK();
# error TransferFailed();


##
#  add "custom" math module / library
class Contract
module Math
   def self.min( a, b )  [a,b].min; end
   def self.sqrt( y )  Integer.sqrt( y ); end
end
end # class Contract



class UniswapV2Pair < ERC20 

    event :Burn, sender: Address, amount0: UInt, amount1: UInt
    event :Mint, sender: Address, amount0: UInt, amount1: UInt
    event :Sync, reserve0: UInt, reserve1: UInt
    event :Swap, sender: Address,
                 amount0Out: UInt,
                 amount1Out: UInt,
                 to:         Address  

    MINIMUM_LIQUIDITY = 1000

    storage token0:    Address,
            token1:    Address,
            _reserve0: UInt,    # was uint112 
            _reserve1: UInt,    # was uint112
            _blockTimestampLast: Timestamp,  # was uint32
            price0CumulativeLast: UInt, 
            price1CumulativeLast: UInt

    sig [Address, Address]        
    def constructor( token0:, token1: )
        super( "ZuniswapV2 Pair", "ZUNIV2", 18 )
    
        @token0 = token0
        @token1 = token1
    end

    sig []  
    def mint
        reserve0, reserve1 = getReserves
        balance0 = ERC20(@token0).balanceOf( address(this) )
        balance1 = ERC20(@token1).balanceOf( address(this) )
        amount0 = balance0 - reserve0
        amount1 = balance1 - reserve1

        liquidity = 0

        if @totalSupply == 0
            liquidity = Math.sqrt(amount0 * amount1) - MINIMUM_LIQUIDITY
            _mint( address(0), MINIMUM_LIQUIDITY )
        else 
            liquidity = Math.min(
                (amount0 * @totalSupply) / reserve0,
                (amount1 * @totalSupply) / reserve1
            )
        end

        assert liquidity > 0, "Insufficient Liquidity Minted"

        _mint( msg.sender, liquidity )

        _update( balance0, balance1, reserve0, reserve1 )

        log Mint, sender: msg.sender, amount0: amount0, amount1: amount1
    end

    sig []
    def burn
        balance0 = ERC20(@token0).balanceOf(address(this))
        balance1 = ERC20(@token1).balanceOf(address(this))
        liquidity = @balanceOf[msg.sender]

        amount0 = (liquidity * balance0) / @totalSupply
        amount1 = (liquidity * balance1) / @totalSupply

        assert amount0 > 0 && amount1 > 0, "Insufficient Liquidity Burned"

        _burn( msg.sender, liquidity )

        _safeTransfer( @token0, msg.sender, amount0 )
        _safeTransfer( @token1, msg.sender, amount1 )

        balance0 = ERC20(@token0).balanceOf(address(this))
        balance1 = ERC20(@token1).balanceOf(address(this))

        reserve0, reserve1 = getReserves
        _update( balance0, balance1, reserve0, reserve1 )

        log Burn, sender: msg.sender, amount0: amount0, amount1: amount1
    end

    sig [UInt, UInt, Address]
    def swap( amount0Out:, amount1Out:, to: )
        assert amount0Out >= 0 || amount1Out >= 0, "Insufficient Output Amount"

        reserve0, reserve1 = getReserves

        assert amount0Out <= reserve0  && amount1Out <= reserve1, "Insufficient Liquidity"

        balance0 = ERC20(@token0).balanceOf(address(this)) - amount0Out
        balance1 = ERC20(@token1).balanceOf(address(this)) - amount1Out

        assert balance0 * balance1 >= reserve0 * reserve1, "Invalid K"

        puts "==> swap"
        puts "   amount0Out:     #{amount0Out}"
        puts "   amount1Out:     #{amount1Out}"
        puts "   (new) balance0: #{balance0}"
        puts "   (new) balance1: #{balance1}"
        puts "   reserve0:       #{reserve0}"
        puts "   reserve1:       #{reserve1}"
   
        _update( balance0, balance1, reserve0, reserve1 )

        _safeTransfer( @token0, to, amount0Out )   if amount0Out > 0
        _safeTransfer( @token1, to, amount1Out )   if amount1Out > 0

        log Swap, sender: msg.sender, amount0Out: amount0Out, amount1Out: amount1Out, to: to
    end

    sig []
    def sync
        reserve0, reserve1 = getReserves
        _update(
            ERC20(@token0).balanceOf(address(this)),
            ERC20(@token1).balanceOf(address(this)),
            reserve0,
            reserve1
        )
    end

    sig [], :view, returns: [UInt, UInt, Timestamp]
    def getReserves
        [@_reserve0, @_reserve1, @_blockTimestampLast]
    end


    ##
    ##  PRIVATE
    ##
 
    sig [UInt, UInt, UInt, UInt]
    def _update(
        balance0:,
        balance1:,
        reserve0:,
        reserve1: )
        ## use UINT112_MAX = (2 ** 112 - 1)  - why? why not? 
        assert balance0 <= (2 ** 112 - 1) && balance1 <= (2 ** 112 - 1), "Balance Overflow"

        timeElapsed = block.timestamp - @_blockTimestampLast

        ## use Q112  = 2**112  - why? why not?
        if timeElapsed > 0 && reserve0 > 0 && reserve1 > 0
                @price0CumulativeLast +=
                    (reserve1 *2**112 / reserve0) * timeElapsed
                @price1CumulativeLast +=
                    (reserve0 *2**112 / reserve1) * timeElapsed
        end

        @_reserve0           = balance0
        @_reserve1           = balance1
        @_blockTimestampLast = block.timestamp

        log Sync, reserve0: @_reserve0, reserve1: @_reserve1
    end

    sig [Address, Address, UInt]
    def _safeTransfer( token:, to:, value: )
 
        ## fix-fix-fix - autoset msg.sender via call(stack) or such
        ##   use 
        ##    ERC20( token ).call { transfer( to: to, amount: value  ) }
        ##   to update context (msg.sender) - why? why not?
        ##   always call "external" contracts 
        ##      via interface proxy or such - why? why not?
        success =   callstack { ERC20( token ).transfer( to: to, amount: value  ) } 
        assert success, "Transfer Failed"
    end
end
