// SPDX-License-Identifier: MITs
pragma solidity ^0.8.24;
contract MultisigWallet {
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 public requiredConfirmations;
    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;


    function transferOwnership(address newOwner) public {
        require(isOwner[msg.sender], "Only current owners can transfer ownership");
        require(newOwner != address(0), "New owner cannot be the zero address");
        
        // 清空当前所有者并添加新所有者
        for (uint256 i = 0; i < owners.length; i++) {
            isOwner[owners[i]] = false;
        }
        delete owners;

        owners.push(newOwner);
        isOwner[newOwner] = true;
    }
    
}