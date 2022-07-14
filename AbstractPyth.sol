// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./PythStructs.sol";
import "./IPyth.sol";

abstract contract AbstractPyth is IPyth {

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

    function getPrevPriceUnsafe(bytes32 id) external view override returns (PythStructs.Price memory price, uint64 publishTime) {
        PythStructs.PriceFeed memory priceFeed = queryPriceFeed(id);

        price.price = priceFeed.prevPrice;
        price.conf = priceFeed.prevConf;
        price.expo = priceFeed.expo;
        return (price, priceFeed.prevPublishTime);
    }
}
