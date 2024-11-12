// Get finds from users
// Withdraw funds 
// Set a minimum funding value is USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract FundMe {
    function fund() public payable {
        // allow users to send money
        // have a minimum $fee
        require(msg.value > 1e18, "did'nt send enough ETH");
    }
    // function withdraw() public {}
}