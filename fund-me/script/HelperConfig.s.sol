// 1. Deploy mocks when we are on a local anvil chain.
// 2. Keep track of contract address across different chains

// SEPOLIA ETH/USD => different address
// Mainnet ETH/USD => different address

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    // if we are on anvil chain, we deploy mocks.
    // otherwise, grab the existing address from the live network

    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address pricefeed;
    }

    constructor() {
      if (block.chainid === 11155111) {
        activeNetworkConfig = getSepoliaEthConfig();
      } else {
        activeNetworkConfig  = getAnvilEthConfig();
      }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // proce feed address
        NetworkConfig memory sepolaConfig = NetworkConfig(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        return sepolaConfig;
    }

    function getAnvilEthConfig() public {
        // price feed address
    }
}
