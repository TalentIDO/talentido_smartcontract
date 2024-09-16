import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@openzeppelin/hardhat-upgrades";
import "@nomiclabs/hardhat-web3";
import "@nomiclabs/hardhat-solhint";
import dotenv from "dotenv";

dotenv.config();
const projectId = process.env.PROJECT_ID || "7e781c7211314daf9122c36f04621d99";
const privateKey =
  process.env.PRIVATE_KEY ||
  "45d40bfd83c83055b1a7026bc6f196432ed90f08b197b8cd01a6e222348a6ef4";

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  networks: {
    sepolia: {
      url: `https://sepolia.infura.io/v3/${projectId}`,
      accounts: [privateKey],
      chainId: 11155111,
    },
    mainnet: {
      url: `https://mainnet.infura.io/v3/${projectId}`,
      accounts: [privateKey],
      chainId: 1,
      gasPrice: 8e9,
      gas: 10000000,
    },
  },
  etherscan: {
    apiKey: "7E781C7211314DAF9122C36F04621D99",
  }
};

export default config;
