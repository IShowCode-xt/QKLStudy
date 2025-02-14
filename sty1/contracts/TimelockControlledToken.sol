// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/governance/TimelockController.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract TimelockControlledToken is ERC20, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    // 使用 TimelockController 进行控制
    TimelockController public timelock;

    constructor(address timelockAddress) ERC20("MyToken", "MTK") {
        // 设置 TimelockController 地址
        timelock = TimelockController(payable(timelockAddress));

        // 将合约的 MINTER_ROLE 分配给 TimelockController 进行管理
        _grantRole(MINTER_ROLE, timelockAddress);

    }

    // 只有具有 MINTER_ROLE 的账户才能铸造代币
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

}

contract MyTimelockController is TimelockController {
    constructor(
        uint256 minDelay,        // 最小延迟时间（秒）
        address[] memory proposers, // 提议者账户
        address[] memory executors  // 执行者账户
    ) TimelockController(minDelay, proposers, executors,msg.sender) {}
}

contract test{
    MyTimelockController public cc;
    constructor(address payable _add){
        cc = MyTimelockController(_add);
    }
    // _adds erc20合约地址
    // _adds2 给_adds2铸造一定数量的币
    function testOne(address _adds,address _adds2) external {
        bytes memory data = abi.encodeWithSignature("mint(address,uint256)", _adds2, 1000 * 10**18);
        cc.schedule(_adds, 0, data, 0, keccak256("mintRequest"), 60);
    }
}