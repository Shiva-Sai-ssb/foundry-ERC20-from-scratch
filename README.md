> [!WARNING]
> This contract has not been audited. Use at your own risk. This was made for learning purposes and practicing test writing, do not use in production without proper security audits.

# ERC20 Token Implementation from Scratch

A custom ERC20 token implementation built from scratch using Foundry, without relying on external libraries like OpenZeppelin. This project demonstrates a complete implementation of the ERC20 standard with additional features like minting, burning, and supply caps.

## Features

- **Standard ERC20 Functions**
  - `transfer()` - Transfer tokens to another address
  - `approve()` - Approve a spender to transfer tokens
  - `transferFrom()` - Transfer tokens on behalf of another address
  - `allowance()` - Check allowance between owner and spender
  - `balanceOf()` - Get token balance of an address
  - `totalSupply()` - Get total supply of tokens

- **Additional Features**
  - `mint()` - Owner-only function to create new tokens
  - `burn()` - Anyone can burn their own tokens
  - `increaseAllowance()` - Increase spender allowance
  - `decreaseAllowance()` - Decrease spender allowance
  - Maximum supply cap (1,000,000 tokens)
  - Owner-controlled minting

- **Gas Optimizations**
  - Custom errors instead of require strings
  - Immutable variables for constants
  - Efficient state variable management

- **Custom Errors**
  - `ERC20__NotOwner()` - Thrown when non-owner attempts owner-only function
  - `ERC20__InsufficientBalance()` - Thrown when balance is insufficient
  - `ERC20__InsufficientAllowance()` - Thrown when allowance is insufficient
  - `ERC20__TransferToZeroAddress()` - Thrown when transferring to zero address
  - `ERC20__ApproveToZeroAddress()` - Thrown when approving zero address
  - `ERC20__TransferFromZeroAddress()` - Thrown when transferring from zero address
  - `ERC20__MintToZeroAddress()` - Thrown when minting to zero address
  - `ERC20__MaxSupplyExceeded()` - Thrown when attempting to exceed max supply

## Token Details

- **Name**: Shiva Sai
- **Symbol**: SSB
- **Decimals**: 18
- **Max Supply**: 1,000,000 tokens
- **Initial Supply**: 1,000 tokens (minted to owner on deployment)

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- Solidity ^0.8.28

## Installation

1. Clone the repository:
```bash
git clone git@github.com:Shiva-Sai-ssb/foundry-ERC20-from-scratch.git
cd foundry-ERC20-from-scratch
```

2. Install dependencies:
```bash
forge install
```

## Usage

### Build

Compile the contracts:
```bash
forge build
```

### Test

Run all tests:
```bash
forge test
```

Run tests with verbose output:
```bash
forge test -vvv
```

Generate coverage report:
```bash
forge coverage
```

View coverage report in a file:
```bash
forge coverage --report coverage.txt
```

### Format

Format the code:
```bash
forge fmt
```

### Gas Snapshots

Generate gas usage snapshots:
```bash
forge snapshot
```

### Deploy

Deploy to a local network (Anvil):
```bash
# Start Anvil in a separate terminal
anvil

# Deploy in another terminal
forge script script/DeployERC20.s.sol:DeployERC20 --rpc-url http://localhost:8545 --private-key <your-private-key> --broadcast
```

Deploy to a testnet:
```bash
forge script script/DeployERC20.s.sol:DeployERC20 --rpc-url <your_rpc_url> --private-key <your_private_key> --broadcast
```

## Project Structure

```
foundry-ERC20-from-scratch/
├── src/
│   └── ERC20.sol          # Main ERC20 token contract
├── script/
│   └── DeployERC20.s.sol  # Deployment script
├── test/
│   └── TestERC20.t.sol    # Comprehensive test suite
├── foundry.toml           # Foundry configuration
└── README.md              # This file
```

## Test Coverage

The project includes comprehensive tests with **100% code coverage**:

### Coverage Summary

| File                     | % Lines         | % Statements    | % Branches      | % Funcs         |
|--------------------------|-----------------|-----------------|-----------------|-----------------|
| `script/DeployERC20.s.sol` | 100.00% (15/15) | 100.00% (15/15) | 100.00% (1/1)   | 100.00% (1/1)   |
| `src/ERC20.sol`          | 100.00% (82/82) | 100.00% (66/66) | 100.00% (14/14) | 100.00% (17/17) |
| **Total**                | **100.00% (97/97)** | **100.00% (81/81)** | **100.00% (15/15)** | **100.00% (18/18)** |

### Test Results

✅ **45 tests passed**

### Test Coverage Includes:

- State variable validation
- Mint function (access control, supply limits, events)
- Burn function (balance checks, supply updates, events)
- Transfer function (balance checks, zero address validation, events)
- Approve function (zero address validation, events)
- TransferFrom function (allowance checks, balance updates, events)
- Increase/Decrease allowance functions

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.
