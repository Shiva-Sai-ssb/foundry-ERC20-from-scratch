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

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(string memory _name, string memory _symbol) {
        s_name = _name;
        s_symbol = _symbol;
        i_owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert ERC20__NotOwner();
        }
        _;
    }
}
