# Fund Me

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

- `make all`: Clean and run tests.
- `make clean`: Clean artifacts, cache, and dependencies.
- `make install`: Install Foundry dependencies.
- `make build`: Compile the project.
- `make zkbuild`: Compile the project for ZkSync.
- `make test`: Run tests.
- `make anvil`: Start a local Anvil node.
- `make zkanvil`: Start a local ZkSync Anvil node.
- `make deploy`: Deploy to Anvil.
- `make zkdeploy`: Deploy to ZkSync Anvil.
- `make stop-anvil`: Stop the running Anvil node.
- `make stop-zkanvil`: Stop the running ZkSync Anvil node.
- `make zkfoundry`: Update Foundry for ZKsync.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
