const { ethers } = require("hardhat");

async function main() {
  const FundMe = await ethers.getContractFactory("FundMe");
  const fundMe = await FundMe.deploy();
  await fundMe.deployed();
  const owner = await fundMe.getOwner();

  console.log(`Contract deployed at: ${fundMe.address}`);
  console.log(`Owner of the contract is: ${owner.toString()}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.log(err);
    process.exit(1);
  });
