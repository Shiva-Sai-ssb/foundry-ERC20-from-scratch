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

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

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

    /*//////////////////////////////////////////////////////////////
                           MINT FUNCTION TESTS
    //////////////////////////////////////////////////////////////*/

    function testOnlyOwnerCanCallMintFunction() external {
        vm.prank(USER1);
        vm.expectRevert(ERC20.ERC20__NotOwner.selector);
        erc20.mint(USER1, 100);
    }

    function testCannotMintToZeroAddress() external {
        vm.prank(OWNER);
        vm.expectRevert(ERC20.ERC20__MintToZeroAddress.selector);
        erc20.mint(address(0), 100);
    }

    function testTotalSupplyDoesNotExceedMaxSupply() external {
        uint256 maxSupply = erc20.maxSupply();

        vm.prank(OWNER);
        vm.expectRevert(ERC20.ERC20__MaxSupplyExceeded.selector);
        erc20.mint(USER1, maxSupply + 1);
    }

    function testBalanceOfRecipientIncreasesAfterMinting() external {
        uint256 balanceBefore = erc20.balanceOf(USER1);
        vm.prank(OWNER);
        erc20.mint(USER1, 100);
        assertEq(erc20.balanceOf(USER1), balanceBefore + 100);
    }

    function testTotalSupplyIncreasesAfterMinting() external {
        uint256 supplyBefore = erc20.totalSupply();
        vm.prank(OWNER);
        erc20.mint(USER1, 1000);
        assertEq(erc20.totalSupply(), supplyBefore + 1000);
    }

    function testMintingFunctionEmitsTransferEvent() external {
        vm.prank(OWNER);
        vm.expectEmit(true, true, false, true, address(erc20));
        emit Transfer(address(0), USER1, 100);
        erc20.mint(USER1, 100);
    }

    /*//////////////////////////////////////////////////////////////
                           BURN FUNCTION TESTS
    //////////////////////////////////////////////////////////////*/

    function testAnyoneCanBurnTheirOwnTokens() external {
        vm.prank(OWNER);
        erc20.mint(USER1, 200);

        vm.prank(USER1);
        erc20.burn(100);
        assertEq(erc20.balanceOf(USER1), 100);
    }

    function testBurnFunctionChecksIfCallerHasEnoughBalance() external {
        vm.prank(USER1);
        vm.expectRevert(ERC20.ERC20__InsufficientBalance.selector);
        erc20.burn(100);
    }

    function testBalanceAndTotalSupplyUpdateCorrectlyAfterBurning() external {
        vm.prank(OWNER);
        erc20.mint(USER1, 200);

        uint256 supplyBefore = erc20.totalSupply();
        vm.prank(USER1);
        erc20.burn(100);

        assertEq(erc20.balanceOf(USER1), 100);
        assertEq(erc20.totalSupply(), supplyBefore - 100);
    }

    function testBurnFunctionEmitsTransferEvent() external {
        vm.prank(OWNER);
        erc20.mint(USER1, 100);

        vm.prank(USER1);
        vm.expectEmit(true, true, false, true, address(erc20));
        emit Transfer(USER1, address(0), 50);
        erc20.burn(50);
    }
}
