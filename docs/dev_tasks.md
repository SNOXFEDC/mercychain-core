# MercyChain Developer Tasks

## Solidity Developer

- [ ] Expand `DNAR.sol` to add burn-lock mechanism after wallet cap exceeded
- [ ] Expand `DNAREscrow.sol` to add automatic burn for unclaimed tokens after X months
- [ ] Deploy DNAR and DNAREscrow to Polygon Mumbai testnet
- [ ] Write basic test cases (transfer, lock, claim)

## Full-Stack Developer (Optional)

- [ ] Build simple web app to interact with MercyChain
  - Connect wallet (Metamask)
  - Display escrow balance
  - Allow user to claim unlocked DNAR tokens
- [ ] Add inviter reward system to `DNAR.sol`:
  - When a wallet receives DNAR for the first time, save the sender as its "parent."
  - On every future outgoing transfer, charge a small fee (e.g., 1%) and send it to the parent wallet automatically.
