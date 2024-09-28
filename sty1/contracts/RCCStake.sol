// SPDX-License-Identifier: MITs
pragma solidity ^0.8.0;

contract RCCStake 
{
    address public owner;
    mapping(address => uint256) public stakes;

    constructor() {
        owner = msg.sender;
    }

    function stake(uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");
        stakes[msg.sender] += amount;       
    }

    function unstake(uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");
        require(stakes[msg.sender] >= amount, "Insufficient stake amount");
        stakes[msg.sender] -= amount;
    }


}