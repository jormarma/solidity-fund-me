-include .env

.PHONY: all clean install format lint test build build-optimize build-force zkbuild zkbuild-optimize zkbuild-force anvil zkanvil stop-anvil stop-zkanvil deploy deploy-sepolia zkdeploy test test-force coverage coverage-force version foundry zkfoundry

all: clean install format lint test  

clean:
	forge clean \
	&& rm -rf lib \
	&& rm -rf cache \
	&& rm -rf out \
	&& rm -rf zkout \
	&& rm -rf *nohup.out \
	&& rm -rf anvil-zksync.log \
	&& rm -rf .gas-snapshot	

install:
	forge install cyfrin/foundry-devops \
	&& forge install smartcontractkit/chainlink-brownie-contracts \
	&& forge install foundry-rs/forge-std

update:
	forge update

format: install
	forge fmt

lint: install
	forge lint

test: install
	forge test

test-force: install
	forge test --force

snapshot:
	forge snapshot

coverage: install
	forge coverage

coverage-force: install
	forge coverage --force

build: install
	forge build

build-optimize: install
	forge build --optimize

build-force: install
	forge build --force

zkbuild: install
	forge build --zksync

zkbuild-optimize: install
	forge build --zksync --zk-optimizer --zk-optimizer-mode 3

zkbuild-force: install
	forge build --force --zksync

# Deploy to anvil
deploy: install
	@forge script script/DeployFundMe.s.sol:DeployFundMe \
	--rpc-url $(ANVIL_RPC_URL) \
	--account $(ANVIL_ACCOUNT)	 \
	--sender $(ANVIL_SENDER) \
	--broadcast

zkdeploy: install
	@forge script script/DeployFundMe.s.sol:DeployFundMe \
	--rpc-url $(ANVIL_ZKSYNC_RPC_URL) \
	--account $(ANVIL_ZKSYNC_ACCOUNT) \
	--sender $(ANVIL_ZKSYNC_SENDER) \
	--broadcast \
	--zksync

deploy-sepolia: install
	@forge script script/DeployFundMe.s.sol:DeployFundMe \
	--rpc-url $(SEPOLIA_RPC_URL) \
	--account $(SEPOLIA_ACCOUNT)	 \
	--sender $(SEPOLIA_SENDER) \
	--broadcast \
	--verify \
	--etherscan-api-key $(ETHERSCAN_API_KEY)
	
deploy-zksync-sepolia: install
	@forge script script/DeployFundMe.s.sol:DeployFundMe \
	--rpc-url $(ZKSYNC_SEPOLIA_RPC_URL) \
	--account $(ZKSYNC_SEPOLIA_ACCOUNT)	 \
	--sender $(ZKSYNC_SEPOLIA_SENDER) \
	--broadcast \
	--verify \
	--verifier zksync \
    --verifier-url https://explorer.sepolia.era.zksync.dev/contract_verification \
	--etherscan-api-key $(ETHERSCAN_API_KEY) \
	--zksync
	
version:
	forge --version

foundry: stop-anvil
	foundryup

zkfoundry: stop-zkanvil
	foundryup-zksync

anvil: stop-anvil
	rm -rf nohup.out && nohup anvil &

stop-anvil:
	kill $$(pgrep -f anvil)

zkanvil: zkfoundry stop-zkanvil
	rm -rf zknohup.out && nohup anvil-zksync > zknohup.out 2>&1 &

stop-zkanvil:
	kill $$(pgrep -f anvil-zksync)

# fund:
# 	@forge script script/Interactions.s.sol:FundFundMe --sender $(SENDER_ADDRESS) $(NETWORK_ARGS)

# withdraw:
# 	@forge script script/Interactions.s.sol:WithdrawFundMe --sender $(SENDER_ADDRESS) $(NETWORK_ARGS)