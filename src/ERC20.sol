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
    function mint(address _to, uint256 _amount) public onlyOwner {
        if (_to == address(0)) {
            revert ERC20__MintToZeroAddress();
        }
        if (s_totalSupply + _amount > MAX_SUPPLY) {
            revert ERC20__MaxSupplyExceeded();
        }

        s_totalSupply += _amount;
        s_balances[_to] += _amount;

        emit Transfer(address(0), _to, _amount);
    }

    function burn(uint256 _amount) public {
        if (s_balances[msg.sender] < _amount) {
            revert ERC20__InsufficientBalance();
        }

        s_balances[msg.sender] -= _amount;
        s_totalSupply -= _amount;
        emit Transfer(msg.sender, address(0), _amount);
    }

    function transfer(address _to, uint256 _amount) public returns (bool) {
        if (_to == address(0)) {
            revert ERC20__TransferToZeroAddress();
        }
        if (s_balances[msg.sender] < _amount) {
            revert ERC20__InsufficientBalance();
        }

        s_balances[msg.sender] -= _amount;
        s_balances[_to] += _amount;

        emit Transfer(msg.sender, _to, _amount);
        return true;
    }

    function approve(address _spender, uint256 _amount) public returns (bool) {
        if (_spender == address(0)) {
            revert ERC20__ApproveToZeroAddress();
        }

        s_allowances[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
        if (_from == address(0)) {
            revert ERC20__TransferFromZeroAddress();
        }
        if (_to == address(0)) {
            revert ERC20__TransferToZeroAddress();
        }
        if (s_balances[_from] < _amount) {
            revert ERC20__InsufficientBalance();
        }

        uint256 currentAllowance = s_allowances[_from][msg.sender];
        if (currentAllowance < _amount) {
            revert ERC20__InsufficientAllowance();
        }

        s_balances[_from] -= _amount;
        s_balances[_to] += _amount;
        s_allowances[_from][msg.sender] = currentAllowance - _amount;

        emit Transfer(_from, _to, _amount);
        return true;
    }

    function increaseAllowance(address _spender, uint256 _amount) public returns (bool) {
        if (_spender == address(0)) {
            revert ERC20__ApproveToZeroAddress();
        }

        s_allowances[msg.sender][_spender] += _amount;
        emit Approval(msg.sender, _spender, s_allowances[msg.sender][_spender]);
        return true;
    }

    function decreaseAllowance(address _spender, uint256 _amount) public returns (bool) {
        if (_spender == address(0)) {
            revert ERC20__ApproveToZeroAddress();
        }

        uint256 currentAllowance = s_allowances[msg.sender][_spender];
        if (currentAllowance < _amount) {
            revert ERC20__InsufficientAllowance();
        }

        s_allowances[msg.sender][_spender] = currentAllowance - _amount;
        emit Approval(msg.sender, _spender, s_allowances[msg.sender][_spender]);
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

    function maxSupply() public pure returns (uint256) {
        return MAX_SUPPLY;
    }

    function balanceOf(address _account) public view returns (uint256) {
        return s_balances[_account];
    }

    function allowance(address _owner, address _spender) public view returns (uint256) {
        return s_allowances[_owner][_spender];
    }
}
