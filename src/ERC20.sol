// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract ERC20 {
    // Custom Errors
    error ERC20__NotOwner();
    error ERC20__InsufficientBalance();
    error ERC20__InsufficientAllowance();
    error ERC20__TransferToZeroAddress();
    error ERC20__ApproveToZeroAddress();
    error ERC20__TransferFromZeroAddress();
    error ERC20__MintToZeroAddress();
    error ERC20__MaxSupplyExceeded();

    // State Variables
    string private s_name;
    string private s_symbol;
    uint256 private s_totalSupply;
    address private immutable i_owner;
    uint8 private constant DECIMALS = 18;
    uint256 private constant MAX_SUPPLY = 1_000_000 * 10 ** 18;

    mapping(address => uint256) private s_balances;
    // Owner => Spender => allowance
    mapping(address => mapping(address => uint256)) private s_allowances;
}
