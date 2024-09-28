// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; // 导入 IERC20 接口
contract StakeToken {
    address public owner;
    uint256 public rate;
    address public token;
    mapping(address => uint256) public stakedAmount;
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    event Staked(address indexed user, uint256 amount);
    constructor(address _owner,address _token)payable{
        owner = _owner;
        token = _token;
    }
    function setRate() public  {
        uint256 ethAmount = address(this).balance; // 获取合约的ETH数量
        uint256 tokenAmount = IERC20(token).balanceOf(address(this)); // 获取合约中质押代币的数量
        require(tokenAmount > 0, "No tokens staked"); // 确保质押代币数量大于0
         rate = ethAmount * 1e18 / tokenAmount; // 计算rate
    }
    function stake(uint256 amount) public payable {
        require(amount > 0, "Amount must be greater than zero");
        require(msg.value == amount, "Incorrect amount of ETH");
        // 记录质押信息
        stakedAmount[msg.sender] += amount;
        emit Staked(msg.sender, amount);
    }   
    function unstake(uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");
        require(stakedAmount[msg.sender] >= amount, "Insufficient staked amount");
        stakedAmount[msg.sender] -= amount;
        setRate();
        IERC20(token).transfer(msg.sender, amount * rate); // 将token发送到用户账户
        payable(msg.sender).transfer(amount); // 将ETH发送到用户账户
    }
    function getStakedAmount(address user) public view returns (uint256) {
        return stakedAmount[user];
    }
    function getRate() public  returns (uint256) {
        setRate();
        return rate;
    }
    function getToken() public view returns (address) {
        return token;
    }
    function getOwner() public view returns (address) {
        return owner;
    }
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }   
    function getTokenBalance() public view returns (uint256) {
        return IERC20(token).balanceOf(address(this));
    }   


}



