# pragma solidity 0.7.6;
#
# import "@rarible/lib-asset/contracts/LibAsset.sol";
# 
# import "./LibMath.sol";
# import "./LibOrderDataV3.sol";
# import "./LibOrderDataV2.sol";
# import "./LibOrderDataV1.sol";




module LibOrder
##  add library machinery "by hand" for now - begin
  include Types
  def self.struct( class_name, **attributes )
     typedclass = Types::Struct.new( class_name, scope: self, **attributes )
     typedclass
  end
##  end
 


    ORDER_TYPEHASH = keccak256(
        "Order(address maker,Asset makeAsset,address taker,Asset takeAsset,uint256 salt,uint256 start,uint256 end,bytes4 dataType,bytes data)Asset(AssetType assetType,uint256 value)AssetType(bytes4 assetClass,bytes data)"
    )  ## bytes32

    DEFAULT_ORDER_TYPE  =  '0xffffffff'   ## bytes4; use bytes4('0xffffffff') - why? why not?

    struct :Order, 
        maker:     Address,
        makeAsset: LibAsset::Asset,
        taker:     Address,
        takeAsset: LibAsset::Asset,
        salt:      UInt,
        start:     Timestamp,     
        _end:      Timestamp,     ## end is keyword in ruby       
        dataType:  Bytes,         ## was: bytes4
        data:      Bytes 


    # sig [Order, UInt, Bool], :pure, returns: [UInt,UInt]  # returns makeValue, takeValue     
    def self.calculateRemaining( order:, fill:, isMakeFill: )
            if isMakeFill
                makeValue = order.makeAsset.value - fill
                takeValue = LibMath.safeGetPartialAmountFloor( order.takeAsset.value, order.makeAsset.value, makeValue)
             else 
                takeValue = order.takeAsset.value - fill
                makeValue = LibMath.safeGetPartialAmountFloor( order.makeAsset.value, order.takeAsset.value, takeValue) 
             end 

             [makeValue, takeValue]
    end


end  # module LibOrder


__END__



    function hashKey(Order memory order) internal pure returns (bytes32) {
        if (order.dataType == LibOrderDataV1.V1 || order.dataType == DEFAULT_ORDER_TYPE) {
            return keccak256(abi.encode(
                order.maker,
                LibAsset.hash(order.makeAsset.assetType),
                LibAsset.hash(order.takeAsset.assetType),
                order.salt
            ));
        } else {
            //order.data is in hash for V2, V3 and all new order
            return keccak256(abi.encode(
                order.maker,
                LibAsset.hash(order.makeAsset.assetType),
                LibAsset.hash(order.takeAsset.assetType),
                order.salt,
                order.data
            ));
        }
    }

    function hash(Order memory order) internal pure returns (bytes32) {
        return keccak256(abi.encode(
                ORDER_TYPEHASH,
                order.maker,
                LibAsset.hash(order.makeAsset),
                order.taker,
                LibAsset.hash(order.takeAsset),
                order.salt,
                order.start,
                order.end,
                order.dataType,
                keccak256(order.data)
            ));
    }

    function validateOrderTime(LibOrder.Order memory order) internal view {
        require(order.start == 0 || order.start < block.timestamp, "Order start validation failed");
        require(order.end == 0 || order.end > block.timestamp, "Order end validation failed");
    }
}

