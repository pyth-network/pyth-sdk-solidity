// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./PythStructs.sol";
import "./IPyth.sol";

abstract contract AbstractPyth is IPyth {
    /// @notice Returns the price feed with given id.
    /// @dev Reverts if the price does not exist.
    /// @param id The Pyth Price Feed ID of which to fetch the current price and confidence interval.
    function queryPriceFeed(bytes32 id) public view virtual returns (PythStructs.PriceFeed memory priceFeed);

    function getCurrentPrice(bytes32 id) external view override returns (PythStructs.Price memory price) {
        PythStructs.PriceFeed memory priceFeed = queryPriceFeed(id);

        require(priceFeed.status == PythStructs.PriceStatus.TRADING, "current price unavailable");

        price.price = priceFeed.price;
        price.conf = priceFeed.conf;
        price.expo = priceFeed.expo;
        return price;
    }

    function getEmaPrice(bytes32 id) external view override returns (PythStructs.Price memory price) {
        PythStructs.PriceFeed memory priceFeed = queryPriceFeed(id);

        price.price = priceFeed.emaPrice;
        price.conf = priceFeed.emaConf;
        price.expo = priceFeed.expo;
        return price;
    }

    function getLatestAvailablePriceUnsafe(bytes32 id) public view override returns (PythStructs.Price memory price, uint64 publishTime) {
        PythStructs.PriceFeed memory priceFeed = queryPriceFeed(id);

        price.expo = priceFeed.expo;
        if (priceFeed.status == PythStructs.PriceStatus.TRADING) {
            price.price = priceFeed.price;
            price.conf = priceFeed.conf;
            return (price, priceFeed.publishTime);
        }

        price.price = priceFeed.prevPrice;
        price.conf = priceFeed.prevConf;
        return (price, priceFeed.prevPublishTime);
    }

    function getLatestAvailablePriceWithinDuration(bytes32 id, uint64 duration) external view override returns (PythStructs.Price memory price) {
        uint64 publishTime;
        (price, publishTime) = getLatestAvailablePriceUnsafe(id);

        require(diff(block.timestamp, publishTime) <= duration, "No available price within given duration");

        return price;
    }

    function diff(uint x, uint y) private pure returns (uint) {
        if (x > y) {
            return x - y;
        } else {
            return y - x;
        }
    }

    // Access modifier is overridden to public to be able to call it locally.
    function updatePriceFeeds(bytes[] memory updateData) public virtual payable override;

    function updatePriceFeedsIfNecessary(bytes[] memory updateData, bytes32[] memory priceIds, uint64[] memory publishTimes) external payable {
        require(priceIds.length == publishTimes.length, "priceIds and publishTimes arrays should have same length");

        bool updateNeeded = false;
        for(uint i = 0; i < priceIds.length; i++) {
            if (queryPriceFeed(priceIds[i]).publishTime < publishTimes[i]) {
                updateNeeded = true;
            }
        }

        require(updateNeeded, "All the prices have been updated, no update needed");

        updatePriceFeeds(updateData);
    }
}
