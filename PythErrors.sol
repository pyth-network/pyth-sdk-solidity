// SPDX-License-Identifier: Apache 2

pragma solidity ^0.8.0;

/**
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
library PythErrors {
    // Function arguments are invalid (e.g., the arguments lengths mismatch)
    error InvalidArgument();
    // Update data is coming from an invalid data source.
    error InvalidUpdateDataSource();
    // Update data is invalid (e.g., deserialization error)
    error InvalidUpdateData();
    // Insufficient fee is paid to the method.
    error InsufficientFee();
    // There is no fresh update, whereas expected fresh updates.
    error NoFreshUpdate();
    // There is no price feed found within the given range or it does not exists.
    error PriceFeedNotFoundWithinRange();
    // Price feed not found or it is not pushed on-chain yet.
    error PriceFeedNotFound();
    // Requested price is stale.
    error StalePrice();
    // Given message is not a valid Wormhole VAA.
    error InvalidWormholeVaa();
    // Governance message is invalid (e.g., deserialization error).
    error InvalidGovernanceMessage();
    // Governance message is not for this contract.
    error InvalidGovernanceTarget();
    // Governance message is coming from an invalid data source.
    error InvalidGovernanceDataSource();
    // Governance message is old.
    error OldGovernanceMessage();
}
