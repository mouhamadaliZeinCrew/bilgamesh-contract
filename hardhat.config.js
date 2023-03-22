require("@nomiclabs/hardhat-ethers");
require("@openzeppelin/hardhat-upgrades");
require("@nomiclabs/hardhat-etherscan");

INFURA_API_KEY= "https://goerli.infura.io/v3/2937bccb5df24a28ae44922f1e485bfb"
ETHERSCAN_API_KEY="6476GM32XKH36MBSDA98CTAIR8E9HSUPXA"
PRI_KEY="METAMASKPRIVATEKEY"
module.exports = {
  solidity: "0.8.10",
  networks: {
    goerli: {
      url: INFURA_API_KEY,
      accounts: [PRI_KEY],
      network_id: '5',
    
      timeout: 9900000
    }
    
   
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  },
};