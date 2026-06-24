# Reducing Corruption Through Blockchain-Based Transparency Systems

**COMP6696001 — Final Project · Kelompok (Group) 14**

This repository contains the source code and academic deliverables for our final project: a proof-of-concept demonstrating how a **blockchain-based transparency system** can reduce corruption in the distribution of aid/funds.

The accompanying Flask API deliberately models a **centralized, mutable database** so we can demonstrate the *corruption loophole* (records can be silently altered) — the exact weakness that an immutable, blockchain-backed ledger is designed to eliminate. See the paper in [`docs/`](docs/) for the full discussion.

---

## Project structure

```
.
├── server.py            # Flask REST API (the simulation)
├── requirements.txt     # Python dependencies
├── postman/
│   └── RM-Blockchain.postman_collection.json   # Importable Postman collection
└── docs/                # Academic deliverables
    ├── Question1_FinalPaper/   # Final paper + member contributions
    ├── Question2_FinalPaper/   # Submission proofs + Turnitin report
    ├── Question3_FinalPaper/   # Trailer video link
    └── Question4_FinalPaper/   # Presentation script, slide deck & video links
```

---

## Running the API

> Requires Python 3.10+.

```bash
# 1. (Optional) create and activate a virtual environment
python -m venv venv
venv\Scripts\activate        # Windows
# source venv/bin/activate   # macOS / Linux

# 2. Install dependencies
pip install -r requirements.txt

# 3. Run the server
python server.py
```

The server starts at **http://127.0.0.1:5000**.

> Note: the "database" is an in-memory Python list, so all data resets every time the server restarts — this is intentional for the simulation.

---

## API endpoints

| # | Method | Endpoint            | Purpose                                                        |
|---|--------|---------------------|----------------------------------------------------------------|
| 1 | `POST` | `/register`         | **CREATE** — register a new aid recipient                      |
| 2 | `GET`  | `/transactions`     | **READ** — list every registered record                        |
| 3 | `PUT`  | `/manipulate/<id>`  | **UPDATE** — tamper with a record (demonstrates the corruption loophole) |

### Example payloads

**`POST /register`**
```json
{
    "nama": "Budi Santoso",
    "alamat_wallet": "0xABC123DEF456",
    "jumlah": 1000000
}
```

**`PUT /manipulate/1`**
```json
{
    "alamat_wallet_baru": "0xHACKER999",
    "jumlah_baru": 1
}
```

---

## Testing with Postman

A ready-to-use collection lives at [`postman/RM-Blockchain.postman_collection.json`](postman/RM-Blockchain.postman_collection.json).

1. Open Postman → **Import** → select that JSON file.
2. Start the server (`python server.py`).
3. Run the requests in order: **Register → Get All Transactions → Manipulate**.

The collection defines a `base_url` variable (`http://127.0.0.1:5000`), so you can point all requests at a different host by editing one value.

---

## Deliverables & links

- 📄 **Final Paper:** [`docs/Question1_FinalPaper/`](docs/Question1_FinalPaper/)
- 🧾 **Turnitin & submission proof:** [`docs/Question2_FinalPaper/`](docs/Question2_FinalPaper/)
- 🎬 **Trailer video:** https://youtu.be/n_YAzKzbkf0
- 🖥️ **Slide deck:** see [`docs/Question4_FinalPaper/Slide_Deck_Link_Kelompok14.txt`](docs/Question4_FinalPaper/Slide_Deck_Link_Kelompok14.txt)
- 🎥 **Presentation video:** see [`docs/Question4_FinalPaper/Video_Link.txt`](docs/Question4_FinalPaper/Video_Link.txt)

---

*Course: COMP6696001 · LC83 · Binus University*
