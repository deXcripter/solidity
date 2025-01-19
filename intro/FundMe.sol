// SPDX-License-Identifier: MIT

import {PriceConverter} from "./PriceConverter.sol";

pragma solidity ^0.8.18;

contract FundMe {
    using PriceConverter for uint256;

    uint public minimumUsd = 5 * 1e18;
    address[] public funders;
    mapping(address funder => uint256 amountFunded)
        public addressToAmountFunded;

    function fund() public payable {
        // Allow uss to send $
        // Have a minimum $ sent $5
        // msg.value.getConversionRate(); // msg.value is of type uint256d
        require(
            msg.value.getConversionRate() >= minimumUsd,
            "You dont have enough ETH"
        );
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }
}
