// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./AbstractPyth.sol";
import "./PythStructs.sol";

contract MockPyth is AbstractPyth {
    mapping(bytes32 => PythStructs.PriceFeed) priceFeeds;
    uint64 sequenceNumber;

    uint singleUpdateFeeInWei;

    constructor(uint _singleUpdateFeeInWei) {
        singleUpdateFeeInWei = _singleUpdateFeeInWei;
    }

    function queryPriceFeed(bytes32 id) public override view returns (PythStructs.PriceFeed memory priceFeed) {
        return priceFeeds[id];
    }

    // Takes an array of encoded price feeds and stores them.
    // You can create this data either by calling createPriceFeedData or
    // by using web3.js or ethers abi utilities.
    function updatePriceFeeds(bytes[] memory updateData) public override payable {
        uint requiredFee = getUpdateFee(updateData.length);
        require(msg.value >= requiredFee, "Insufficient paid fee amount");
        payable(msg.sender).transfer(msg.value - requiredFee);

        uint freshPrices = 0;

        // Chain ID is id of the source chain that the price update comes from. Since it is just a mock contract
        // We set it to 1.
        uint16 chainId = 1;

        for(uint i = 0; i < updateData.length; i++) {
            PythStructs.PriceFeed memory priceFeed = abi.decode(updateData[i], (PythStructs.PriceFeed));

            bool fresh = false;
            uint64 lastPublishTime = priceFeeds[priceFeed.id].publishTime;

            if (lastPublishTime < priceFeed.publishTime) {
                // Price information is more recent than the existing price information.
                fresh = true;
                priceFeeds[priceFeed.id] = priceFeed;
                freshPrices += 1;
            }

            emit PriceFeedUpdate(priceFeed.id, fresh, chainId, sequenceNumber, priceFeed.publishTime,
                lastPublishTime, priceFeed.price, priceFeed.conf);
        }

        // In the real contract, the input of this function contains multiple batches that each contain multiple prices.
        // This event is emitted when a batch is processed. In this mock contract we consider there is only one batch of prices.
        // Each batch has (chainId, sequenceNumber) as it's unique identifier. Here chainId is set to 1 and an increasing sequence number is used.
        emit BatchPriceFeedUpdate(chainId, sequenceNumber, updateData.length, freshPrices);
        sequenceNumber += 1;

        // There is only 1 batch of prices
        emit UpdatePriceFeeds(msg.sender, 1, requiredFee);
    }

    function getUpdateFee(uint updateDataSize) public override view returns (uint feeAmount) {
        return singleUpdateFeeInWei * updateDataSize;
    }

    function createPriceFeedUpdateData(
        bytes32 id,
        int64 price,
        uint64 conf,
        int32 expo,
        uint8 status,
        int64 emaPrice,
        uint64 emaConf,
        uint64 publishTime,
        int64 prevPrice,
        uint64 prevConf,
        uint64 prevPublishTime
    ) public pure returns (bytes memory priceFeedData) {
        PythStructs.PriceFeed memory priceFeed;

        priceFeed.id = id;
        priceFeed.productId = id;
        priceFeed.price = price;
        priceFeed.conf = conf;
        priceFeed.expo = expo;
        priceFeed.status = PythStructs.PriceStatus(status);
        priceFeed.maxNumPublishers = 10;
        priceFeed.numPublishers = 10;
        priceFeed.emaPrice = emaPrice;
        priceFeed.emaConf = emaConf;
        priceFeed.publishTime = publishTime;
        priceFeed.prevPrice = prevPrice;
        priceFeed.prevConf = prevConf;
        priceFeed.prevPublishTime = prevPublishTime;

        priceFeedData = abi.encode(priceFeed);
    }
}
