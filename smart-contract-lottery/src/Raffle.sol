// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {VRFConsumerBaseV2Plus} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

/**
 * @title Raffle
 * @author deXcripter
 * @notice
 * @dev
 */
contract Raffle is VRFConsumerBaseV2Plus {
    error Raffle__NotEnoughEthSent();

    uint256 private immutable i_EntranceFee;
    uint256 private immutable i_interval; // duration of the lottery in seconds
    address payable[] private s_players;
    uint256 private s_lastTimeStamp;

    uint256 private immutable i_subscriptionId;
    address vrfCoordinator = 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B; // the contract we interact with to get the random number (sepolia only)
    bytes32 s_keyHash =
        0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae;
    uint32 private constant callbackGasLimit = 40000;
    uint16 private constant requestConfirmations = 3;
    uint32 private constant numWords = 1;

    /* Events */
    event Raffle__PlayerEntered(address indexed player);

    constructor(
        uint256 entranceFee,
        uint256 interval,
        uint256 _subscriptionId
    ) VRFConsumerBaseV2Plus(vrfCoordinator) {
        i_EntranceFee = entranceFee;
        i_interval = interval;
        uint256 eStamp = block.timestamp;
        s_lastTimeStamp = eStamp;
        i_subscriptionId = _subscriptionId;
    }

    function enterRaffle() external payable {
        // require(msg.value >= i_EntranceFee, "Not enough ETH sent");
        if (msg.value < i_EntranceFee) revert Raffle__NotEnoughEthSent();
        s_players.push(payable(msg.sender));
        emit Raffle__PlayerEntered(msg.sender);
    }

    /**
     * @notice Selects a winner from the players list
     * @dev This function gets a random numner to select a winner
     */
    function selectWinner() external {
        if ((block.timestamp - s_lastTimeStamp) < i_interval) {
            revert();
        }
        // Get our random number from Chainlink VRF
        uint256 requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: s_keyHash,
                subId: s_subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                // Set nativePayment to true to pay for VRF requests with Sepolia ETH instead of LINK
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: true})
                )
            })
        );
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] calldata randomWords
    ) internal virtual override {}

    /**
     * GETTERS
     */
    function getEntranceFee() public view returns (uint256) {
        return i_EntranceFee;
    }
}
