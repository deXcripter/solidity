// SPDX-License-Identifier: MIT

import {PriceConverter} from "./PriceConverter.sol";

pragma solidity ^0.8.18;

contract FundMe {
    // 973321 gas on v1
    // 950666 gas after using constant for MINUSD
    // 923997 gas after using immutable for iOwner
    // 814580 gas after using custom errors

    uint public constant MINIMUM_USD = 5 * 1e18;
    error Unauthorized();
    error NotEnoughEth();

    using PriceConverter for uint256;
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    address[] public funders;
    mapping(address funder => uint256 amountFunded)
        public addressToAmountFunded;

    function fund() public payable {
        // Allow uss to send $
        // Have a minimum $ sent $5
        // msg.value.getConversionRate(); // msg.value is of type uint256d
        // require(msg.value.getConversionRate() >= MINIMUM_USD, "You dont have enough ETH");
        if (msg.value.getConversionRate() < MINIMUM_USD) {
            revert NotEnoughEth();
        }
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (uint i = 0; i < funders.length; i++) {
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
            funders[i] = address(0);
        }

        funders = new address[](0);

        /*
         * sending ether to the caller of this function can be done in 3 ways 4
         * transfer - (2300 gas, throws error)
         * send - (2300 gas, returns bool)
         * call - (forward all gas or set gas, returns bool)
         */

        // // msg.sender is of type address while payable(msg.sender) is of type payable address
        // payable(msg.sender).transfer(address(this).balance);

        // // unless you require the success, it does not revert unlike transfer.
        // bool success = payable(msg.sender).send(address(this).balance);
        // require(success, "Could not send funds");

        // can be used to call any function in all of ethereum without even needing an ABI

        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        if (!callSuccess) {
            revert NotEnoughEth();
        }
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert Unauthorized();
        }
        _;
    }
}
