// SPDX-License-Identifier: MIT

// 1. Deploy mocks when we are on a local anvil chain
// 2. Keep track of contract addressses across different chains
//Sepolia ETH/USD
//Mainnet ETH/USD

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/Mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    //if we are on a local anvil chain, we want to deploy mocks
    //otherwise we deploy from a live network
    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // price feed address
        NetworkConfig memory Sepoliaconfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return Sepoliaconfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed: address(mockPriceFeed)});
        return anvilConfig;
    }
}
