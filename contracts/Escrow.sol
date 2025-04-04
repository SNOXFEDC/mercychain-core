// Escrow contract for purchased DNAR
// Includes time-based and activity-based release logic
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DNAREscrow is Ownable {
    IERC20 public dnarToken;

    struct EscrowInfo {
        uint256 totalAmount;
        uint256 claimedAmount;
        uint256 startTime;
        bool dnaVerified;
        uint256 referralsMade;
    }

    mapping(address => EscrowInfo) public escrows;
    uint256 public timeUnlock1 = 30 days;
    uint256 public timeUnlock2 = 60 days;
    uint256 public finalUnlock = 90 days;

    constructor(address _dnarToken) {
        dnarToken = IERC20(_dnarToken);
    }

    function deposit(address _user, uint256 _amount) external onlyOwner {
        require(_amount > 0, "Amount must be > 0");
        require(escrows[_user].totalAmount == 0, "Escrow already exists");

        dnarToken.transferFrom(msg.sender, address(this), _amount);

        escrows[_user] = EscrowInfo({
            totalAmount: _amount,
            claimedAmount: 0,
            startTime: block.timestamp,
            dnaVerified: false,
            referralsMade: 0
        });
    }

    function markDNAverified(address _user) external onlyOwner {
        escrows[_user].dnaVerified = true;
    }

    function recordReferral(address _user) external onlyOwner {
        escrows[_user].referralsMade += 1;
    }

    function claim() external {
        EscrowInfo storage info = escrows[msg.sender];
        require(info.totalAmount > 0, "No escrow for user");

        uint256 claimable = getClaimableAmount(msg.sender);
        require(claimable > 0, "No tokens available yet");

        info.claimedAmount += claimable;
        dnarToken.transfer(msg.sender, claimable);
    }

    function getClaimableAmount(address _user) public view returns (uint256) {
        EscrowInfo memory info = escrows[_user];
        uint256 unlocked = 0;

        if (info.dnaVerified) {
            unlocked += (info.totalAmount * 10) / 100; // 10% for DNA verification
        }

        if (info.referralsMade >= 3) {
            unlocked += (info.totalAmount * 20) / 100; // 20% bonus for 3+ referrals
        }

        if (block.timestamp >= info.startTime + timeUnlock1) {
            unlocked += (info.totalAmount * 20) / 100;
        }

        if (block.timestamp >= info.startTime + timeUnlock2) {
            unlocked += (info.totalAmount * 20) / 100;
        }

        if (block.timestamp >= info.startTime + finalUnlock) {
            unlocked += (info.totalAmount * 30) / 100;
        }

        if (unlocked > info.totalAmount) {
            unlocked = info.totalAmount;
        }

        return unlocked - info.claimedAmount;
    }
}
