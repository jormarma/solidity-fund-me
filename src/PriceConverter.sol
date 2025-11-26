// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {AggregatorV3Interface} from "@chainlink/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

/// @title PriceConverter
/// @author Patrick Collins
/// @notice A library to convert ETH to USD using Chainlink Price Feeds
library PriceConverter {
    /// @notice Gets the price of ETH in USD
    /// @param priceFeed The Chainlink Price Feed interface
    /// @return The price of ETH in USD
    function getPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        require(answer >= 0, "Price must be positive");

        // ETH/USD rate in 18 digits
        // casting to 'uint256' is safe because it has been checked to be positive
        // forge-lint: disable-next-line(unsafe-typecast)
        return uint256(answer) * 1e10;
    }

    /// @notice Converts an amount of ETH to USD
    /// @param ethAmount The amount of ETH to convert
    /// @param priceFeed The Chainlink Price Feed interface
    /// @return The amount of ETH in USD
    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
