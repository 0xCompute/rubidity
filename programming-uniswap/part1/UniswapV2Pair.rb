# import "solmate/tokens/ERC20.sol";
# import "./libraries/Math.sol";
#
# interface IERC20 {
#    function balanceOf(address) external returns (uint256);
#
#    function transfer(address to, uint256 amount) external;
# }

# error InsufficientLiquidityMinted();
# error InsufficientLiquidityBurned();
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

    event :Burn, sender: Address, 
                 amount0: UInt, 
                 amount1: UInt 
    event :Mint, sender: Address, 
                 amount0: UInt, 
                 amount1: UInt
    event :Sync, reserve0: UInt, 
                 reserve1: UInt

    MINIMUM_LIQUIDITY = 1000

    storage token0:    Address,
            token1:    Address,
            _reserve0: UInt,     # was uint112
            _reserve1: UInt      # was uint112

    sig [Address, Address]
    def constructor( token0:, token1: )
        super( name:   "ZuniswapV2 Pair", 
               symbol: "ZUNIV2", 
               decimals: 18 )
    
        @token0 = token0
        @token1 = token1
    end

    sig []
    def mint
        reserve0, reserve1  = getReserves
        balance0 = ERC20(@token0).balanceOf( address(this) ) 
        balance1 = ERC20(@token1).balanceOf( address(this) )   
        amount0 = balance0 - reserve0
        amount1 = balance1 - reserve1

        puts "==> add liquidity"
        puts "   balance0: #{balance0}"
        puts "   balance1: #{balance1}"
        puts "   amount0: #{amount0}"
        puts "   amount1: #{amount1}"


        liquidity = 0

        if @totalSupply == 0
            liquidity = Math.sqrt( amount0 * amount1) - MINIMUM_LIQUIDITY
            _mint( address(0), MINIMUM_LIQUIDITY )
        else 
            liquidity = Math.min(
                         (amount0 * @totalSupply) / reserve0,
                         (amount1 * @totalSupply) / reserve1
                        )
        end

        puts "   liquidity: #{liquidity}"

        assert liquidity > 0, "Insufficient Liquidity Minted"

        _mint( msg.sender, liquidity )

        _update( balance0, balance1 )

        log Mint, sender: msg.sender, amount0: amount0, amount1: amount1
    end

    sig []
    def burn 
        balance0 = ERC20(@token0).balanceOf( address(this) ) 
        balance1 = ERC20(@token1).balanceOf( address(this) ) 
        liquidity = @balanceOf[msg.sender]

        amount0 = (liquidity * balance0) / @totalSupply
        amount1 = (liquidity * balance1) / @totalSupply

        puts "==> remove liquidity"
        puts "   balance0: #{balance0}"
        puts "   balance1: #{balance1}"
        puts "   amount0: #{amount0}"
        puts "   amount1: #{amount1}"
        puts "   liquidity: #{liquidity}"

        assert amount0 > 0 && amount1 > 0, "Insufficient Liquidity Burned"

        _burn( msg.sender, liquidity )
        
        _safeTransfer( @token0, msg.sender, amount0 )
        _safeTransfer( @token1, msg.sender, amount1 )

        balance0 = ERC20(@token0).balanceOf( address(this) ) 
        balance1 = ERC20(@token1).balanceOf( address(this) ) 

        _update( balance0, balance1 )

        log Burn, sender: msg.sender, amount0: amount0, amount1: amount1
    end

    sig []
    def sync
        _update(
            ERC20(@token0).balanceOf( address(this) ), 
            ERC20(@token1).balanceOf( address(this) )  
        )
    end

    sig [], :view, returns: [UInt, UInt, Timestamp]
    def getReserves
        [@_reserve0, @_reserve1, 0]
    end

    ##
    ##  PRIVATE
    ##
    sig [UInt, UInt]
    def _update( balance0:, balance1: )
        @_reserve0 = balance0
        @_reserve1 = balance1

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
end    # class UniswapV2Pair


