-include .env

build:; forge build

deploy-sepolia: 
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEP_URL) --private-key $(SEP_PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

deploy-anvil: 
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(RPC_URL) --account defaultkey --broadcast -vvvv
	