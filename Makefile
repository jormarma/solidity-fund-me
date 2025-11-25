-include .env

.PHONY: all test test-force clean version foundry zkfoundry build build-force anvil zkanvil	stop-anvil stop-zkanvil	zkbuild zkbuild-force

all: clean test

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

build:
	forge build

zkbuild:
	forge build --zksync

build-force:
	forge build --force

zkbuild-force:
	forge build --force --zksync

# Deploy to anvil
deploy:
	@forge script script/DeployFundMe.s.sol:DeployFundMe \
	--rpc-url $(ANVIL_RPC_URL) \
	--account $(ANVIL_ACCOUNT)	 \
	--sender $(ANVIL_SENDER) \
	--broadcast

zkdeploy:
	@forge script script/DeployFundMe.s.sol:DeployFundMe \
	--rpc-url $(ANVIL_ZKSYNC_RPC_URL) \
	--account $(ANVIL_ZKSYNC_ACCOUNT) \
	--sender $(ANVIL_ZKSYNC_SENDER) \
	--broadcast \
	--zksync

test:
	forge test

test-force:
	forge test --force
	
version:
	forge --version

foundry:
	foundryup

zkfoundry:
	foundryup-zksync

anvil:
	rm -rf nohup.out && nohup anvil &

stop-anvil:
	kill $$(pgrep -f anvil)

zkanvil:
	rm -rf zknohup.out && nohup anvil-zksync > zknohup.out 2>&1 &

stop-zkanvil:
	kill $$(pgrep -f anvil-zksync)