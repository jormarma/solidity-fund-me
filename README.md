# Fund Me

[![CI](https://github.com/jormarma/solidity-fund-me/actions/workflows/test.yml/badge.svg)](https://github.com/jormarma/solidity-fund-me/actions/workflows/test.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Solidity](https://img.shields.io/badge/Solidity-^0.8.30-363636.svg)
![Foundry](https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg)

**Fund Me** is a decentralized crowdfunding application built with Solidity and Foundry. It allows users to fund the contract with ETH, ensuring a minimum USD value using Chainlink Price Feeds. The contract owner can then withdraw the accumulated funds.

## Features

- **Fund with ETH:** Users can send ETH to the contract.
- **Minimum Funding Amount:** Enforces a minimum funding amount in USD (e.g., $5 USD).
- **Chainlink Price Feeds:** Uses Chainlink Oracles to convert ETH to USD for accurate value assessment.
- **Owner Withdrawal:** Only the contract owner can withdraw the funds.
- **Optimized:** Uses `immutable` and `constant` variables for gas efficiency.

## Getting Started

### Prerequisites

- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Foundry](https://getfoundry.sh/)

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/your-username/fund-me.git
   cd fund-me
   ```

2. **Install dependencies:**

   ```bash
   make install
   # Or manually:
   forge install
   ```

## Usage

### Build

Compile the contracts:

```bash
make build
# Or:
forge build
```

### Test

Run the test suite (unit and integration tests):

```bash
make test
# Or:
forge test
```

To run tests with a specific fork or other options, you can use standard `forge test` flags.

### Local Development (Anvil)

Start a local Anvil chain:

```bash
make anvil
```

Deploy to the local chain:

```bash
make deploy
```

### ZkSync

**Prerequisites:**

- [foundry-zksync](https://github.com/matter-labs/foundry-zksync)

To install/update `foundry-zksync`:

```bash
make zkfoundry
```

**Build for ZkSync:**

```bash
make zkbuild
```

**Local ZkSync Chain (anvil-zksync):**

Start the node:

```bash
make zkanvil
```

Deploy to local ZkSync chain:

```bash
make zkdeploy
```

Stop the node:

```bash
make stop-zkanvil
```

## Scripts

The project includes several scripts in the `script` directory:

- `DeployFundMe.s.sol`: Deploys the `FundMe` contract.
- `HelperConfig.s.sol`: Manages configuration for different networks (e.g., Sepolia, Mainnet, Anvil).
- `Interactions.s.sol`: Contains scripts for interacting with the contract (funding and withdrawing).

## Makefile Commands

This project uses a `Makefile` to simplify common tasks:

- `make all`: Clean, install, format, lint, and run tests.
- `make clean`: Clean artifacts, cache, and dependencies.
- `make install`: Install Foundry dependencies.
- `make update`: Update Foundry dependencies.
- `make fmt`: Format the code using `forge fmt`.
- `make fmt-check`: Check if the code is formatted using `forge fmt --check`.
- `make lint`: Lint the code using `forge lint`.
- `make build`: Compile the project.
- `make zkbuild`: Compile the project for ZkSync.
- `make test`: Run tests.
- `make test-force`: Run tests with `--force`.
- `make snapshot`: Run gas snapshot.
- `make coverage`: Run test coverage report.
- `make coverage-force`: Run test coverage report with `--force`.
- `make anvil`: Start a local Anvil node.
- `make zkanvil`: Start a local ZkSync Anvil node.
- `make deploy`: Deploy to Anvil.
- `make deploy-sepolia`: Deploy to Sepolia testnet.
- `make deploy-zksync-sepolia`: Deploy to ZkSync Sepolia testnet.
- `make zkdeploy`: Deploy to ZkSync Anvil.
- `make stop-anvil`: Stop the running Anvil node.
- `make stop-zkanvil`: Stop the running ZkSync Anvil node.
- `make zkfoundry`: Update Foundry for ZKsync.

## Deployment

### Sepolia Testnet

To deploy to the Sepolia testnet, ensure you have your `.env` file configured with `SEPOLIA_RPC_URL`, `SEPOLIA_ACCOUNT`, `SEPOLIA_SENDER`, and `ETHERSCAN_API_KEY`.

```bash
make deploy-sepolia
```

### ZkSync Sepolia Testnet

To deploy to the ZkSync Sepolia testnet, ensure you have your `.env` file configured with `ZKSYNC_SEPOLIA_RPC_URL`, `ZKSYNC_SEPOLIA_ACCOUNT`, `ZKSYNC_SEPOLIA_SENDER`, and `ETHERSCAN_API_KEY`.

```bash
make deploy-zksync-sepolia
```

## Code Quality

- **Test Coverage**: The project has high test coverage (~95%), including unit tests for scripts and libraries.
- **Linting**: Code is linted using `forge lint` to ensure best practices.
- **Formatting**: Code is formatted using `forge fmt`.
- **Refactoring**: Magic numbers have been replaced with named constants for better readability.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
