import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

class SuccessScreen extends StatefulWidget {
  // Menerima data jumlah transaksi dari halaman sebelumnya
  final String amount;

  const SuccessScreen({super.key, required this.amount});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();
    // Pastikan locale 'id_ID' sudah terdaftar jika belum,
    // biasanya dilakukan di main.dart
    // initializeDateFormatting('id_ID', null);
  }

  // Fungsi untuk memformat angka menjadi format mata uang Rupiah
  String _formatCurrency(String amount) {
    try {
      final number = double.parse(amount);
      // Format mata uang untuk Indonesia (Rupiah)
      final format =
          NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
      return format.format(number);
    } catch (e) {
      // Fallback jika parsing gagal
      return "Rp $amount";
    }
  }

  // Fungsi untuk kembali ke Dashboard dan menghapus semua halaman sebelumnya dari stack
  void _goToDashboard() {
    Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
  }

  // Fungsi untuk menampilkan opsi tambahan (misal: bagikan, unduh)
  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.share, color: Color(0xFFE91E63)),
              title: const Text('Bagikan Bukti Transaksi'),
              onTap: () {
                Navigator.pop(context); // Tutup bottom sheet
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fungsi "Bagikan" belum diimplementasikan.')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.download, color: Color(0xFFE91E63)),
              title: const Text('Unduh Bukti Transaksi'),
              onTap: () {
                Navigator.pop(context); // Tutup bottom sheet
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fungsi "Unduh" belum diimplementasikan.')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE91E63),
      body: Column(
        children: [
          // AppBar kustom
          Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: _goToDashboard, // Tombol kembali ke dashboard
                ),
                const Text(
                  "Detail Transaksi",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onPressed: _showMoreOptions, // Menampilkan opsi tambahan
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Konten utama
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 60),
                  const SizedBox(height: 16),
                  const Text(
                    "Transaksi Berhasil",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    // Menampilkan tanggal dan waktu saat ini dengan format Indonesia
                    DateFormat('d MMMM yyyy • HH:mm', 'id_ID').format(DateTime.now()) + ' WIB',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Total Isi Ulang",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatCurrency(widget.amount), // Menampilkan jumlah yang diformat
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE91E63),
                    ),
                  ),
                  const Spacer(), // Mendorong konten ke atas dan bawah
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet,
                            size: 40, color: Color(0xFFE91E63)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("My Dompet App",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Isi Ulang Saldo",
                                style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),

          // Tombol Aksi Bawah
          Container(
            color: Colors.white, // Memberi background putih pada area tombol
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _goToDashboard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text("Kembali ke Beranda",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
