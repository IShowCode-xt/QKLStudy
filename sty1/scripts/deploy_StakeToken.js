const { ethers } = require("hardhat");
const { parseEther } = ethers; // 直接从 ethers 导入 parseEther
async function main() {
    const [deployer] = await ethers.getSigners();
    
    console.log("Deploying contracts with the account:", deployer.address);

    const StakeToken = await ethers.getContractFactory("StakeToken");
    const tokenAddress = "0x4e1CB075C33c920dE0Cc20EF19FfcE59545C7039"; // 替换为你的代币地址
    const ethAmount = parseEther("0.01"); // 发送0.01 ETH
    const stakeToken = await StakeToken.deploy(deployer.address, tokenAddress, { value: ethAmount });

       // 使用 await 获取实际的地址
       const deployedAddress = await stakeToken.getAddress();
       console.log("StakeToken deployed to:", deployedAddress);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });