// SPDX-License-Identifier: MIT
// Baris ini adalah lisensi, wajib ada untuk memberi tahu compiler.
pragma solidity ^0.8.20;

// Ini adalah "blueprint" atau cetakan dari kontrak kita, namanya DanaBantuan.
contract DanaBantuan {

    // ===================================
    // 1. STATE VARIABLES (Database Kontrak)
    // ===================================
    
    // Variabel untuk menyimpan alamat wallet siapa yang men-deploy kontrak ini.
    // Hanya dia yang kita sebut sebagai "admin".
    address public admin;

    // Ini adalah "database" kita.
    // Kita menggunakan "mapping", mirip seperti dictionary di Python.
    // Key-nya adalah alamat wallet penerima (address).
    // Value-nya adalah jumlah dana yang akan diterima (uint, singkatan dari unsigned integer).
    mapping(address => uint) public daftarPenerima;

    // ===================================
    // 2. CONSTRUCTOR (Fungsi Inisialisasi)
    // ===================================

    // "constructor" adalah fungsi spesial yang HANYA berjalan SATU KALI
    // saat kontrak ini pertama kali di-deploy (ditanam) ke blockchain.
    constructor() {
        // msg.sender adalah variabel global yang berisi alamat wallet
        // dari si pen-deploy.
        // Kita set dia sebagai admin saat itu juga.
        admin = msg.sender;
    }

    // ===================================
    // 3. MODIFIER (Aturan Keamanan)
    // ===================================

    // "modifier" adalah aturan keamanan yang bisa kita tempel ke fungsi lain.
    // Aturan ini kita beri nama "onlyAdmin".
    modifier onlyAdmin() {
        // require() adalah perintah untuk "memeriksa".
        // Jika kondisi di dalamnya salah, transaksi akan gagal (revert).
        // Kita cek: "Apakah yang memanggil fungsi ini (msg.sender) adalah admin?"
        require(msg.sender == admin, "Error: Hanya admin yang bisa menjalankan fungsi ini.");
        
        // Simbol _ ini berarti "Jika lolos, silakan lanjutkan eksekusi fungsinya".
        _;
    }

    // ===================================
    // 4. FUNCTIONS (Logika Bisnis)
    // ===================================

    // --- FUNGSI TULIS DATA (WRITE FUNCTION) ---

    // Ini adalah fungsi untuk mendaftarkan penerima baru.
    // Kita tempel aturan "onlyAdmin" di sini.
    function registerRecipient(address _alamatWallet, uint _jumlahDana) public onlyAdmin {
        // Kita tambahkan cek keamanan:
        // 1. Alamat wallet tidak boleh alamat kosong (alamat 0x0).
        require(_alamatWallet != address(0), "Error: Alamat wallet tidak boleh kosong.");
        // 2. Jumlah dana harus lebih dari 0.
        require(_jumlahDana > 0, "Error: Jumlah dana harus lebih dari 0.");
        
        // Masukkan data ke dalam "database" mapping kita.
        daftarPenerima[_alamatWallet] = _jumlahDana;
    }


    // --- FUNGSI BACA DATA (READ FUNCTION) ---

    // Ini adalah fungsi untuk melihat data penerima.
    // "public view" berarti fungsi ini gratis dibaca siapa saja dan tidak mengubah data.
    function getRecipientInfo(address _alamatWallet) public view returns (uint) {
        // Kembalikan data jumlah dana berdasarkan alamat wallet yang dicari.
        return daftarPenerima[_alamatWallet];
    }
}