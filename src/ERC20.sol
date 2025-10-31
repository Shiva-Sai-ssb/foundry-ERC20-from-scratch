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
    mapping(address => mapping(address => uint256)) private s_allowances;

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /// @notice Sets the name and symbol of the token, and sets deployer as owner
    /// @param _name Token name
    /// @param _symbol Token symbol
    constructor(string memory _name, string memory _symbol) {
        s_name = _name;
        s_symbol = _symbol;
        i_owner = msg.sender;
    }

    /// @notice Throws an error if the caller is not the owner
    /// @dev This modifier is used to restrict access to certain functions(like minting)
    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert ERC20__NotOwner();
        }
        _;
    }

    /// @notice Mints new tokens to a specified address
    /// @param _to The address to mint tokens to
    /// @param _amount The amount of tokens to mint
    /// @dev Only the owner can mint tokens
    /// @dev Reverts if trying to mint to the zero address or if the total supply exceeds MAX_SUPPLY
    /// @dev Emits a Transfer event with the `from` address set to zero
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

    /// @notice Burns tokens from the caller's balance
    /// @param _amount The amount of tokens to burn
    /// @dev Reverts if the caller's balance is insufficient
    /// @dev Emits a Transfer event with the `to` address set to zero
    function burn(uint256 _amount) public {
        if (s_balances[msg.sender] < _amount) {
            revert ERC20__InsufficientBalance();
        }

        s_balances[msg.sender] -= _amount;
        s_totalSupply -= _amount;
        emit Transfer(msg.sender, address(0), _amount);
    }

    /// @notice Transfers tokens from the caller to a specified address
    /// @param _to The address to transfer tokens to
    /// @param _amount The amount of tokens to transfer
    /// @dev Reverts if the `_to` address is zero or if the caller's balance is insufficient
    /// @dev Emits a Transfer event, returning true on success
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

    /// @notice Approves a spender to spend a specified amount of tokens on behalf of the caller
    /// @param _spender The address to approve
    /// @param _amount The amount of tokens to approve
    /// @dev Reverts if the `_spender` address is zero
    /// @dev Emits an Approval event, returning true on success
    function approve(address _spender, uint256 _amount) public returns (bool) {
        if (_spender == address(0)) {
            revert ERC20__ApproveToZeroAddress();
        }

        s_allowances[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    /// @notice Transfers tokens from one address to another on behalf of the owner
    /// @param _from The address to transfer tokens from
    /// @param _to The address to transfer tokens to
    /// @param _amount The amount of tokens to transfer
    /// @dev Reverts if the `_from` or `_to` address is zero, if the `_from` address has insufficient balance,
    /// or if the caller does not have enough allowance
    /// @dev Emits a Transfer event, returning true on success
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

    /// @notice Increases the allowance of a spender
    /// @param _spender The address to increase the allowance for
    /// @param _amount The amount to increase the allowance by
    /// @dev Reverts if the `_spender` address is zero
    /// @dev Emits an Approval event, returning true on success
    function increaseAllowance(address _spender, uint256 _amount) public returns (bool) {
        if (_spender == address(0)) {
            revert ERC20__ApproveToZeroAddress();
        }

        s_allowances[msg.sender][_spender] += _amount;
        emit Approval(msg.sender, _spender, s_allowances[msg.sender][_spender]);
        return true;
    }

    /// @notice Decreases the allowance of a spender
    /// @param _spender The address to decrease the allowance for
    /// @param _amount The amount to decrease the allowance by
    /// @dev Reverts if the `_spender` address is zero or if the current allowance is less than the amount to decrease
    /// @dev Emits an Approval event, returning true on success
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

    /// @notice Returns the name of the token
    function name() public view returns (string memory) {
        return s_name;
    }

    /// @notice Returns the symbol of the token
    function symbol() public view returns (string memory) {
        return s_symbol;
    }

    /// @notice Returns the number of decimals the token uses
    function decimals() public pure returns (uint8) {
        return DECIMALS;
    }

    /// @notice Returns the address of the contract owner
    function owner() public view returns (address) {
        return i_owner;
    }

    /// @notice Returns the total supply of tokens
    function totalSupply() public view returns (uint256) {
        return s_totalSupply;
    }

    /// @notice Returns the maximum supply of tokens
    function maxSupply() public pure returns (uint256) {
        return MAX_SUPPLY;
    }

    /// @notice Returns the balance of a specific account
    /// @param _account The address to check the balance of
    /// @return The balance of the specified account
    function balanceOf(address _account) public view returns (uint256) {
        return s_balances[_account];
    }

    /// @notice Returns the allowance of a spender for a specific owner
    /// @param _owner The address of the owner
    /// @param _spender The address of the spender
    /// @return The amount of tokens the spender is allowed to spend on behalf of the owner
    /// @dev Returns zero if the owner or spender has no allowance set
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return s_allowances[_owner][_spender];
    }
}
