
// scripts/deploy_upgradeable_box.js
const { ethers, upgrades } = require("hardhat");

async function main() {



    const SubBookToken = await ethers.getContractFactory("SubBookToken");
    console.log("Deploying Box...");
    const box = await upgrades.deployProxy(SubBookToken, {
        initializer: "initialize",
    });
    
    console.log("SubBookToken deployment in progress...");
    await box.deployed();
    console.log("Box deployed to:", box.address);

}

main();