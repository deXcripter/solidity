// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {VRFCoordinatorV2_5Mock} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

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
        uint96 MOCK_BASE_FEE = 0.01 ether;
        uint32 MOCK_GAS_PRICE_LINK = 1e9;
        int256 MOCK_WEI_PER_UNIT_LINK = 4e15;

        if (localNetworkConfig.i_vrfCoordinator != address(0)) {
            return localNetworkConfig;
        }

        vm.startBroadcast();
        VRFCoordinatorV2_5Mock vrfCoordinator = new VRFCoordinatorV2_5Mock(MOCK_BASE_FEE, MOCK_GAS_PRICE_LINK, MOCK_WEI_PER_UNIT_LINK);
        vm.stopBroadcast();

        localNetworkConfig = NetworkConfig(0.01 ether, 30, 0, address(vrfCoordinator));
    }

    function getSepoliaEthConfig() public pure returns(NetworkConfig memory) {
        return NetworkConfig(0.01 ether, 30, 0, 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B);
    }
}