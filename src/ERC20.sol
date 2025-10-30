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

    // Public Functions
    function mint(address to, uint256 amount) public onlyOwner {
        if (to == address(0)) {
            revert ERC20__MintToZeroAddress();
        }
        if (s_totalSupply + amount > MAX_SUPPLY) {
            revert ERC20__MaxSupplyExceeded();
        }

        s_totalSupply += amount;
        s_balances[to] += amount;

        emit Transfer(address(0), to, amount);
    }

    function burn(uint256 amount) public {
        if (s_balances[msg.sender] < amount) {
            revert ERC20__InsufficientBalance();
        }

        s_balances[msg.sender] -= amount;
        s_totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        if (s_balances[msg.sender] < amount) {
            revert ERC20__InsufficientBalance();
        }
        if (to == address(0)) {
            revert ERC20__TransferToZeroAddress();
        }

        s_balances[msg.sender] -= amount;
        s_balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        if (s_balances[msg.sender] < amount) {
            revert ERC20__InsufficientBalance();
        }
        if (spender == address(0)) {
            revert ERC20__ApproveToZeroAddress();
        }

        s_allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        if (from == address(0)) {
            revert ERC20__TransferFromZeroAddress();
        }
        if (s_allowances[from][msg.sender] < amount) {
            revert ERC20__InsufficientAllowance();
        }
        if (to == address(0)) {
            revert ERC20__TransferToZeroAddress();
        }

        s_balances[from] -= amount;
        s_balances[to] += amount;
        s_allowances[from][msg.sender] -= amount;

        emit Transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 amount) public returns (bool) {
        if (s_balances[msg.sender] < amount) {
            revert ERC20__InsufficientBalance();
        }
        if (spender == address(0)) {
            revert ERC20__ApproveToZeroAddress();
        }

        s_allowances[msg.sender][spender] += amount;
        emit Approval(msg.sender, spender, s_allowances[msg.sender][spender]);
        return true;
    }

    function decreaseAllowance(address spender, uint256 amount) public returns (bool) {
        if (spender == address(0)) {
            revert ERC20__ApproveToZeroAddress();
        }

        s_allowances[msg.sender][spender] -= amount;
        emit Approval(msg.sender, spender, s_allowances[msg.sender][spender]);
        return true;
    }

    // View Functions
    function name() public view returns (string memory) {
        return s_name;
    }

    function symbol() public view returns (string memory) {
        return s_symbol;
    }

    function decimals() public pure returns (uint8) {
        return DECIMALS;
    }

    function owner() public view returns (address) {
        return i_owner;
    }

    function totalSupply() public view returns (uint256) {
        return s_totalSupply;
    }
}
