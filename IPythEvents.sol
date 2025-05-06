// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

/**
 * @title IPythEvents contains the events that Pyth contract emits.
 * @notice **Deprecated** – this codebase will be removed on **1 August 2025**.
 *
 * @dev    Switch to the maintained package:
 *         `npm install @pythnetwork/pyth-sdk-solidity`
 *
 *         Migration guide:
 *         https://docs.pyth.network/price-feeds/use-real-time-data/evm
 *
 * @custom:deprecated Repository scheduled for deletion on 1 August 2025.
 *                    Use `@pythnetwork/pyth-sdk-solidity` instead.
 */
interface IPythEvents {
    /// @dev Emitted when the price feed with `id` has received a fresh update.
    /// @param id The Pyth Price Feed ID.
    /// @param publishTime Publish time of the given price update.
    /// @param price Price of the given price update.
    /// @param conf Confidence interval of the given price update.
    event PriceFeedUpdate(
        bytes32 indexed id,
        uint64 publishTime,
        int64 price,
        uint64 conf
    );

    /// @dev Emitted when a batch price update is processed successfully.
    /// @param chainId ID of the source chain that the batch price update comes from.
    /// @param sequenceNumber Sequence number of the batch price update.
    event BatchPriceFeedUpdate(uint16 chainId, uint64 sequenceNumber);
}
