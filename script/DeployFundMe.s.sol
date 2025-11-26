// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

/// @title DeployFundMe
/// @author Patrick Collins
/// @notice Script to deploy the FundMe contract
contract DeployFundMe is Script {
    /// @notice Deploys the FundMe contract
    /// @return fundMe The deployed FundMe contract
    /// @return helperConfig The HelperConfig contract used for configuration
    function run() external returns (FundMe fundMe, HelperConfig helperConfig) {
        helperConfig = new HelperConfig();
        address priceFeedAddress = helperConfig
            .getActiveNetworkConfig()
            .priceFeed;

        vm.startBroadcast();
        fundMe = new FundMe(priceFeedAddress);
        vm.stopBroadcast();
    }
}
