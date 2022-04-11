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

    function getBTCUSDPrice() public returns (PythStructs.Price memory) {
        bytes32 priceID = 0xf9c0172ba10dfa4d19088d94f5bf61d3b54d5bd7483a322a982e1373ee8ea31b;
        return pyth.getCurrentPrice(priceID);
    }
}
```

## Solidity Target Chains
The Pyth oracle is currently live on the following chains which support Solidity, with the following symbols:

### Binance Smart Chain Testnet
Contract address: `0x621284a611b64dEa837924092F3B6C12C03C386E`

| Symbol          | Price ID                                                             |
|-----------------|----------------------------------------------------------------------|
| Crypto.BTC/USD  | `0xf9c0172ba10dfa4d19088d94f5bf61d3b54d5bd7483a322a982e1373ee8ea31b` |
| Crypto.ETH/USD  | `0xca80ba6dc32e08d06f1aa886011eed1d77c77be9eb761cc10d72b7d0a2fd57a6` |
| Crypto.LUNA/USD | `0x6de025a4cf28124f8ea6cb8085f860096dbc36d9c40002e221fc449337e065b2` |
| Crypto.UST/USD  | `0x026d1f1cf9f1c0ee92eb55696d3bd2393075b611c4f468ae5b967175edc4c25c` | 
| Crypto.ALGO/USD | `0x08f781a893bc9340140c5f89c8a96f438bcfae4d1474cc0f688e3a52892c7318` |
