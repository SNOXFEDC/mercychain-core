// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DNAR is ERC20, Ownable {
    uint256 public walletCap; // Maximum tokens a wallet can hold

    constructor() ERC20("DNAR", "DNAR") {
        _mint(msg.sender, 10_000_000_000 * 10 ** decimals()); // 10 Billion DNAR initial supply
        walletCap = 2_000 * 10 ** decimals(); // 2,000 DNAR wallet cap for standard wallets
    }

    // Override transfer function to add wallet cap enforcement
    function _transfer(address sender, address recipient, uint256 amount) internal override {
        if (recipient != owner()) { // Allow owner wallets (e.g. escrow) to bypass cap
            require(balanceOf(recipient) + amount <= walletCap, "Wallet cap exceeded");
        }
        super._transfer(sender, recipient, amount);
    }

    // Owner can update wallet cap if needed (DAO-controlled later)
    function setWalletCap(uint256 _newCap) external onlyOwner {
        walletCap = _newCap;
    }
}
