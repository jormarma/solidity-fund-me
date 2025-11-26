// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script, console} from "forge-std/Script.sol";
import {MockV3Aggregator} from "@chainlink/src/v0.8/tests/MockV3Aggregator.sol";
import {AggregatorV3Interface} from "@chainlink/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

/// @title HelperConfig
/// @author Patrick Collins
/// @notice Script to manage configuration for different networks
contract HelperConfig is Script {
    uint256 public constant SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant ZKSYNC_SEPOLIA_CHAIN_ID = 300;
    uint256 public constant MAINNET_CHAIN_ID = 1;
    uint8 public constant MOCK_PRICE_FEED_DECIMALS = 8;
    int256 public constant MOCK_PRICE_FEED_INITIAL_ANSWER = 2000e8;

    address public constant ETH_MAINNET_PRICE_FEED =
        0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;
    uint256 public constant ETH_MAINNET_FEED_VERSION = 6;
    address public constant SEPOLIA_PRICE_FEED =
        0x694AA1769357215DE4FAC081bf1f309aDC325306;
    uint256 public constant SEPOLIA_FEED_VERSION = 4;
    address public constant ZKSYNC_SEPOLIA_PRICE_FEED =
        0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF;
    uint256 public constant ZKSYNC_SEPOLIA_FEED_VERSION = 4;

    NetworkConfig public activeNetworkConfig;
    AggregatorV3Interface mockPriceFeed;

    /// @notice Configuration for a network
    struct NetworkConfig {
        address priceFeed;
        uint256 feedVersion;
    }

    /// @notice Initializes the configuration based on the chain ID
    constructor() {
        if (block.chainid == SEPOLIA_CHAIN_ID) {
            console.log("SEPOLIA");
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == ZKSYNC_SEPOLIA_CHAIN_ID) {
            console.log("ZKSYNC SEPOLIA");
            activeNetworkConfig = getZkSyncSepoliaEthConfig();
        } else if (block.chainid == MAINNET_CHAIN_ID) {
            console.log("MAINNET");
            activeNetworkConfig = getEthereumMainnetConfig();
        } else {
            console.log("ANVIL");
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    /// @notice Gets the active network configuration
    /// @return The active network configuration
    function getActiveNetworkConfig()
        public
        view
        returns (NetworkConfig memory)
    {
        return activeNetworkConfig;
    }

    /// @notice Gets the configuration for Ethereum Mainnet
    /// @return The configuration for Ethereum Mainnet
    function getEthereumMainnetConfig()
        public
        pure
        returns (NetworkConfig memory)
    {
        NetworkConfig memory mainnetConfig = NetworkConfig({
            priceFeed: ETH_MAINNET_PRICE_FEED,
            feedVersion: ETH_MAINNET_FEED_VERSION
        });
        return mainnetConfig;
    }

    /// @notice Gets the configuration for Sepolia Testnet
    /// @return The configuration for Sepolia Testnet
    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                priceFeed: SEPOLIA_PRICE_FEED,
                feedVersion: SEPOLIA_FEED_VERSION
            });
    }

    /// @notice Gets the configuration for ZkSync Sepolia Testnet
    /// @return The configuration for ZkSync Sepolia Testnet
    function getZkSyncSepoliaEthConfig()
        public
        pure
        returns (NetworkConfig memory)
    {
        return
            NetworkConfig({
                priceFeed: ZKSYNC_SEPOLIA_PRICE_FEED,
                feedVersion: ZKSYNC_SEPOLIA_FEED_VERSION
            });
    }

    /// @notice Gets or creates the configuration for Anvil (local)
    /// @return The configuration for Anvil
    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        mockPriceFeed = new MockV3Aggregator(
            MOCK_PRICE_FEED_DECIMALS,
            MOCK_PRICE_FEED_INITIAL_ANSWER
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed),
            feedVersion: mockPriceFeed.version()
        });

        return anvilConfig;
    }
}
