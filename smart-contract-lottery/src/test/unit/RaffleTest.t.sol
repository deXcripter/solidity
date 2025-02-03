// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployRaffle} from "../../../script/DeployRaffle.s.sol";
import {Raffle} from "../../Raffle.sol";
import {HelperConfig} from "../../../script/HelperConfig.s.sol";

contract RaffleTest is Test {

    Raffle public raffle;
    HelperConfig public helperConfig;

    address public PLAYER = makeAddr("player");
    uint256 public constant STARTING_PLAYER_BALANCE = 1000 ether; 

    uint256 public entranceFee;
    uint256 interval;
    uint subscriptionId;
    address vrfCoordinator;


    function setUp() external {
        DeployRaffle deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.deployContract();

        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        entranceFee = config.entranceFee;
        interval = config.interval;
        subscriptionId = config.subscriptionId;
        vrfCoordinator = config.vrfCoordinator;

    }

    function testRaffleInitializesInOpenState() external {
        assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
    }
}