<template>
  <div class="stake-view">
    <h1 class="title">Stake Your Tokens</h1>
    <button v-if="!account" class="connect-button" @click="connectWallet">Connect MetaMask</button>
    <span v-if="account" class="account">{{ account }}</span><br>
    <button v-if="account" class="disconnect-button" @click="disconnectWallet">Disconnect</button><br>
    <span v-if="network" class="network">Network: {{ network }}</span><br>
    <span v-if="balance" class="balance">Balance: {{ balance }} ETH</span><br>
    
    <div class="contract-info" v-if="contractAddress">
      <h2>质押池信息</h2>
      <p>质押池合约地址: {{ contractAddress }}</p>
      <p>质押池ETH余额: {{ contractBalance }} ETH</p>
      <p>质押代币合约地址: {{ tokenAddress }}</p>
      <p>质押代币余额: {{ tokenBalance }}</p>
    </div>

  </div>
</template>

<script>
import { ethers } from 'ethers';

export default {
  data() {
    const ALCHEMY_SEPOLIA_URL = "https://eth-sepolia.g.alchemy.com/v2/" + process.env.VUE_APP_ALCHEMY_API_KEY;
    return {
      provider: new ethers.providers.JsonRpcProvider(ALCHEMY_SEPOLIA_URL),
      account: null,
      balance: null,
      network: null,
      contractAddress: '0x32EC6100Aee2F4130EFfe99e8d3289bD79Ac2550', // 替换为你的合约地址
      contractBalance: null,
      tokenBalance: null,
      tokenAddress: null,
      StakeContract: null,
      
    };
  },
  methods: {
    async fetchContractInfo() {

    },
    async connectWallet() {
      if (window.ethereum) {
        this.provider = new ethers.providers.Web3Provider(window.ethereum);
        await window.ethereum.request({ method: 'eth_requestAccounts' });
        const signer = await this.provider.getSigner();
        this.account = await signer.getAddress();
        console.log(this.account);
        const network = await this.provider.getNetwork();
        console.log("当前网络:", network.name);
        this.network = network.name;
        this.balance = await this.provider.getBalance(this.account);
        this.balance = ethers.utils.formatEther(this.balance);
        this.balance = parseFloat(this.balance).toFixed(4);
        console.log("账户余额:", this.balance, "ETH");
      } else {
        alert("请安装 MetaMask!");
      }
    },
    async disconnectWallet() {
      await this.provider.send("eth_requestAccounts", []);
      this.account = null;
      this.balance = null;
      this.network = null;
      console.log("已断开连接");
    },
  },
  async mounted() {
    this.contractBalance = await this.provider.getBalance(this.contractAddress);
    this.contractBalance = ethers.utils.formatEther(this.contractBalance);
    const StakeAbi=[{"inputs":[{"internalType":"address","name":"_owner","type":"address"},{"internalType":"address","name":"_token","type":"address"}],"stateMutability":"payable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"user","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"Staked","type":"event"},{"inputs":[],"name":"getBalance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getOwner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getRate","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"user","type":"address"}],"name":"getStakedAmount","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getToken","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getTokenBalance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"rate","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"setRate","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"stake","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"stakedAmount","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"token","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"unstake","outputs":[],"stateMutability":"nonpayable","type":"function"}];
    const StakeContract = new ethers.Contract(this.contractAddress,StakeAbi, this.provider);
    this.StakeContract = StakeContract;
    const tokenAddress = await StakeContract.getToken();
    this.tokenAddress = tokenAddress;
    this.tokenBalance = await StakeContract.getTokenBalance();
    console.log("代币合约地址:", tokenAddress);
  },
};
</script>

<style scoped>
.stake-view {
  display: flex;
  flex-direction: column;
  align-items: center;
  background-color: #f5f5f5;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.title {
  font-size: 2em;
  color: #333;
  margin-bottom: 20px;
}

.connect-button, .disconnect-button {
  background-color: #4CAF50;
  color: white;
  border: none;
  padding: 10px 20px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 16px;
  margin: 10px 0;
  cursor: pointer;
  border-radius: 5px;
  transition: background-color 0.3s;
}

.connect-button:hover, .disconnect-button:hover {
  background-color: #45a049;
}

.account, .network, .balance {
  font-size: 1.2em;
  color: #555;
}

.contract-info {
  margin-top: 20px;
  background-color: #e0e0e0;
  padding: 15px;
  border-radius: 8px;
  width: 100%;
  text-align: left;
}

.contract-info h2 {
  font-size: 1.5em;
  color: #333;
}

.contract-info p {
  font-size: 1em;
  color: #666;
}

.staker-info {
  margin-top: 20px;
  background-color: #d0d0d0;
  padding: 15px;
  border-radius: 8px;
  width: 100%;
  max-height: 200px; /* 设置最大高度 */
  overflow-y: auto; /* 允许垂直滚动 */
  text-align: left;
}

.staker-info h2 {
  font-size: 1.5em;
  color: #333;
}

.staker-info p {
  font-size: 1em;
  color: #666;
}
</style>