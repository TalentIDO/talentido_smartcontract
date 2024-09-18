import { ethers, network, run, upgrades } from "hardhat";
import { Token__factory, Token } from "../typechain-types";

async function main() {
  const Token_factory = await ethers.getContractFactory("Token");

  console.log("============DEPLOYING CONTRACTS============");

  const tokenTAL = await upgrades.deployProxy(Token_factory, ["abc"]);
  await tokenTAL.deployed();
  const tokenAddress = tokenTAL.address;

  console.log(`EthWAXBridge deployed to:`, tokenAddress);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
