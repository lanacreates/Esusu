import { ethers } from "hardhat";

async function main() {
  // Get the contract factory
  const DecentralizedSavings = await ethers.getContractFactory("DecentralizedSavings");
  
  // Deploy the contract
  const decentralizedSavings = await DecentralizedSavings.deploy();
  
  // Wait for the contract to be deployed
  await decentralizedSavings.waitForDeployment();

  // Log the address of the deployed contract
  console.log("DecentralizedSavings contract deployed to address:", await decentralizedSavings.getAddress());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
