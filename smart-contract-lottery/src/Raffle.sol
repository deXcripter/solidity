// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Raffle {
    uint256 private immutable i_EntranceFee;

    constructor(uint256 entranceFee) {
        i_EntranceFee = entranceFee;
    }

    function enterRaffle() public payable {}

    function selectWinner() public {}

    function getEntranceFee() public view returns (uint256) {
        return i_EntranceFee;
    }
}
