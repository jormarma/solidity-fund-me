// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {WithdrawFundMe} from "../../script/Interactions.s.sol";
import {FundMe} from "../../src/FundMe.sol";
import {Test} from "forge-std/Test.sol";

contract InteractionsTest is Test {
    FundMe public s_fundMe;
    DeployFundMe deployFundMe;
    uint256 public constant SEND_VALUE = 0.1 ether;
    uint256 public constant STARTING_USER_BALANCE = 10 ether;
    address alice = makeAddr("alice");

    function setUp() external {
        deployFundMe = new DeployFundMe();
        (s_fundMe,) = deployFundMe.run();
        vm.deal(alice, STARTING_USER_BALANCE);
    }

    function testUserCanFundAndOwnerWithdraw() public {
        uint256 preUserBalance = address(alice).balance;
        uint256 preOwnerBalance = address(s_fundMe.getOwner()).balance;
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();

        // Using vm.prank to simulate funding from the USER address
        vm.prank(alice);
        s_fundMe.fund{value: SEND_VALUE}();
        withdrawFundMe.withdrawFundMe(address(s_fundMe));

        uint256 afterUserBalance = address(alice).balance;
        uint256 afterOwnerBalance = address(s_fundMe.getOwner()).balance;
        assert(address(s_fundMe).balance == 0);
        assertEq(afterUserBalance + SEND_VALUE, preUserBalance);
        assertEq(preOwnerBalance + SEND_VALUE, afterOwnerBalance);
    }
}
