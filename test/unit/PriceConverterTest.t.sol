// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {PriceConverter} from "../../src/PriceConverter.sol";
import {MockV3Aggregator} from "@chainlink/src/v0.8/tests/MockV3Aggregator.sol";
import {AggregatorV3Interface} from "@chainlink/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract PriceConverterHarness {
    using PriceConverter for uint256;

    function getPrice(AggregatorV3Interface priceFeed) public view returns (uint256) {
        return PriceConverter.getPrice(priceFeed);
    }
}

contract PriceConverterTest is Test {
    using PriceConverter for uint256;

    uint8 constant DECIMALS = 8;
    int256 constant NEGATIVE_PRICE = -1;

    function testGetPriceRevertsOnNegativePrice() public {
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, NEGATIVE_PRICE);
        PriceConverterHarness harness = new PriceConverterHarness();

        vm.expectRevert("Price must be positive");
        harness.getPrice(AggregatorV3Interface(address(mockPriceFeed)));
    }
}
