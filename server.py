# Import library Flask yang sudah kita install di Fase 1
from flask import Flask, request, jsonify

# Inisialisasi aplikasi Flask kita
app = Flask(__name__)

# Kita buat "database" palsu menggunakan list Python.
# Data ini akan hilang setiap kali server dimatikan, tapi ini sudah cukup untuk simulasi.
database = []
# Ini adalah counter untuk membuat ID unik setiap ada data baru
transaction_id_counter = 1

# ==============================================================
# INI ADALAH FUNGSI-FUNGSI ATAU "ENDPOINT" DARI SERVER KITA
# ==============================================================

# 1. Endpoint untuk MENDAFTARKAN penerima (Operasi CREATE)
@app.route('/register', methods=['POST'])
def register_recipient():
    global transaction_id_counter
    # Ambil data JSON yang dikirim oleh client (Postman)
    data = request.get_json()

    # Buat struktur data penerima baru dalam format dictionary
    new_recipient = {
        "id": transaction_id_counter,
        "nama": data['nama'],
        "alamat_wallet": data['alamat_wallet'],
        "jumlah": data['jumlah']
    }
    # Masukkan data baru ke dalam "database" list kita
    database.append(new_recipient)
    # Tambahkan counter ID agar ID selanjutnya unik
    transaction_id_counter += 1
    # Kirim respon balik ke client bahwa data berhasil dibuat
    return jsonify({"message": "Penerima berhasil didaftarkan", "data": new_recipient}), 201

# 2. Endpoint untuk MELIHAT SEMUA data transaksi (Operasi READ)
@app.route('/transactions', methods=['GET'])
def get_transactions():
    # Tampilkan semua data yang ada di "database" kita
    return jsonify(database)

# 3. Endpoint untuk MEMANIPULASI data (Operasi UPDATE)
# Inilah celah korupsi yang akan kita simulasikan!
@app.route('/manipulate/<int:id>', methods=['PUT'])
def manipulate_data(id):
    # Ambil data JSON yang dikirim oleh client
    data = request.get_json()
    # Cari data di database berdasarkan ID yang diberikan di URL
    for recipient in database:
        if recipient['id'] == id:
            # Update data lama dengan data baru yang dikirim
            recipient['alamat_wallet'] = data.get('alamat_wallet_baru', recipient['alamat_wallet'])
            recipient['jumlah'] = data.get('jumlah_baru', recipient['jumlah'])
            return jsonify({"message": f"Data untuk ID {id} berhasil dimanipulasi!"})

    # Jika ID yang dicari tidak ada, beri pesan error
    return jsonify({"message": "Data tidak ditemukan"}), 404

# ==============================================================
# Perintah untuk menjalankan server saat file ini dieksekusi
# ==============================================================
if __name__ == '__main__':
    # debug=True membuat server otomatis restart jika ada perubahan kode
    app.run(debug=True)