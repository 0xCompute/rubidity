###
# to run use:
#    ruby sandbox/test_LibAsset.rb

require_relative  'helper'



require_relative '../LibAsset.rb'



pp LibAsset::AssetType
pp LibAsset::AssetType.name 
pp LibAsset::AssetType.type 

pp LibAsset::Asset
pp LibAsset::Asset.name
pp LibAsset::Asset.type


pp LibAsset::ETH_ASSET_CLASS
pp LibAsset::ERC20_ASSET_CLASS
pp LibAsset::ERC721_ASSET_CLASS 
pp LibAsset::ERC1155_ASSET_CLASS
pp LibAsset::COLLECTION         
pp LibAsset::CRYPTO_PUNKS       

pp LibAsset::ASSET_TYPE_TYPEHASH

pp LibAsset::ASSET_TYPEHASH


assetType = LibAsset::AssetType.new(
                assetClass:  LibAsset::ERC20_ASSET_CLASS,
                data:        '0xffff' )
pp assetType


asset = LibAsset::Asset.new( 
                assetType: assetType,
                value:     123 )
pp asset



pp LibAsset.hashAssetType( assetType: assetType )

pp LibAsset.hashAsset( asset: asset )


puts "bye"