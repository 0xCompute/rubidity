##
#  to run use:
#     ruby test/test_UniswapV2Pair.rb


require_relative 'helper'



####################
# load (parse) and generate contract classes

source = Contract.load( 'UniswapV2Factory' )

pp source.contracts

puts "  #{source.contracts.size} contract(s):"
source.contracts.each do |contract|
    print "   #{contract.name}"
    print " is #{contract.is.inspect}"   unless contract.is.empty?
    print "\n"
end

# 8 contract(s):
#   UniswapV2Callee
#   ERC20
#   UniswapV2ERC20 is [:ERC20]
#   UnsafeNoApprovalERC20 is [:ERC20]
#   PublicMintERC20 is [:ERC20]
#   IUniswapV2Factory
#   UniswapV2Pair is [:UniswapV2ERC20]
#   UniswapV2Factory


pp ERC20
pp PublicMintERC20 
pp UniswapV2Pair 
pp UniswapV2Factory

pp ERC20.name
pp PublicMintERC20.name 
pp UniswapV2Pair.name 
pp UniswapV2Factory.name



class TestUniswapV2Pair < Minitest::Test

  ALICE  = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
  BOB    = '0x'+'b'*40 

  pp ALICE
  pp BOB


=begin
export async function pairFixture(provider: Web3Provider, [wallet]: Wallet[]): Promise<PairFixture> {
  const { factory } = await factoryFixture(provider, [wallet])

  const tokenA = await deployContract(wallet, ERC20, 
            [expandTo18Decimals(10000)], overrides)
  const tokenB = await deployContract(wallet, ERC20, 
            [expandTo18Decimals(10000)], overrides)

  await factory.createPair(tokenA.address, tokenB.address, overrides)
  const pairAddress = await factory.getPair(tokenA.address, tokenB.address)
  const pair = new Contract(pairAddress, JSON.stringify(UniswapV2Pair.abi), provider).connect(wallet)

  const token0Address = (await pair.token0()).address
  const token0 = tokenA.address === token0Address ? tokenA : tokenB
  const token1 = tokenA.address === token0Address ? tokenB : tokenA

  return { factory, token0, token1, pair }
}

let factory: Contract
let token0: Contract
let token1: Contract
let pair: Contract
beforeEach(async () => {
  const fixture = await loadFixture(pairFixture)
  factory = fixture.factory
  token0 = fixture.token0
  token1 = fixture.token1
  pair = fixture.pair
})
=end

  def _setup_contracts
     Runtime.block.timestamp = 0   ## start with timestamp 0 - why? why not?

    token0 = PublicMintERC20.construct(
      name: "Token A",
      symbol: "TKNA",
      maxSupply: 10000.e18,  
      perMintLimit: 10000.e18,
      decimals: 18 )
    pp token0


    token1 = PublicMintERC20.construct(
      name: "Token B",
      symbol: "TKNB",
      maxSupply: 10000.e18,
      perMintLimit: 10000.e18,
      decimals: 18 )
    pp token1

    Runtime.msg.sender = ALICE
    ## todo/check - what is the balance of alice in test setup upstream? (all by default?)
    token0.mint( 1000.e18 ) 
    token1.mint( 1000.e18 ) 



    factory = UniswapV2Factory.construct( _feeToSetter: ALICE ) 
    
    # Create a pair using the UniswapV2Factory contract
    pair_address = factory.createPair(
                          tokenA: address( token0 ), 
                          tokenB: address( token1 ))
    pp pair_address                  

    pair = UniswapV2Pair.at( pair_address )   ## get contract ref

    Runtime.msg.sender = ALICE

    [token0, token1, pair]
  end


=begin
it('mint', async () => {
  const token0Amount = expandTo18Decimals(1)
  const token1Amount = expandTo18Decimals(4)
  await token0.transfer(pair.address, token0Amount)
  await token1.transfer(pair.address, token1Amount)

  const expectedLiquidity = expandTo18Decimals(2)
  await expect(pair.mint(wallet.address, overrides))
    .to.emit(pair, 'Transfer')
    .withArgs(AddressZero, AddressZero, MINIMUM_LIQUIDITY)
    .to.emit(pair, 'Transfer')
    .withArgs(AddressZero, wallet.address, expectedLiquidity.sub(MINIMUM_LIQUIDITY))
    .to.emit(pair, 'Sync')
    .withArgs(token0Amount, token1Amount)
    .to.emit(pair, 'Mint')
    .withArgs(wallet.address, token0Amount, token1Amount)

  expect(await pair.totalSupply()).to.eq(expectedLiquidity)
  expect(await pair.balanceOf(wallet.address)).to.eq(expectedLiquidity.sub(MINIMUM_LIQUIDITY))
  expect(await token0.balanceOf(pair.address)).to.eq(token0Amount)
  expect(await token1.balanceOf(pair.address)).to.eq(token1Amount)
  const reserves = await pair.getReserves()
  expect(reserves[0]).to.eq(token0Amount)
  expect(reserves[1]).to.eq(token1Amount)
})
=end


  def test_mint
    token0, token1, pair =  _setup_contracts

    # const token0Amount = expandTo18Decimals(1)
    # const token1Amount = expandTo18Decimals(4)
    # await token0.transfer(pair.address, token0Amount)
    # await token1.transfer(pair.address, token1Amount)
   
    token0Amount = 1.e18
    token1Amount = 4.e18
    token0.transfer( address(pair), token0Amount)
    token1.transfer( address(pair), token1Amount)

    # const expectedLiquidity = expandTo18Decimals(2)
    # await expect(pair.mint(wallet.address, overrides))
    #  .to.emit(pair, 'Transfer')
    #  .withArgs(AddressZero, AddressZero, MINIMUM_LIQUIDITY)
    #  .to.emit(pair, 'Transfer')
    #  .withArgs(AddressZero, wallet.address, expectedLiquidity.sub(MINIMUM_LIQUIDITY))
    #  .to.emit(pair, 'Sync')
    #  .withArgs(token0Amount, token1Amount)
    #  .to.emit(pair, 'Mint')
    #  .withArgs(wallet.address, token0Amount, token1Amount)
  
    expectedLiquidity = 2.e18
    pair.mint( to: ALICE )
    #  .to.emit(pair, 'Transfer')
    #  .withArgs(AddressZero, AddressZero, MINIMUM_LIQUIDITY)
    #  .to.emit(pair, 'Transfer')
    #  .withArgs(AddressZero, wallet.address, expectedLiquidity.sub(MINIMUM_LIQUIDITY))
    #  .to.emit(pair, 'Sync')
    #  .withArgs(token0Amount, token1Amount)
    #  .to.emit(pair, 'Mint')
    #  .withArgs(wallet.address, token0Amount, token1Amount)
  
    # expect(await pair.totalSupply()).to.eq(expectedLiquidity)
    assert pair.totalSupply == expectedLiquidity
    # expect(await pair.balanceOf(wallet.address)).to.eq(expectedLiquidity.sub(MINIMUM_LIQUIDITY))
    assert pair.balanceOf( ALICE ) == expectedLiquidity - 1000
    # expect(await token0.balanceOf(pair.address)).to.eq(token0Amount)
    assert token0.balanceOf( address( pair )) == token0Amount
    # expect(await token1.balanceOf(pair.address)).to.eq(token1Amount)
    assert token1.balanceOf( address( pair )) == token1Amount
    reserves = pair.getReserves
    # expect(reserves[0]).to.eq(token0Amount)
    assert reserves[0] == token0Amount
    # expect(reserves[1]).to.eq(token1Amount)
    assert reserves[1] == token1Amount      
  end  # method test_mint  
end  # class TestUniswapV2Pair

