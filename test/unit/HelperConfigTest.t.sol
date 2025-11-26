// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract HelperConfigTest is Test {
    HelperConfig helperConfig;

    function setUp() public {
        helperConfig = new HelperConfig();
    }

    function testGetSepoliaEthConfig() public view {
        HelperConfig.NetworkConfig memory config = helperConfig.getSepoliaEthConfig();
        assertEq(config.priceFeed, helperConfig.SEPOLIA_PRICE_FEED());
        assertEq(config.feedVersion, helperConfig.SEPOLIA_FEED_VERSION());
    }

    function testGetEthereumMainnetConfig() public view {
        HelperConfig.NetworkConfig memory config = helperConfig.getEthereumMainnetConfig();
        assertEq(config.priceFeed, helperConfig.ETH_MAINNET_PRICE_FEED());
        assertEq(config.feedVersion, helperConfig.ETH_MAINNET_FEED_VERSION());
    }

    function testGetOrCreateAnvilEthConfig() public {
        // Since we are running on Anvil (default for tests), this should return the mock config
        HelperConfig.NetworkConfig memory config = helperConfig.getOrCreateAnvilEthConfig();
        assert(config.priceFeed != address(0));
        assertEq(config.feedVersion, 0);
    }

    function testSepoliaEthConfig() public {
        vm.chainId(helperConfig.SEPOLIA_CHAIN_ID());
        HelperConfig sepoliaHelperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory config = sepoliaHelperConfig.getActiveNetworkConfig();
        assertEq(config.priceFeed, helperConfig.SEPOLIA_PRICE_FEED());
        assertEq(config.feedVersion, helperConfig.SEPOLIA_FEED_VERSION());
    }

    function testMainnetEthConfig() public {
        vm.chainId(helperConfig.MAINNET_CHAIN_ID());
        HelperConfig mainnetHelperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory config = mainnetHelperConfig.getActiveNetworkConfig();
        assertEq(config.priceFeed, helperConfig.ETH_MAINNET_PRICE_FEED());
        assertEq(config.feedVersion, helperConfig.ETH_MAINNET_FEED_VERSION());
    }
}
