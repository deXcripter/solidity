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
    error Raffle__TransferFail();
    error Raffle__NotOpen();

    // Type Declarations
    enum RaffleState {
        OPEN, // 0
        CALCULATING_WINNER // 1
    }

    // Variables
    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval; // duration of the lottery in seconds
    address payable[] private s_players;
    uint256 private s_lastTimeStamp;

    uint256 private immutable i_subscriptionId;
    address immutable i_vrfCoordinator; // the contract we interact with to get the random number (sepolia only)
    // address vrfCoordinator = 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B; // the contract we interact with to get the random number (sepolia only)
    bytes32 s_keyHash =
        0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae;
    uint32 private constant callbackGasLimit = 40000;
    uint16 private constant requestConfirmations = 3;
    uint32 private constant numWords = 1;

    address private s_recentWinner;
    RaffleState private s_raffleState;

    /* Events */
    event Raffle__PlayerEntered(address indexed player);
    event WinnerPicked(address indexed winner);

    constructor(
        uint256 entranceFee,
        uint256 interval,
        uint256 _subscriptionId,
        address _vrfCoordinator
    ) VRFConsumerBaseV2Plus(_vrfCoordinator) {
        i_vrfCoordinator = _vrfCoordinator;
        i_entranceFee = entranceFee;
        i_interval = interval;
        uint256 eStamp = block.timestamp;
        i_subscriptionId = _subscriptionId;

        s_lastTimeStamp = eStamp;
        s_raffleState = RaffleState.OPEN;
    }

    /**
     * @dev this is the functon that the chainlink nodes will call to see if the lottery is ready to have a  winner.
     *      the following should be true in order for upkeepNeeded to be true:
     *      1. The time interval has passed between raffle draws.
     *      2. The lottery is open.
     *      3. The contract has ETH
     *      4. Implicitly, your subscrpition has LINK
     * @param - ignored
     * @return upkeepNeeded -
     * @return
     */
    function checkUpkeep(
        bytes memory /* checkData */
    ) public view returns (bool upkeepNeeded, bytes memory /* performData */) {
        bool timeHasPassed = ((block.timestamp - s_lastTimeStamp) < i_interval);
        bool isOpen = s_raffleState == RaffleState.OPEN;
        bool hasBanance = address(this).balance > 0;
        bool hasPlayers = s_players.length > 0;

        upkeepNeeded = timeHasPassed && isOpen && hasBanance && hasPlayers;

        return (upkeepNeeded, (""));
    }

    function enterRaffle() external payable {
        if (msg.value < i_entranceFee) revert Raffle__NotEnoughEthSent();
        if (s_raffleState != RaffleState.OPEN) revert Raffle__NotOpen();
        s_players.push(payable(msg.sender));
        emit Raffle__PlayerEntered(msg.sender);
    }

    /**
     * @notice Selects a winner from the players list
     * @dev This function gets a random numner to select a winner
     */
    function performUpkeep(bytes calldata /* performData */) external {
        // if ((block.timestamp - s_lastTimeStamp) < i_interval) {
        //     revert();
        // }
        (bool upkeepNeeded, ) = checkUpkeep("");
        if (!upkeepNeeded) revert();

        s_raffleState = RaffleState.CALCULATING_WINNER;

        uint256 requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: s_keyHash,
                subId: i_subscriptionId,
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
    ) internal virtual override {
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable recentWinner = s_players[indexOfWinner];
        s_recentWinner = recentWinner;
        s_raffleState = RaffleState.OPEN;
        s_players = new address payable[](0);
        s_lastTimeStamp = block.timestamp;

        (bool success, ) = recentWinner.call{value: address(this).balance}("");
        if (!success) {
            revert Raffle__TransferFail();
        }

        emit WinnerPicked(s_recentWinner);
    }

    /**
     * ////////////    GETTERS      //////////////////
     */
    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }

    function getRaffleState() public view returns (RaffleState) {
        return s_raffleState;
    }
}
