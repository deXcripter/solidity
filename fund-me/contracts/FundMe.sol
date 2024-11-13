// Get finds from users
// Withdraw funds
// Set a minimum funding value is USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract FundMe {
    uint256 public minimumUSD = 5;

    function fund() public payable {
        // allow users to send money
        // have a minimum $fee
        require(msg.value > 1e18, "did'nt send enough ETH");
    }

    // function withdraw() public {}

    function getPrice() public {
        // address - 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI -
    }

    function getConversionRate() public {}
}
