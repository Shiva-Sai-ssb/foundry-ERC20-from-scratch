// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {DeployERC20} from "script/DeployERC20.s.sol";
import {ERC20} from "src/ERC20.sol";
import {Test, console} from "forge-std/Test.sol";

contract TestERC20 is Test {
    ERC20 erc20;
    address USER1 = makeAddr("user1");
    address USER2 = makeAddr("user2");
    address USER3 = makeAddr("user3");
    uint256 public constant STARTING_VALUE = 5 ether;

    function setUp() external {
        DeployERC20 deployer = new DeployERC20();
        erc20 = deployer.run();
        vm.deal(USER1, STARTING_VALUE);
        vm.deal(USER2, STARTING_VALUE);
        vm.deal(USER3, STARTING_VALUE);
    }
}
