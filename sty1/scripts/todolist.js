const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    
    console.log("Deploying contracts with the account:", deployer.address);

    const todolist = await ethers.getContractFactory("TodoList"); // 修改合约名称为 TodoList
    const deployedTodolist = await todolist.deploy(); // 部署合约
    await deployedTodolist.deployed(); // 等待合约部署完成

    console.log("TodoList deployed to:", deployedTodolist.address); // 输出合约地址
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });