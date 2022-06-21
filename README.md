# Pyth Solidity SDK
This package provides utilities for consuming prices from the [Pyth Network](https://pyth.network/) Oracle using Solidity.

It is **strongly recommended** to follow the [consumer best practices](https://docs.pyth.network/consumers/best-practices) when consuming Pyth data.

## Installation
```bash
npm install @pythnetwork/pyth-sdk-solidity
```

## Example Usage

To consume prices you should use the [`IPyth`](IPyth.sol) interface. Please make sure to read the documentation of this interface in order to use the prices safely.

For example, to read the latest price, call [`getCurrentPrice`](IPyth.sol) with the Price ID of the price feed you're interested in. The price feeds available on each chain are listed [below](#target-chains).

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@pythnetwork/pyth-sdk-solidity/IPyth.sol";
import "@pythnetwork/pyth-sdk-solidity/PythStructs.sol";

contract ExampleContract {
    IPyth pyth;

    constructor(address pythContract) {
        pyth = IPyth(pythContract);
    }

    function getBTCUSDPrice(bytes[] memory priceUpdateData) public returns (PythStructs.Price memory) {
        // Update the prices to be set to the latest values. The `priceUpdateData` data should be
        // retrieved from our off-chain Price Service API using the `pyth-evm-js` package.
        // See section "How Pyth Works on EVM Chains" below for more information.
        pyth.updatePriceFeeds(priceUpdateData);

        bytes32 priceID = 0xf9c0172ba10dfa4d19088d94f5bf61d3b54d5bd7483a322a982e1373ee8ea31b;
        return pyth.getCurrentPrice(priceID);
    }
}
```


## How Pyth Works on EVM Chains

Pyth prices are published on Solana, and relayed to EVM chains using the [Wormhole Network](https://wormholenetwork.com/) as a cross-chain message passing bridge. The Wormhole Network observes when Pyth prices on Solana have changed and publishes an off-chain signed message attesting to this fact. This is explained in more detail [here](https://docs.wormholenetwork.com/wormhole/).

This signed message can then be submitted to the Pyth contract on the EVM networks, which will verify the Wormhole message and update the Pyth contract with the new price.

### On-demand price updates

Price updates are not submitted on the EVM networks automatically: rather, when a consumer needs to use the value of a price they should first submit the latest Wormhole update for that price to the Pyth contract on the EVM network they are working on. This will make the most recent price update available on-chain for EVM contracts to use. Updating the price needs to be done in an off-chain program, using the [pyth-evm-js](https://github.com/pyth-network/pyth-js/tree/main/pyth-evm-js) package. 

## Solidity Target Chains
[This](https://docs.pyth.network/consume-data/evm#networks) document contains list of the EVM networks that Pyth is available on.

You can find a list of available price feeds [here](https://pyth.network/developers/price-feed-ids/).
