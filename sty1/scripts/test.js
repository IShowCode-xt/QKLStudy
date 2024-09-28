const { JsonRpcProvider } = require("ethers");

async function main() {
    const provider = new JsonRpcProvider("https://eth-sepolia.g.alchemy.com/v2/AXHpaLX8ZTChuTuSlYTE2ivJBbuPz1_B");
    const contractAddr = '0xFB463562c53D324c10d494C6a89938A7988f55A7';
    const data = await provider.getStorage(contractAddr, 1);

    // `b` (uint8) - 位于插槽 1 的最后一个字节 (第 31 字节)
    const b = parseInt(data.slice(-2), 16);

    // `c` (uint128) - 位于插槽 1 的第 16 到第 31 字节
    const c = BigInt('0x' + data.slice(32, 64)); // 从第32到第64位的切片（32字节的范围）

    // `d` (bool) - 位于插槽 1 的最后 1 个字节 (第 32 字节)
    const d = parseInt(data.slice(-2), 16) !== 0;

    console.log('b:', b); // 应为 12
    console.log('c:', c.toString()); // 应为 13
    console.log('d:', d); // 应为 true
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error("Error:", error);
        process.exit(1);
    });
