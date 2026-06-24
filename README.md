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
├── contracts/                          # SYSTEM B — Remix workspace
│   ├── DanaBantuan.sol                  #   the Solidity smart contract
│   ├── artifacts/                       #   compiled output (ABI + metadata) from Remix
│   ├── remix.config.json                #   Remix workspace config
│   └── .prettierrc.json                 #   formatting config
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

A decentralized counterpart implemented as the [`contracts/DanaBantuan.sol`](contracts/DanaBantuan.sol) smart contract (*Dana Bantuan* = "Aid Fund"). Only the contract's **admin** — the wallet that deployed it — can write records (enforced by an `onlyAdmin` modifier), there is intentionally **no function to delete or silently edit** stored data, and, crucially, **every write is a permanent transaction recorded on the blockchain** that anyone can verify on Etherscan. The compiled output (ABI + metadata) produced by Remix is included under [`contracts/artifacts/`](contracts/artifacts/).

### Prerequisites

1. A web browser with the **[MetaMask](https://metamask.io/)** extension installed.
2. Switch MetaMask to the **Sepolia Test Network** (Settings → enable "Show test networks").
3. Get free test ETH from a **Sepolia faucet** (e.g. [sepoliafaucet.com](https://sepoliafaucet.com/)) to pay for gas — no real money is involved.

### 1. Deploy the contract

1. Open the **[Remix IDE](https://remix.ethereum.org/)** in your browser.
2. Create a file `DanaBantuan.sol` and paste in the contents of [`contracts/DanaBantuan.sol`](contracts/DanaBantuan.sol).
3. **Compile** tab → compile with a Solidity **`0.8.20`** (or newer `0.8.x`) compiler — the contract uses `pragma solidity ^0.8.20`.
4. **Deploy & Run** tab → set *Environment* to **"Injected Provider - MetaMask"** (this connects Remix to Sepolia through your wallet).
5. Click **Deploy** and confirm the transaction in the MetaMask popup. The wallet you deploy with becomes the contract **admin**.

### 2. Use the contract

Once deployed, the contract appears under *Deployed Contracts* in Remix with these functions:

| Function | Purpose |
|----------|---------|
| `registerRecipient(address _alamatWallet, uint _jumlahDana)` | Write a recipient record (CREATE). **Admin-only** — MetaMask prompts you to sign. Reverts for non-admins, an empty address, or a zero amount. |
| `getRecipientInfo(address _alamatWallet)` | Read the amount stored for a wallet (READ — free, no gas). |
| `admin()` | The wallet address that deployed the contract. |
| `daftarPenerima(address)` | Public mapping getter — amount registered to a given wallet. |

- **Register (admin only):** as the deploying wallet, enter a recipient address and an amount, click `registerRecipient`, and approve in MetaMask.
- **Read:** paste the address into `getRecipientInfo` (or `daftarPenerima`) to retrieve the stored amount — anyone can do this for free.
- **Try to tamper as an outsider:** connect a *different* wallet and call `registerRecipient` — it **reverts** with *"Hanya admin yang bisa menjalankan fungsi ini"*, so unauthorized users cannot inject or change records.
- **No silent edits:** there is no delete function, and every `registerRecipient` call is its own transaction permanently recorded on-chain — so even an authorized update is publicly visible on Etherscan, unlike System A's untraceable `PUT`.

### 3. Verify on Etherscan

Copy any transaction hash from MetaMask or Remix and paste it into **[sepolia.etherscan.io](https://sepolia.etherscan.io/)**. The transaction and its data are permanently and publicly visible — this is the tamper-proof **public audit trail**.

### What it demonstrates

Unlike System A, records can only be written by the authorized admin, there is no delete or silent-edit function, and every action is cryptographically signed (MetaMask) and logged on-chain forever. Any change is therefore traceable and publicly verifiable — providing the immutability, transparency, and accountability needed to deter corruption.

---

## System A vs System B

| Criterion          | System A (Centralized)              | System B (Blockchain)                          |
|--------------------|-------------------------------------|------------------------------------------------|
| Data manipulation  | Possible & untraceable via `PUT`    | No delete/edit function; every change logged on-chain |
| Audit trail        | None — changes leave no trace       | Every transaction permanently recorded on-chain |
| Transparency       | Restricted, internal only           | Public, verifiable on Etherscan                |
| Access control     | None — anyone with API access       | Admin-only writes (`onlyAdmin`)                |
| Authentication     | None                                | Cryptographic signing (MetaMask)               |
| Tech stack         | Python Flask + Postman              | Solidity + Remix + Sepolia                     |

---

## Deliverables

- **Final Paper:** [`docs/Question1_FinalPaper/`](docs/Question1_FinalPaper/)
- **Turnitin & submission proof:** [`docs/Question2_FinalPaper/`](docs/Question2_FinalPaper/)
- Additional materials (presentation script and external links) are in [`docs/`](docs/).
