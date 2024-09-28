// 引入 ethers 库，用于与 Ethereum 钱包和合约交互
const { ethers,utils } = require("hardhat");
async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("使用以下账户部署合约:", deployer.address);
    const Token = await ethers.getContractFactory("NewToken");
    const token = await Token.deploy("RemoteCodeCamp", "RCC");
    await token.waitForDeployment();   // 确保合约已经部署完成
    console.log("代币合约部署地址:", token.getAddress());
    // 获取代币总供应量
    const totalSupply = await token.totalSupply();
    console.log("代币总供应量:", utils.formatEther(totalSupply));
    // 获取部署者的代币余额
    const deployerBalance = await token.balanceOf(deployer.address);
    console.log("部署者的代币余额:",utils.formatEther(deployerBalance));
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
