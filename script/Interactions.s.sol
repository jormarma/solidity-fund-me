// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;
import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

/// @title FundFundMe
/// @author Patrick Collins
/// @notice Script to fund the FundMe contract
contract FundFundMe is Script {
    uint256 public constant SEND_VALUE = 0.1 ether;

    /// @notice Funds the FundMe contract
    /// @param mostRecentlyDeployed The address of the deployed FundMe contract
    function fundFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded FundMe with %s", SEND_VALUE);
    }

    /// @notice Main entry point for the script
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        fundFundMe(mostRecentlyDeployed);
    }
}

/// @title WithdrawFundMe
/// @author Patrick Collins
/// @notice Script to withdraw funds from the FundMe contract
contract WithdrawFundMe is Script {
    /// @notice Withdraws funds from the FundMe contract
    /// @param mostRecentlyDeployed The address of the deployed FundMe contract
    function withdrawFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
        console.log("Withdraw FundMe balance!");
    }

    /// @notice Main entry point for the script
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        withdrawFundMe(mostRecentlyDeployed);
    }
}
