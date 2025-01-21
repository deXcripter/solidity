// SPDX-License-Identifier: MIT

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
pragma solidity ^0.8.18;

library PriceConverter {
    // gets the price of ethereum in terms of USD
    function getPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        // address -- 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // abi
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }

    // convert the price
    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
