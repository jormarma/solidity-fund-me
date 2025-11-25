// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {FundMe} from "../../src/FundMe.sol";
import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract FundMeTest is Test {
    FundMe s_fundMe;
    HelperConfig s_helperConfig;

    address alice = makeAddr("alice");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deployer = new DeployFundMe();
        (FundMe fundMe, HelperConfig helperConfig) = deployer.run();
        s_fundMe = fundMe;
        s_helperConfig = helperConfig;
        vm.deal(alice, STARTING_BALANCE);
    }

    modifier funded() {
        vm.prank(alice);
        s_fundMe.fund{value: SEND_VALUE}();
        assert(address(s_fundMe).balance > 0);
        _;
    }

    function testMinimumDollarIsFive() public view {
        assertEq(s_fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(s_fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        if (block.chainid == s_helperConfig.SEPOLIA_CHAIN_ID()) {
            uint256 version = s_fundMe.getVersion();
            assertEq(version, 4);
        } else if (block.chainid == s_helperConfig.MAINNET_CHAIN_ID()) {
            uint256 version = s_fundMe.getVersion();
            assertEq(version, 6);
        } else {
            // ANVIL
            uint256 version = s_fundMe.getVersion();
            assertEq(version, 0);
        }
    }

    function testFundFailsIfNotEnoughETH() public {
        vm.expectRevert();
        s_fundMe.fund();
    }

    function testFundUpdatesFundDataStructure() public funded {
        uint256 amountFunded = s_fundMe.getAddressToAmountFunded(address(alice));
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public funded {
        address funder = s_fundMe.getFunder(0);
        assertEq(funder, alice);
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(alice);
        vm.expectRevert();
        s_fundMe.withdraw();
    }

    function testWithdrawFromASingleFunder() public funded {
        uint256 startingFundMeBalance = address(s_fundMe).balance;
        uint256 startingOwnerBalance = s_fundMe.getOwner().balance;

        vm.txGasPrice(GAS_PRICE);
        uint256 gasStart = gasleft();

        vm.prank(s_fundMe.getOwner());
        s_fundMe.withdraw();

        uint256 gasEnd = gasleft();
        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        console.log("Withdraw consumed: %d gas", gasUsed);

        uint256 endingFundMeBalance = address(s_fundMe).balance;
        uint256 endingOwnerBalance = s_fundMe.getOwner().balance;
        assertEq(endingFundMeBalance, 0);

        // In Foundry tests, vm.prank does not deduct gas from the caller's balance.
        // So we assert that the balance is the sum of the starting balances.
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);

        // To verify that gas would be deducted in a real transaction, we can:
        // 1. Assert that gas was actually used
        assert(gasUsed > 0);

        // 2. Verify the math for what the balance WOULD be
        uint256 expectedRealWorldBalance = (startingFundMeBalance + startingOwnerBalance) - gasUsed;
        console.log("Real world ending balance would be: %d", expectedRealWorldBalance);
    }

    function testWithdrawFromMultipleFunders() public funded {
        uint256 numberOfFounders = 10;
        uint256 startingFunderIndex = 1;

        for (uint256 i = startingFunderIndex; i < numberOfFounders; i++) {
            address funder = makeAddr(string.concat("funder", vm.toString(i)));
            hoax(funder, SEND_VALUE);
            s_fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingFundMeBalance = address(s_fundMe).balance;
        uint256 startingOwnerBalance = s_fundMe.getOwner().balance;

        vm.prank(s_fundMe.getOwner());
        s_fundMe.withdraw();

        uint256 endingFundMeBalance = address(s_fundMe).balance;
        uint256 endingOwnerBalance = s_fundMe.getOwner().balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
        assertEq(numberOfFounders * SEND_VALUE, s_fundMe.getOwner().balance - startingOwnerBalance);
    }

    function testPrintStorageData() public view {
        for (uint256 i = 0; i < 3; i++) {
            bytes32 value = vm.load(address(s_fundMe), bytes32(i));
            console.log("Value at location", i, ":");
            console.logBytes32(value);
        }

        console.log("PriceFeed address:", address(s_fundMe.getPriceFeed()));
    }
}
