###
# to run use:
#    ruby sandbox/test_LibOrder.rb

require_relative  'helper'



require_relative '../LibAsset.rb'
require_relative '../LibOrder.rb'



pp LibAsset::AssetType
pp LibAsset::AssetType.name 
pp LibAsset::AssetType.type 

pp LibAsset::Asset
pp LibAsset::Asset.name
pp LibAsset::Asset.type



pp LibOrder::ORDER_TYPEHASH
pp LibOrder::DEFAULT_ORDER_TYPE


pp LibOrder::Order
pp LibOrder::Order.name
pp LibOrder::Order.type

order = LibOrder::Order.new
pp order


ALICE  = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
BOB    = '0x'+'b'*40 

pp ALICE
pp BOB


makeAsset = LibAsset::Asset.new( 
              assetType: LibAsset::AssetType.new(
                            assetClass:  LibAsset::ERC20_ASSET_CLASS,
                            data:        '0xffff' ),
              value: 123 )
              
takeAsset = LibAsset::Asset.new( 
              assetType: LibAsset::AssetType.new(
                            assetClass:  LibAsset::ERC20_ASSET_CLASS,
                            data:        '0xeeee' ),
              value: 456 )             

pp makeAsset
pp takeAsset


order = LibOrder::Order.new(
            maker:  ALICE,
            makeAsset: makeAsset,
            taker:  BOB,
            takeAsset: takeAsset,
            salt:   666,
            start:  0,       
            _end:   999,       
            dataType:  '0xffff',        
            data:      '0x0000' ) 

pp order


puts "bye"