import 'package:flutter/material.dart';

// 1. Membuat Model untuk data pesan agar lebih terstruktur dan aman
class Message {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  bool isRead; // Menambahkan status 'telah dibaca'

  Message({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    this.isRead = false, // Defaultnya, pesan belum dibaca
  });
}

class PesanScreen extends StatefulWidget {
  const PesanScreen({super.key});

  @override
  State<PesanScreen> createState() => _PesanScreenState();
}

class _PesanScreenState extends State<PesanScreen> {
  // 2. Menggunakan List dari Model Message
  final List<Message> _messages = [
    Message(
      title: 'Promo Spesial!',
      subtitle: 'Dapatkan cashback 30% untuk transaksi di atas Rp100.000',
      time: 'Hari ini',
      icon: Icons.local_offer,
      isRead: false, // Belum dibaca
    ),
    Message(
      title: 'Notifikasi Transaksi',
      subtitle: 'Isi ulang Rp30.000 berhasil dilakukan',
      time: 'Kemarin',
      icon: Icons.receipt_long,
      isRead: true, // Sudah dibaca
    ),
    Message(
      title: 'Update Fitur Baru',
      subtitle: 'Sekarang kamu bisa kirim uang ke rekening bank!',
      time: '2 hari lalu',
      icon: Icons.system_update,
      isRead: false, // Belum dibaca
    ),
  ];

  // 3. Fungsi untuk menampilkan detail pesan saat diklik
  void _showMessageDetail(Message message) {
    // Menandai pesan sebagai telah dibaca
    setState(() {
      message.isRead = true;
    });

    // Menampilkan dialog dengan detail pesan
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message.title),
        content: Text(message.subtitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  // 4. Fungsi untuk menghapus pesan
  void _deleteMessage(int index) {
    setState(() {
      _messages.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pesan telah dihapus.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kotak Masuk"),
        centerTitle: true,
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      // 5. Menampilkan pesan jika kotak masuk kosong
      body: _messages.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mark_email_unread_outlined, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'Tidak ada pesan baru',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: _messages.length,
              separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
              itemBuilder: (context, index) {
                final message = _messages[index];
                return InkWell(
                  onTap: () => _showMessageDetail(message),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: message.isRead ? Colors.grey.shade300 : Colors.pink[100],
                      child: Icon(message.icon, color: message.isRead ? Colors.grey.shade600 : Colors.pink.shade600),
                    ),
                    title: Text(
                      message.title,
                      style: TextStyle(
                        // 6. Judul menjadi tebal jika belum dibaca
                        fontWeight: message.isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(message.subtitle),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          message.time,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        // 7. Tombol hapus
                        InkWell(
                          onTap: () => _deleteMessage(index),
                          child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
