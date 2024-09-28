require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config(); 
/** @type import('hardhat/config').HardhatUserConfig */
const { ProxyAgent, setGlobalDispatcher } = require("undici");
const proxyAgent = new ProxyAgent("http://127.0.0.1:7890");
setGlobalDispatcher(proxyAgent);
module.exports = {
  solidity: "0.8.24",
  networks: { 
    hardhat: {}, 
    sepolia: { 
    url:
     "https://eth-sepolia.g.alchemy.com/v2/" + process.env.ALCHEMY_API_KEY, accounts: [`0x${process.env.PRIVATE_KEY}`], 
     }, 
     }, 
     etherscan: {
      apiKey: process.env.ETHERSCAN_API_KEY,
      // timeout: 200000, // 增加超时时间到 20 秒
     },
     sourcify: {
      enabled: true
    }
};
