
// scripts/deploy_upgradeable_box.js
const { ethers, upgrades } = require("hardhat");

async function main() {



    const BookContract = await ethers.getContractFactory("BookContract");
    console.log("Deploying Box...");
    const box = await upgrades.deployProxy(BookContract, {
        initializer: "initialize",
    });
    
    console.log("BookContract deployment in progress...");
    await box.deployed();
    console.log("Box deployed to:", BookContract.address);

}

main();