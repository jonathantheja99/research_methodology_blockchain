# Reducing Corruption Through Blockchain-Based Transparency Systems

This project investigates how blockchain technology can reduce corruption by guaranteeing the integrity and auditability of public records. To do this, **two prototype systems were built and compared**:

- **System A — Centralized system** (the *control*): a traditional client–server REST API built with **Python Flask** and an in-memory database, tested with **Postman**. It deliberately allows records to be edited with **no audit trail**, mirroring how data in conventional centralized government systems can be tampered with from the inside.
- **System B — Blockchain-based system** (the *proposed solution*): a **Solidity smart contract** deployed on the **Ethereum Sepolia Testnet** via **Remix IDE** and **MetaMask**. Once written, data is **immutable** and every transaction is publicly verifiable on **Etherscan**, so tampering is impossible and fully traceable.

The comparison shows that System A enables undetectable data manipulation, while System B makes records tamper-proof, transparent, and publicly verifiable.

---

## Repository structure

```
.
├── README.md
├── server.py            # SYSTEM A — Flask REST API (centralized)
├── requirements.txt     # System A dependencies
├── postman/
│   └── RM-Blockchain.postman_collection.json   # System A — importable Postman tests
├── contracts/
│   └── TransparencyRegistry.sol                # SYSTEM B — Solidity smart contract
└── docs/                # Academic deliverables (final paper, Turnitin report, proofs)
    ├── Question1_FinalPaper/
    ├── Question2_FinalPaper/
    ├── Question3_FinalPaper/
    └── Question4_FinalPaper/
```

---

# System A — Centralized REST API (Python Flask)

A traditional client–server system where one entity owns the data, making it susceptible to internal tampering. Data is held in an in-memory list, so it resets every time the server restarts (this is intentional for the simulation).

### 1. Run the server

> Requires Python 3.10+.

```bash
# (Optional) create and activate a virtual environment
python -m venv venv
venv\Scripts\activate        # Windows
# source venv/bin/activate   # macOS / Linux

# Install dependencies and run
pip install -r requirements.txt
python server.py
```

The server starts at **http://127.0.0.1:5000**.

### 2. Endpoints

| # | Method | Endpoint            | Purpose                                                        |
|---|--------|---------------------|----------------------------------------------------------------|
| 1 | `POST` | `/register`         | **CREATE** — register a new aid recipient (legitimate entry)   |
| 2 | `GET`  | `/transactions`     | **READ** — list every stored record                            |
| 3 | `PUT`  | `/manipulate/<id>`  | **UPDATE** — alter a record to simulate corruption             |

**`POST /register` body**
```json
{
    "nama": "Budi Santoso",
    "alamat_wallet": "0xABC123DEF456",
    "jumlah": 1000000
}
```

**`PUT /manipulate/1` body**
```json
{
    "alamat_wallet_baru": "0xHACKER999",
    "jumlah_baru": 1
}
```

### 3. Test with Postman

A ready-to-use collection lives at [`postman/RM-Blockchain.postman_collection.json`](postman/RM-Blockchain.postman_collection.json).

1. Open Postman → **Import** → select that JSON file.
2. Start the server (`python server.py`).
3. Run the requests in order: **Register → Get All Transactions → Manipulate → Get All Transactions again**.

### What it demonstrates

After running `PUT /manipulate/<id>`, the record is silently overwritten — the old value disappears with **no trace or audit log**. This shows that a centralized system administrator can alter records with impunity, which is the core vulnerability that enables corruption.

---

# System B — Blockchain Smart Contract (Solidity / Ethereum Sepolia)

A decentralized counterpart implemented as the [`contracts/TransparencyRegistry.sol`](contracts/TransparencyRegistry.sol) smart contract. Records are written to the blockchain and **cannot be modified or deleted** — there is intentionally no manipulate/delete function. Every write emits an event tied to a transaction hash that anyone can verify publicly.

### Prerequisites

1. A web browser with the **[MetaMask](https://metamask.io/)** extension installed.
2. Switch MetaMask to the **Sepolia Test Network** (Settings → enable "Show test networks").
3. Get free test ETH from a **Sepolia faucet** (e.g. [sepoliafaucet.com](https://sepoliafaucet.com/)) to pay for gas — no real money is involved.

### 1. Deploy the contract

1. Open the **[Remix IDE](https://remix.ethereum.org/)** in your browser.
2. Create a new file and paste in the contents of [`contracts/TransparencyRegistry.sol`](contracts/TransparencyRegistry.sol).
3. **Compile** tab → compile with a Solidity `0.8.x` compiler.
4. **Deploy & Run** tab → set *Environment* to **"Injected Provider - MetaMask"** (this connects Remix to Sepolia through your wallet).
5. Click **Deploy** and confirm the transaction in the MetaMask popup.

### 2. Use the contract

Once deployed, the contract appears under *Deployed Contracts* in Remix with two functions:

| Function | Purpose |
|----------|---------|
| `registerRecipient(address _wallet, uint256 _amount)` | Write a recipient record to the blockchain (CREATE). MetaMask prompts you to sign. |
| `getRecipientInfo(address _wallet)` | Read back a recipient's stored details (READ). |

- **Register:** enter a wallet address and an amount, click `registerRecipient`, and approve in MetaMask.
- **Read:** paste the same address into `getRecipientInfo` to retrieve the stored record.
- **Try to tamper:** call `registerRecipient` **again with the same address** — the transaction **reverts** ("Record already exists and cannot be modified"), proving the data is immutable.

### 3. Verify on Etherscan

Copy any transaction hash from MetaMask or Remix and paste it into **[sepolia.etherscan.io](https://sepolia.etherscan.io/)**. The transaction and its data are permanently and publicly visible — this is the tamper-proof **public audit trail**.

### What it demonstrates

Unlike System A, no record can be altered or removed after it is written. Every action requires a cryptographic signature (MetaMask) and is logged on-chain forever, providing immutability, traceability, and public verifiability — the properties needed to deter corruption.

---

## System A vs System B

| Criterion          | System A (Centralized)              | System B (Blockchain)             |
|--------------------|-------------------------------------|-----------------------------------|
| Data manipulation  | Possible via `PUT` endpoint         | Impossible (immutable)            |
| Audit trail        | None — changes leave no trace       | Every tx recorded on-chain        |
| Transparency       | Restricted, internal only           | Public, verifiable on Etherscan   |
| Authentication     | None                                | Cryptographic signing (MetaMask)  |
| Tech stack         | Python Flask + Postman              | Solidity + Remix + Sepolia        |

---

## Deliverables

- **Final Paper:** [`docs/Question1_FinalPaper/`](docs/Question1_FinalPaper/)
- **Turnitin & submission proof:** [`docs/Question2_FinalPaper/`](docs/Question2_FinalPaper/)
- Additional materials (presentation script and external links) are in [`docs/`](docs/).
