// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

contract HelperConfig {
    // if we are on a local anvil, we deploy mocks
    // otherwise, grab the existing address from the live network

    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaETHConfig();
        } else {
            // activeNetworkConfig = getAnvilETHConfig();
        }
    }

    function getSepoliaETHConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });

        return sepoliaConfig;
    }

    function getAnvilETHConfig() public pure {}
}
