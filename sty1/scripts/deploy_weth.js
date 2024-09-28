// 引入 ethers 库，用于与 Ethereum 钱包和合约交互
const { ethers } = require("hardhat");
async function main() {
    // 获取用于部署合约的账户
    const [deployer] = await ethers.getSigners();

    if (!deployer) {
        console.error("No deployer account available");
        return;
    }

    // 显示部署账户的地址和余额
    console.log("Deploying contracts with the account:", deployer.address);
    try {
        const balance = await deployer.getBalance();
        console.log("Account balance:", ethers.utils.formatEther(balance), "ETH");
    } catch (error) {
        console.error("Failed to get deployer balance:", error);
        return;
    }

    // 部署 WETH 合约
    console.log("Deploying WETH contract...");
    const WETH = await ethers.getContractFactory("WETH");
    const weth = await WETH.deploy();

    // 等待合约部署完成并显示合约地址
    console.log("WETH deployed to:", weth.address);
}

// 执行部署并捕捉可能的错误
main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error("Deployment failed:", error);
        process.exit(1);
    });
