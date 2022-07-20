// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./PythStructs.sol";

/// @title Consume prices from the Pyth Network (https://pyth.network/).
/// @dev Please refer to the guidance at https://docs.pyth.network/consumers/best-practices for how to consume prices safely.
/// @author Pyth Data Association
interface IPyth {
    /// @dev Emitted when price feed with `id` is updated.
    event PriceUpdate(bytes32 indexed id, uint64 publishTime);

    /// @notice Returns the current price and confidence interval.
    /// @dev Reverts if the current price is not available.
    /// @param id The Pyth Price Feed ID of which to fetch the current price and confidence interval.
    /// @return price - please read the documentation of PythStructs.Price to understand how to use this safely.
    function getCurrentPrice(bytes32 id) external view returns (PythStructs.Price memory price);

    /// @notice Returns the exponential moving average price and confidence interval.
    /// @dev Reverts if the current exponential moving average price is not available.
    /// @param id The Pyth Price Feed ID of which to fetch the current price and confidence interval.
    /// @return price - please read the documentation of PythStructs.Price to understand how to use this safely.
    function getEmaPrice(bytes32 id) external view returns (PythStructs.Price memory price);

    /// @notice Returns the most recent previous price with a status of Trading, with the time when this was published.
    /// @dev This may be a price from arbitrarily far in the past: it is important that you check the publish time before using the price.
    /// @return price - please read the documentation of PythStructs.Price to understand how to use this safely.
    /// @return publishTime - the UNIX timestamp of when this price was computed.
    function getPrevPriceUnsafe(bytes32 id) external view returns (PythStructs.Price memory price, uint64 publishTime);

    /// @notice Update price feeds with given update messages. You should pay a fee for updating the prices
    /// on pyth, and you can get its amount by calling `getMinUpdateFee` method.
    /// Prices will be updated if they are more recent than the current stored prices.
    /// The call will succeed even if the update is not the most recent.
    /// @dev Reverts if the transferred fee is not sufficient or the updateData is invalid.
    /// @param updateData Array of price update data.
    function updatePriceFeeds(bytes[] memory updateData) external payable;

    /// @notice Returns the needed fee to update an array of price updates.
    /// @param updateDataSize Number of price updates.
    function getMinUpdateFee(uint updateDataSize) external view returns (uint feeAmount);
}
