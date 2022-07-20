// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./AbstractPyth.sol";
import "./PythStructs.sol";

contract MockPyth is AbstractPyth {
    mapping(bytes32 => PythStructs.PriceFeed) priceFeeds;

    uint singleUpdateFee;

    constructor(uint _singleUpdateFee) {
        singleUpdateFee = _singleUpdateFee;
    }

    function queryPriceFeed(bytes32 id) public override view returns (PythStructs.PriceFeed memory priceFeed) {
        return priceFeeds[id];
    }

    // Takes an array of encoded price feeds and stores them.
    // You can create this data either by calling createPriceFeedData or
    // by using web3.js or ethers abi utilities.
    function updatePriceFeeds(bytes[] memory updateData) public override payable {
        require(msg.value >= getMinUpdateFee(updateData.length), "Insufficient fee amount");

        for(uint i = 0; i < updateData.length; i++) {
            PythStructs.PriceFeed memory priceFeed = abi.decode(updateData[i], (PythStructs.PriceFeed));
            priceFeeds[priceFeed.id] = priceFeed;
            emit PriceUpdate(priceFeed.id, priceFeed.publishTime);
        }
    }

    function getMinUpdateFee(uint updateDataSize) public override view returns (uint feeAmount) {
        return singleUpdateFee * updateDataSize;
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
