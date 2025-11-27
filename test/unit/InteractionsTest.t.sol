// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;
    HelperConfig helperConfig;

    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant FUND_AMOUNT = 1 ether;
    uint256 constant MOCK_CHAIN_ID_1 = 12345;
    uint256 constant MOCK_CHAIN_ID_2 = 67890;
    uint256 constant MOCK_TIMESTAMP = 1234567890;
    address alice = makeAddr("alice");

    function setUp() external {
        DeployFundMe deployer = new DeployFundMe();
        (fundMe, helperConfig) = deployer.run();
        vm.deal(alice, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        vm.deal(DEFAULT_SENDER, FUND_AMOUNT);
        fundFundMe.fundFundMe(address(fundMe));

        address funder = fundMe.getFunder(0);
        assertEq(funder, DEFAULT_SENDER);
    }

    function testUserCanWithdrawInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        vm.deal(address(this), FUND_AMOUNT);
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assertEq(address(fundMe).balance, 0);
    }

    function testFundFundMeRun() public {
        FundFundMe fundFundMe = new FundFundMe();
        vm.deal(DEFAULT_SENDER, FUND_AMOUNT);

        // Mock the deployment artifact
        _mockDeploymentArtifact(address(fundMe));

        fundFundMe.run();

        address funder = fundMe.getFunder(0);
        assertEq(funder, DEFAULT_SENDER);
    }

    function testWithdrawFundMeRun() public {
        FundFundMe fundFundMe = new FundFundMe();
        vm.deal(DEFAULT_SENDER, FUND_AMOUNT);
        fundFundMe.fundFundMe(address(fundMe));

        // Mock the deployment artifact
        _mockDeploymentArtifact(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.run();

        assertEq(address(fundMe).balance, 0);
    }

    function _mockDeploymentArtifact(address deployedAddress) internal {
        string memory json = string.concat(
            '{"timestamp": ',
            vm.toString(MOCK_TIMESTAMP),
            ', "transactions": [{"contractName": "FundMe", "contractAddress": "',
            vm.toString(deployedAddress),
            '"}]}'
        );

        // Ensure directory exists
        string memory chainIdStr = vm.toString(block.chainid);
        string memory root = vm.projectRoot();
        string memory dirPath = string.concat(root, "/broadcast/DeployFundMe.s.sol/", chainIdStr);

        vm.createDir(dirPath, true);

        string memory path = string.concat(dirPath, "/run-latest.json");
        // forge-lint: disable-next-line(unsafe-cheatcode)
        vm.writeFile(path, json);
    }
}
