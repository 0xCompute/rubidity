##
#  to run use:
#     ruby test/test_UniswapV2Pair.rb


require_relative 'helper'


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


    pair = UniswapV2Pair.construct( token0: address(token0),
                                    token1: address(token1) ) 


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
    pair.mint
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
    assert token0.balanceOf( pair.address) == token0Amount
    # expect(await token1.balanceOf(pair.address)).to.eq(token1Amount)
    assert token1.balanceOf( pair.address) == token1Amount
    reserves = pair.getReserves
    # expect(reserves[0]).to.eq(token0Amount)
    assert reserves[0] == token0Amount
    # expect(reserves[1]).to.eq(token1Amount)
    assert reserves[1] == token1Amount       
  end  # method test_mint  
end  # class TestUniswapV2Pair

