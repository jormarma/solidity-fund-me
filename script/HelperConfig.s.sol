// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script, console} from "forge-std/Script.sol";
import {MockV3Aggregator} from "@chainlink/src/v0.8/tests/MockV3Aggregator.sol";
import {AggregatorV3Interface} from "@chainlink/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract HelperConfig is Script {
    uint256 public constant SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant MAINNET_CHAIN_ID = 1;
    uint8 private constant MOCK_PRICE_FEED_DECIMALS = 8;
    int256 private constant MOCK_PRICE_FEED_INITIAL_ANSWER = 2000e8;

    NetworkConfig public activeNetworkConfig;
    AggregatorV3Interface mockPriceFeed;

    struct NetworkConfig {
        address priceFeed;
        uint256 feedVersion;
    }

    constructor() {
        if (block.chainid == SEPOLIA_CHAIN_ID) {
            console.log("SEPOLIA");
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == MAINNET_CHAIN_ID) {
            console.log("MAINNET");
            activeNetworkConfig = getEthereumMainnetConfig();
        } else {
            console.log("ANVIL");
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getActiveNetworkConfig() public view returns (NetworkConfig memory) {
        return activeNetworkConfig;
    }

    function getEthereumMainnetConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainnetConfig =
            NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419, feedVersion: 6});
        return mainnetConfig;
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306, feedVersion: 4});
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        mockPriceFeed = new MockV3Aggregator(MOCK_PRICE_FEED_DECIMALS, MOCK_PRICE_FEED_INITIAL_ANSWER);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig =
            NetworkConfig({priceFeed: address(mockPriceFeed), feedVersion: mockPriceFeed.version()});

        return anvilConfig;
    }
}
