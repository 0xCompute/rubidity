# pragma solidity 0.7.6;
# pragma abicoder v2;
# 
# import "./libraries/LibFill.sol";
# import "./libraries/LibOrderData.sol";
# import "./libraries/LibDirectTransfer.sol";
# import "./OrderValidator.sol";
# import "./AssetMatcher.sol";

# import "@rarible/transfer-manager/contracts/TransferExecutor.sol";
# import "@rarible/transfer-manager/contracts/interfaces/ITransferManager.sol";
# import "@rarible/transfer-manager/contracts/lib/LibDeal.sol";

# abstract contract ExchangeV2Core is Initializable, OwnableUpgradeable, AssetMatcher, TransferExecutor, OrderValidator, ITransferManager {
#    using SafeMathUpgradeable for uint;
#    using LibTransfer for address;


class ExchangeV2Core < Contract    # abstract

    # uint256 private constant UINT256_MAX = type(uint256).max;
    UINT256_MAX = 2**256-1

    # events
    event :Cancel, hash: Bytes   # was: bytes32 
    event :Match,  leftHash:  Bytes,  # was bytes32 
                   rightHash: Bytes,  # was bytes32 
                   newLeftFill: UInt,
                   newRightFill: UInt

    # state of the orders
    storage fills: mapping( Bytes, UInt ) ## was bytes32 => uint 

    sig [LibOrder::Order]
    def cancel( order: ), :external
        assert _msgSender == order.maker, "not a maker"
        assert order.salt != 0, "0 salt can't be used"
        
        orderKeyHash = LibOrder.hashKey( order )
        @fills[ orderKeyHash ] = UINT256_MAX
        log Cancel, hash: orderKeyHash
    end


    #
    # @dev function, generate sellOrder and buyOrder from parameters
    #       and call validateAndMatch() for purchase transaction
    #  
    # -fix-fix-fix - payable not supported / use erc20 token
    sig [LibDirectTransfer::Purchase]  
    def directPurchase( direct: ), :external, :payable
        paymentAssetType = getPaymentAssetType( direct.paymentToken ) # LibAsset::AssetType
                
        sellOrder = LibOrder::Order.new(
                     direct.sellOrderMaker,
                     LibAsset::Asset.new(
                       LibAsset::AssetType.new(
                         direct.nftAssetClass,
                         direct.nftData
                       ),
                     direct.sellOrderNftAmount
                     ),
                     address(0),
                     LibAsset::Asset.new(
                       paymentAssetType,
                       direct.sellOrderPaymentAmount
                     ),
                     direct.sellOrderSalt,
                     direct.sellOrderStart,
                     direct.sellOrderEnd,
                     direct.sellOrderDataType,
                     direct.sellOrderData
                    )

        buyOrder = LibOrder::Order.new(
                    address(0),
                    LibAsset::Asset.new(
                      paymentAssetType,
                      direct.buyOrderPaymentAmount
                    ),
                    address(0),
                    LibAsset::Asset.new(
                      LibAsset::AssetType.new(
                        direct.nftAssetClass,
                        direct.nftData
                      ),
                      direct.buyOrderNftAmount
                    ),
                    0,
                    0,
                    0,
                    getOtherOrderType(direct.sellOrderDataType),
                    direct.buyOrderData
                  )

        validateFull( sellOrder, direct.sellOrderSignature )

        matchAndTransfer(sellOrder, buyOrder)
    end

    #
    # @dev function, generate sellOrder and buyOrder from parameters 
    #        and call validateAndMatch() for accept bid transaction
    # @param direct struct with parameters for accept bid operation
    #
    # -fix-fix-fix - payable not supported / use erc20 token
    sig [LibDirectTransfer::AcceptBid], :external, :payable
    def directAcceptBid( direct: ) 
        paymentAssetType = getPaymentAssetType(direct.paymentToken) # LibAsset.AssetType

        buyOrder = LibOrder::Order.new(
            direct.bidMaker,
            LibAsset::Asset.new(
                paymentAssetType,
                direct.bidPaymentAmount
            ),
            address(0),
            LibAsset::Asset.new(
                LibAsset::AssetType.new(
                    direct.nftAssetClass,
                    direct.nftData
                ),
                direct.bidNftAmount
            ),
            direct.bidSalt,
            direct.bidStart,
            direct.bidEnd,
            direct.bidDataType,
            direct.bidData
        )

        sellOrder = LibOrder::Order.new(
            address(0),
            LibAsset::Asset.new(
                LibAsset::AssetType.new(
                    direct.nftAssetClass,
                    direct.nftData
                ),
                direct.sellOrderNftAmount
            ),
            address(0),
            LibAsset::Asset.new(
                paymentAssetType,
                direct.sellOrderPaymentAmount
            ),
            0,
            0,
            0,
            getOtherOrderType(direct.bidDataType),
            direct.sellOrderData
        )

        validateFull( buyOrder, direct.bidSignature )

        matchAndTransfer( sellOrder, buyOrder )
    end


    # -fix-fix-fix - payable not supported / use erc20 token
    sig [LibOrder::Order, Bytes, LibOrder::Order, Bytes], :external, :payable
    def matchOrders(
         orderLeft:,
         signatureLeft:,
         orderRight:,
         signatureRight: ) 
        _validateOrders( orderLeft, signatureLeft, orderRight, signatureRight )
        matchAndTransfer( orderLeft, orderRight )
    end

    #
    # @dev function, validate orders
    #  @param orderLeft left order
    #  @param signatureLeft order left signature
    #  @param orderRight right order
    #  @param signatureRight order right signature
    #
    sig [LibOrder::Order, Bytes, LibOrder::Order, Bytes], :view 
    def _validateOrders( orderLeft:, signatureLeft:, orderRight:, signatureRight: ) 
        validateFull( orderLeft, signatureLeft )
        validateFull( orderRight, signatureRight )
        if orderLeft.taker != address(0)
            if orderRight.maker != address(0)
                assert orderRight.maker == orderLeft.taker, "leftOrder.taker verification failed"
            end
        end
        if orderRight.taker != address(0)
            if orderLeft.maker != address(0)
                assert orderRight.taker == orderLeft.maker, "rightOrder.taker verification failed"
            end
        end
    end

    #
    #   @notice matches valid orders and transfers their assets
    #   @param orderLeft the left order of the match
    #  @param orderRight the right order of the match
    #
    sig [LibOrder::Order, LibOrder::Order]
    def _matchAndTransfer( orderLeft:, orderRight: ) 
        # (LibAsset.AssetType memory makeMatch, LibAsset.AssetType memory takeMatch)
        makeMatch, takeMatch = matchAssets(orderLeft, orderRight)

        # (LibOrderData.GenericOrderData memory leftOrderData, LibOrderData.GenericOrderData memory rightOrderData, LibFill.FillResult memory newFill) 
        leftOrderData, rightOrderData, newFill  = parseOrdersSetFillEmitMatch(orderLeft, orderRight)

        totalMakeValue, totalTakeValue = doTransfers(
            LibDeal::DealSide.new(
                asset: LibAsset::Asset.new(
                            assetType: makeMatch,
                            value: newFill.leftValue
                ),
                payouts: leftOrderData.payouts,
                originFees: leftOrderData.originFees,
                proxy: proxies[makeMatch.assetClass],
                from: orderLeft.maker
            ), 
            LibDeal::DealSide.new(
                asset: LibAsset::Asset.new( 
                    takeMatch,
                    newFill.rightValue
                ),
                payouts: rightOrderData.payouts,
                originFees: rightOrderData.originFees,
                proxy: proxies[takeMatch.assetClass],
                from: orderRight.maker
            ),
            getDealData(
                makeMatch.assetClass,
                takeMatch.assetClass,
                orderLeft.dataType,
                orderRight.dataType,
                leftOrderData,
                rightOrderData
            )
        )

        # -fix-fix-fix - msg.value not supported / use erc20 token
        if makeMatch.assetClass == LibAsset::ETH_ASSET_CLASS
            assert takeMatch.assetClass != LibAsset::ETH_ASSET_CLASS
            assert msg.value >= totalMakeValue, "not enough eth"
            if msg.value > totalMakeValue
                address( msg.sender ).transferEth( msg.value.sub(totalMakeValue))
            end
        elsif takeMatch.assetClass == LibAsset::ETH_ASSET_CLASS
            assert msg.value >= totalTakeValue, "not enough eth"
            if msg.value > totalTakeValue
                address(msg.sender).transferEth(msg.value.sub(totalTakeValue))
            end
        end
    end

    # returns leftOrderData, rightOrderData, newFill
    sig [LibOrder::Order, LibOrder::Order], returns: [LibOrderData::GenericOrderData, 
                                                      LibOrderData::GenericOrderData,
                                                      LibFill::FillResult]
    def _parseOrdersSetFillEmitMatch( orderLeft:, orderRight: )
        leftOrderKeyHash  = LibOrder.hashKey(orderLeft)
        rightOrderKeyHash = LibOrder.hashKey(orderRight)

        msgSender = _msgSender
        if orderLeft.maker == address(0)
            orderLeft.maker = msgSender
        end
        if orderRight.maker == address(0)
            orderRight.maker = msgSender
        end

        leftOrderData = LibOrderData.parse( orderLeft )
        rightOrderData = LibOrderData.parse( orderRight )

        newFill = setFillEmitMatch(
            orderLeft,
            orderRight,
            leftOrderKeyHash,
            rightOrderKeyHash,
            leftOrderData.isMakeFill,
            rightOrderData.isMakeFill
        )
    end

    # returns dealData
    sig [Bytes, Bytes, Bytes, Bytes, 
         LibOrderData::GenericOrderData, 
         LibOrderData::GenericOrderData], :pure, returns: LibDeal::DealData
    def _getDealData(
        makeMatchAssetClass:,
        takeMatchAssetClass:,
        leftDataType:,
        rightDataType:,
        leftOrderData:,
        rightOrderData: )
        LibDeal::DealData.new(
          feeSide: LibFeeSide.getFeeSide( makeMatchAssetClass, takeMatchAssetClass ),
          maxFeesBasePoint: getMaxFee(
            leftDataType,
            rightDataType,
            leftOrderData,
            rightOrderData,
            dealData.feeSide
        ))
    end

    #
    #  @notice determines the max amount of fees for the match
    #   @param dataTypeLeft data type of the left order
    #   @param dataTypeRight data type of the right order
    #   @param leftOrderData data of the left order
    #  @param rightOrderData data of the right order
    #  @param feeSide fee side of the match
    #  @return max fee amount in base points
    
    sig [Bytes, Bytes, 
         LibOrderData::GenericOrderData,
         LibOrderData::GenericOrderData,
         LibFeeSide::FeeSide], :pure, returns: UInt
    def _getMaxFee(
        dataTypeLeft:,
        dataTypeRight:,
        leftOrderData:,
        rightOrderData:,
        feeSide: )
        if  dataTypeLeft != LibOrderDataV3::V3_SELL &&
            dataTypeRight != LibOrderDataV3::V3_SELL &&
            dataTypeLeft != LibOrderDataV3::V3_BUY &&
            dataTypeRight != LibOrderDataV3::V3_BUY
             return 0
        end

        matchFees = getSumFees( leftOrderData.originFees, rightOrderData.originFees )
        maxFee = 0
        if feeSide == LibFeeSide::FeeSide.LEFT
            maxFee = rightOrderData.maxFeesBasePoint
            assert
                dataTypeLeft == LibOrderDataV3::V3_BUY &&
                dataTypeRight == LibOrderDataV3::V3_SELL,
                "wrong V3 type1"
        elsif feeSide == LibFeeSide::FeeSide.RIGHT
            maxFee = leftOrderData.maxFeesBasePoint
            assert
                dataTypeRight == LibOrderDataV3::V3_BUY &&
                dataTypeLeft == LibOrderDataV3::V3_SELL,
                "wrong V3 type2"
        else 
          return 0
        end
        assert
            maxFee > 0 &&
            maxFee >= matchFees &&
            maxFee <= 1000,
            "wrong maxFee"

        maxFee
    end

    #
    #   @notice calculates amount of fees for the match
    #   @param originLeft origin fees of the left order
    #   @param originRight origin fees of the right order
    #    @return sum of all fees for the match (protcolFee + leftOrder.originFees + rightOrder.originFees)
    #
    sig [array(LibPart.Part),
         array(LibPart.Part)], :pure, return: UInt
    def _getSumFees( originLeft:, 
                     originRight: ) 
        result = 0

        # adding left origin fees
        for i in 0..originLeft.length
            result = result + originLeft[i].value
        end

        # adding right origin fees
        for i in 0..originRight.length
            result = result + originRight[i].value
        end

        result
    end

    #
    #    @notice calculates fills for the matched orders and set them in "fills" mapping
    #    @param orderLeft left order of the match
    #    @param orderRight right order of the match
    #    @param leftMakeFill true if the left orders uses make-side fills, false otherwise
    #    @param rightMakeFill true if the right orders uses make-side fills, false otherwise
    #    @return returns change in orders' fills by the match 
    #
    sig [LibOrder::Order,
         LibOrder::Order,
         Bytes, Bytes, Bool, Bool], returns: LibFill::FillResult
    def _setFillEmitMatch(
        orderLeft:
        orderRight:,
        leftOrderKeyHash:,
        rightOrderKeyHash:,
        leftMakeFill:,
        rightMakeFill: )
        leftOrderFill = getOrderFill(orderLeft.salt, leftOrderKeyHash)
        rightOrderFill = getOrderFill(orderRight.salt, rightOrderKeyHash)
        newFill = LibFill.fillOrder(orderLeft, orderRight, leftOrderFill, rightOrderFill, leftMakeFill, rightMakeFill)

        assert newFill.rightValue > 0 && newFill.leftValue > 0, "nothing to fill"

        if orderLeft.salt != 0
            if leftMakeFill
                @fills[leftOrderKeyHash] = leftOrderFill.add(newFill.leftValue)
            else 
                @fills[leftOrderKeyHash] = leftOrderFill.add(newFill.rightValue)
            end
        end

        if orderRight.salt != 0
            if rightMakeFill
                @fills[rightOrderKeyHash] = rightOrderFill.add(newFill.rightValue)
            else 
                @fills[rightOrderKeyHash] = rightOrderFill.add(newFill.leftValue)
            end
        end

        log Match, 
           leftHash: leftOrderKeyHash, 
           rightHash: rightOrderKeyHash, 
           newLeftFill: newFill.rightValue,
           newRightFill: newFill.leftValue

        newFill
    end


    sig [UInt, Bytes], :view, returns: UInt
    def _getOrderFill( salt:, hash: )
        if salt == 0 
            0
        else 
           @fills[hash]
        end
    end


    # returns makeMatch, takeMatch
    sig [LibOrder::Order, LibOrder::Order], :view, returns: [LibAsset.AssetType, LibAsset.AssetType]
    def _matchAssets( orderLeft:, orderRight:) 
        makeMatch = matchAssets(orderLeft.makeAsset.assetType, orderRight.takeAsset.assetType
        assert makeMatch.assetClass != 0, "assets don't match"
        takeMatch = matchAssets(orderLeft.takeAsset.assetType, orderRight.makeAsset.assetType
        assert takeMatch.assetClass != 0, "assets don't match"

        [makeMatch, takeMatch]
    end

    sig [LibOrder::Order, Bytes], :view
    def _validateFull( order:, signature: )
        LibOrder.validateOrderTime( order )
        validate(order, signature)
    end

    sig [Address], :pure, returns: LibAsset::AssetType 
    def _getPaymentAssetType( token: )
        if token == address(0) 
            LibAsset::AssetType.new(
                assetClass: LibAsset::ETH_ASSET_CLASS )
        else 
            LibAsset::AssetType.new(
               assetClass: LibAsset::ERC20_ASSET_CLASS, 
               data: abi.encode(token) ) # -fix-fix-fix- abi.encode???
        end
    end

    sig [Bytes], :pure, returns: Bytes
    def _getOtherOrderType( dataType: )
        if dataType == LibOrderDataV3::V3_SELL
            LibOrderDataV3::V3_BUY
        end
        if dataType == LibOrderDataV3.V3_BUY
            LibOrderDataV3::V3_SELL
        end
    end
end


