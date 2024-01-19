import '@nomiclabs/hardhat-ethers'
import '@nomiclabs/hardhat-etherscan'
import "@hashgraph/hardhat-hethers";
import 'hardhat-typechain'
import * as config from './config';

export default {
  hedera: {
		networks: config.networks,
		gasLimit: 2_000_000
	},
  defaultNetwork: 'testnet',
  mocha: {
    timeout: 100000000
  },
  solidity: {
    version: '0.8.12',
    settings: {
      optimizer: {
        enabled: true,
        runs: 1,
      },
      metadata: {
        // do not include the metadata hash, since this is machine dependent
        // and we want all generated code to be deterministic
        // https://docs.soliditylang.org/en/v0.8.12/metadata.html
        bytecodeHash: 'none',
      },
    },
  },
}
