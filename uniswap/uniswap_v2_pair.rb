#########
# follow the rspec UniswapV2Pair test
#   in https://github.com/0xFacet/facet-vm/blob/main/spec/models/uniswap_v2_pair_spec.rb 


$LOAD_PATH.unshift( '../solidity-typed/lib' )
$LOAD_PATH.unshift( '../rubidity/lib' )
$LOAD_PATH.unshift( '../rubidity-classic/lib' )

require 'rubidity/classic'


####################
# load (parse) and generate contract classes

Contract.load( 'UniswapV2Factory' )


pp PublicMintERC20


alice   = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
bob     = '0x'+'b'*40 # e.g. '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
charlie = '0x'+'c'*40 # e.g. '0xcccccccccccccccccccccccccccccccccccccccc'

pp alice
pp bob
pp charlie



#  executes the Uniswap V2 process
#    Deploy the ERC20 tokens

token0 = PublicMintERC20.construct(
            name: "Token0",
            symbol: "TK0",
            maxSupply: 21e24.to_i,
            perMintLimit: 21e24.to_i,
            decimals: 18
         )
pp token0
pp token0.__address__

token1 = PublicMintERC20.construct(
            name: "Token1",
            symbol: "TK1",
            maxSupply: 21e24.to_i,
            perMintLimit: 21e24.to_i,
            decimals: 18 
         )
pp token1
pp token1.__address__


# Deploy the UniswapV2Factory contract 
factory = UniswapV2Factory.construct( _feeToSetter: alice )
pp factory
pp factory.__address__

Runtime.msg.sender = alice
factory.setFeeTo( _feeTo: alice )


# Create a pair using the UniswapV2Factory contract
pair_address = factory.createPair(
                   tokenA: token0.__address__, 
                   tokenB: token1.__address__ )
pp pair_address                  


# The user decides how much liquidity they would provide
    
# Approve the Pair contract to spend the user's tokens
Runtime.msg.sender = alice
token0.mint( amount: 1000e18.to_i )
token1.mint( amount: 1000e18.to_i )

token0.approve( spender: pair_address,
                amount: 1000e18.to_i )
token1.approve( spender: pair_address,
                amount: 1000e18.to_i )

token0.transfer( to: pair_address,
                 amount: 300e18.to_i )   
token1.transfer( to: pair_address,
                 amount: 600e18.to_i )   


## get pair contract via address                 
pair = UniswapV2Pair.at( pair_address )
pp pair



# Add liquidity to the pair
Runtime.block.timestamp = 1699036435
pair.mint( to: alice )
pp pair
pp pair.serialize


###
#  check - what this is doing?
Runtime.msg.sender = alice
pair.transfer( to: pair_address,
               amount: 100e18.to_i )


# same address that minted the liquidity
# withdrawn assets are sent to this address   
pair.burn( to: alice )
pp pair
pp pair.serialize




__END__
    
    approve_receipt = trigger_contract_interaction_and_expect_success(
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      payload: {
        to: tokenA_deploy_receipt.address,
        data: {
          function: "approve",
          args: {
            spender: pair_address,
            amount: 500e18.to_i
          }
        }
      }
    )
    
    inputAmount = 200e18.to_i
    
    trigger_contract_interaction_and_expect_success(
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      payload: {
        to: deploy_receipts["tokenB"].address,
        data: {
          function: "transfer",
          args: {
            to: pair_address,
            amount: inputAmount
          }
        }
      }
    )
    
    extraAmount = 10
    
    UniswapV2CalleeTester = trigger_contract_interaction_and_expect_success(
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      payload: {
        to: nil,
        data: {
          type: "UniswapV2CalleeTester",
          args: [pair_address, extraAmount]
        }
      }
    ).address
    
    reserves = ContractTransaction.make_static_call(
      contract: pair_address,
      function_name: "getReserves"
    )
    
    reserveA, reserveB = reserves.values_at("_reserve0", "_reserve1")
    
    numerator = inputAmount * 997 * reserveA;
    denominator = (reserveB * 1000) + (inputAmount * 997);
    expectedOut = numerator.div(denominator)
    
    expectedOut += extraAmount
    
    swap_receipt = trigger_contract_interaction_and_expect_success(
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      payload: {
        to: pair_address,
        data: {
          function: "swap",
          args: {
            amount0Out: expectedOut,
            amount1Out: 0,
            to: UniswapV2CalleeTester,
            data: "0x01"
          }
        }
      }
    )
    
    trigger_contract_interaction_and_expect_success(
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      payload: {
        to: deploy_receipts["tokenA"].address,
        data: {
          function: "transfer",
          args: {
            to: pair_address,
            amount: 50e18.to_i
          }
        }
      }
    )

    # Execute skim
    skim_receipt = trigger_contract_interaction_and_expect_success(
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      payload: {
        to: pair_address,
        data: {
          function: "skim",
          args: { to: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97" } # Address where extra tokens should go
        }
      }
    )

    expect(skim_receipt.logs).to include(hash_including('event' => 'Transfer'))
    
    sync_receipt = trigger_contract_interaction_and_expect_success(
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      payload: {
        to: pair_address,
        data: {
          function: "sync",
          args: {}
        }
      }
    )
  end
end
