const solanaWeb3 = require('@solana/web3.js');

// 创建连接到主网或测试网的连接对象
const connection = new solanaWeb3.Connection(
    'https://solana-mainnet.g.alchemy.com/v2/3yTTEaKVKs7mXsKiYTewzpUpaMCZM7Jv',
  'confirmed'
);

// 目标地址（替换为你要监控的地址）
const monitoredAddress = new solanaWeb3.PublicKey('EHB8QRb8qf5hWrgUkSCP2bN6jfpQJQzFCVKGX4fFjNay');

async function fetchTransactions() {
  // 获取地址的交易签名
  const signatures = await connection.getSignaturesForAddress(
    monitoredAddress,
    { limit: 10 }  // 你可以设置不同的限制
  );

  // 获取交易详情
  for (let signatureInfo of signatures) {
    const transaction = await connection.getParsedTransaction(signatureInfo.signature);
    console.log('Transaction:', transaction);
  }
}

// 调用异步函数
fetchTransactions();