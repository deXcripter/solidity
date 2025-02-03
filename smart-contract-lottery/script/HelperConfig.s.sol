// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    // 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B
    struct NetworkConfig {
        uint256 entranceFee;
        uint256 interval;
        uint256 _subscriptionId;
        address i_vrfCoordinator;
    }

    NetworkConfig public localNetworkConfig;

    mapping(uint256 => NetworkConfig) public networkConfigs;

    constructor() {
        networkConfigs[11155111] = getSepoliaEthConfig();
    }

    function getConfigByChainId(uint256 chainId) public returns(NetworkConfig memory) {
        if (networkConfigs[chainId].i_vrfCoordinator != address(0)) return networkConfigs[chainId];
        else if (chainId == 31337) {
            return getOrCreateAnvilEthConfig();
        } else revert();
    }

    function getOrCreateAnvilEthConfig() public returns(NetworkConfig memory) {
        if (localNetworkConfig.i_vrfCoordinator != address(0)) {
            return localNetworkConfig;
        }
    }

    function getSepoliaEthConfig() public pure returns(NetworkConfig memory) {
        return NetworkConfig(0.01 ether, 30, 0, 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B);
    }
}