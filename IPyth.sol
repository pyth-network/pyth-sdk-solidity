// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./PythStructs.sol";

interface IPyth {
    
    // Returns the latest price information for the given price ID
    function queryPriceFeed(bytes32 id) public view returns (PythStructs.PriceFeedResponse memory priceFeed)

}
