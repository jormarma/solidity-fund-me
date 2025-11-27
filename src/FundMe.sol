// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {AggregatorV3Interface} from "@chainlink/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

/// @title FundMe
/// @author Patrick Collins
/// @notice This contract is for creating a sample funding contract
/// @dev Implements PriceConverter library
contract FundMe {
    using PriceConverter for uint256;

    mapping(address => uint256) public s_addressToAmountFunded;
    address[] public s_funders;
    AggregatorV3Interface private s_priceFeed;

    address private immutable i_owner;
    uint256 public constant MINIMUM_USD = 5e18;

    /// @notice Initializes the contract with the price feed address
    /// @param priceFeedAddress The address of the Chainlink Price Feed
    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    /// @notice Funds the contract based on the ETH/USD price
    /// @dev The amount sent must be greater than the minimum USD amount
    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "You need to spend more ETH!");
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    /// @notice Gets the version of the price feed
    /// @return The version of the price feed
    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    function _onlyOwner() internal view {
        if (msg.sender != i_owner) revert NotOwner();
    }

    /// @notice Withdraws the funds from the contract
    /// @dev Only the owner can call this function
    function withdraw() public onlyOwner {
        uint256 fundersLength = s_funders.length;

        for (uint256 funderIndex = 0; funderIndex < fundersLength; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }

        s_funders = new address[](0);

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    /// @notice Gets the amount funded by a specific address
    /// @param fundingAddress The address to check
    /// @return The amount funded
    function getAddressToAmountFunded(address fundingAddress) public view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    /// @notice Gets the funder at a specific index
    /// @param index The index of the funder
    /// @return The address of the funder
    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    /// @notice Gets the owner of the contract
    /// @return The address of the owner
    function getOwner() public view returns (address) {
        return i_owner;
    }

    /// @notice Gets the price feed interface
    /// @return The price feed interface
    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
}
