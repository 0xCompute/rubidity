# pragma solidity 0.7.6;


# how to deal with library??
#  use module (inside Contract) now


module LibAsset
##  add library machinery "by hand" for now - begin
  include Types
  def self.struct( class_name, **attributes )
     typedclass = Types::Struct.new( class_name, scope: self, **attributes )
     typedclass
  end
##  end
   

    struct :AssetType, 
       assetClass: Bytes,   # was bytes4
       data:       Bytes 
  
    struct :Asset,
       assetType: AssetType,
       value:     UInt

    ETH_ASSET_CLASS     = bytes4(keccak256("ETH"))   # was bytes4 (use first eight hexchars)
    ERC20_ASSET_CLASS   = bytes4(keccak256("ERC20"))
    ERC721_ASSET_CLASS  = bytes4(keccak256("ERC721"))
    ERC1155_ASSET_CLASS = bytes4(keccak256("ERC1155"))
    COLLECTION          = bytes4(keccak256("COLLECTION"))
    CRYPTO_PUNKS        = bytes4(keccak256("CRYPTO_PUNKS"))

    ASSET_TYPE_TYPEHASH = keccak256(
        "AssetType(bytes4 assetClass,bytes data)"
    )  # was bytes32

    ASSET_TYPEHASH = keccak256(
        "Asset(AssetType assetType,uint256 value)AssetType(bytes4 assetClass,bytes data)"
    )  # was bytes32
    

    # sig [AssetType], :pure, returns: Bytes   # was bytes32   
    def self.hashAssetType( assetType: )
        keccak256( abi_encode(
                ASSET_TYPE_TYPEHASH,
                assetType.assetClass,
                keccak256( assetType.data )
            ))
    end

    ## note: CANNOT overload function only by input type
    # sig [Asset], :pure, returns: Bytes
    def self.hashAsset( asset: )
        keccak256( abi_encode(
                    ASSET_TYPEHASH,
                   hashAssetType( assetType: asset.assetType ),
                   asset.value
                 ))
    end


end # module LibAsset

