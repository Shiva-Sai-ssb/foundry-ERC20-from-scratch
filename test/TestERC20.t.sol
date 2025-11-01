// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {DeployERC20} from "script/DeployERC20.s.sol";
import {ERC20} from "src/ERC20.sol";
import {Test, console} from "forge-std/Test.sol";

contract TestERC20 is Test {
    DeployERC20 deployer;
    ERC20 erc20;
    address OWNER;
    address USER1 = makeAddr("user1");
    address USER2 = makeAddr("user2");
    address USER3 = makeAddr("user3");
    uint256 public constant STARTING_VALUE = 5 ether;

    function setUp() external {
        deployer = new DeployERC20();
        erc20 = deployer.run();
        OWNER = erc20.owner();
        vm.deal(USER1, STARTING_VALUE);
        vm.deal(USER2, STARTING_VALUE);
        vm.deal(USER3, STARTING_VALUE);
    }

    /*//////////////////////////////////////////////////////////////
                           STATE VARIABLES TESTS
    //////////////////////////////////////////////////////////////*/

    function testTokenName() external view {
        assertEq(erc20.name(), "Shiva Sai");
    }

    function testTokenSymbol() external view {
        assertEq(erc20.symbol(), "SSB");
    }

    function testDecimals() external view {
        assertEq(erc20.decimals(), 18);
    }

    function testTotalSupplyShowsCorrectly() external view {
        assertEq(erc20.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testOwnerIsSetCorrectly() external view {
        assertEq(erc20.owner(), OWNER);
    }

    function testMaxSupplyOfTokensSetsCorrectly() external view {
        assertEq(erc20.maxSupply(), 1_000_000 * 10 ** 18);
    }

    function testBalanceOfShowsCorrectly() external view {
        assertEq(erc20.balanceOf(OWNER), deployer.INITIAL_SUPPLY());
        assertEq(erc20.balanceOf(USER1), 0);
        assertEq(erc20.balanceOf(USER2), 0);
        assertEq(erc20.balanceOf(USER3), 0);
    }

    function testAllowanceShowsCorrectly() external view {
        assertEq(erc20.allowance(OWNER, USER1), 0);
        assertEq(erc20.allowance(USER1, OWNER), 0);
        assertEq(erc20.allowance(USER2, USER3), 0);
    }
}
