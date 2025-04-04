# mercychain-core
Core contracts and docs for MercyChain — the gold-pegged, biometric-based blockchain.
## Smart Contracts

- `contracts/DNAR.sol` — MercyChain's gold-pegged main token (DNAR) with wallet cap enforcement.
- `contracts/DNAREscrow.sol` — Escrow contract for DNAR purchases, hybrid time-based and activity-based unlocking system.
## Tasks for Developers

- [ ] Expand `DNAR.sol` to add burn lock mechanism after wallet cap exceed
- [ ] Expand `DNAREscrow.sol` to automatically burn unclaimed tokens after X months
- [ ] Deploy DNAR and DNAREscrow contracts on testnet
- [ ] Write simple claim app (web or mobile) for escrowed DNAR tokens
