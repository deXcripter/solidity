// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title Raffle
 * @author deXcripter
 * @notice
 * @dev
 */
contract Raffle {
    error Raffle__NotEnoughEthSent();

    uint256 private immutable i_EntranceFee;
    uint256 private immutable i_interval; // duration of the lottery in seconds
    address payable[] private s_players;
    uint256 private s_lastTimeStamp;

    /* Events */
    event Raffle__PlayerEntered(address indexed player);

    constructor(uint256 entranceFee, uint256 interval) {
        i_EntranceFee = entranceFee;
        i_interval = interval;
        s_lastTim eStamp = block.timestamp;
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
    }ref

    /**
     * GETTERS
     */
    function getEntranceFee() public view returns (uint256) {
        return i_EntranceFee;
    }
}
