// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
contract OtherContract {
    uint256 private _x = 0; // 状态变量_x
    // 收到eth的事件，记录amount和gas
    event Log(uint amount, uint gas);
     event receivelog(address from ,uint amount);
    receive() external payable { 
        emit  receivelog(msg.sender,msg.value);
    }
    
    // 返回合约ETH余额
    function getBalance() view public returns(uint) {
        return address(this).balance;
    }

    // 可以调整状态变量_x的函数，并且可以往合约转ETH (payable)
    function setX(uint256 x) external payable{
        _x = x;
        // 如果转入ETH，则释放Log事件
        if(msg.value > 0){
            emit Log(msg.value, gasleft());
        }
    }

    // 读取_x
    function getX() external view returns(uint x){
        x = _x;
    }
}


contract test {
function callSetX(address payable _Address, uint256 x) external{
    OtherContract(_Address).setX(x);
}
function callGetX(OtherContract _Address) external view returns(uint x){
    x = _Address.getX();

}
function callGetX2(address payable _Address) external view returns(uint x){
    OtherContract oc = OtherContract(_Address);
    x = oc.getX();
}
function setXTransferETH(address payable  otherContract, uint256 x) payable external{
    OtherContract(otherContract).setX{value: msg.value}(x);
}

}
contract send {
  // 事件，用于记录转账操作
    event Transfer(address indexed sender, address indexed recipient, uint256 amount);

    // 构造函数，部署合约时允许发送 ETH
    constructor() payable {
        require(msg.value > 0, "Initial funding required");
    }

    // 接收 ETH 的函数
    receive() external payable {}

    // 查询合约的余额
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // 发送 ETH 给指定的地址
    function sendETH(address payable recipient, uint256 amount) external {
        require(address(this).balance >= amount, "Insufficient contract balance");
        require(recipient != address(0), "Invalid recipient address");

        // 使用 `call` 发送 ETH，并检查发送结果
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Failed to send ETH");

        emit Transfer(msg.sender, recipient, amount);
    }
}