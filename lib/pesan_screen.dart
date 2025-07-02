import 'package:flutter/material.dart';

class PesanScreen extends StatefulWidget {
  const PesanScreen({super.key});

  @override
  State<PesanScreen> createState() => _PesanScreenState();
}

class _PesanScreenState extends State<PesanScreen> {
  @override
  Widget build(BuildContext context) {
    final messages = [
      {
        'title': 'Promo Spesial!',
        'subtitle': 'Dapatkan cashback 30% untuk transaksi di atas Rp100.000',
        'time': 'Hari ini',
        'icon': Icons.local_offer
      },
      {
        'title': 'Notifikasi Transaksi',
        'subtitle': 'Isi ulang Rp30.000 berhasil dilakukan',
        'time': 'Kemarin',
        'icon': Icons.receipt_long
      },
      {
        'title': 'Update Fitur Baru',
        'subtitle': 'Sekarang kamu bisa kirim uang ke rekening bank!',
        'time': '2 hari lalu',
        'icon': Icons.system_update
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kotak Masuk"),
        centerTitle: true,
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFFEEEEE),
      body: ListView.separated(
        itemCount: messages.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final message = messages[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.pink[100],
              child: Icon(message['icon'] as IconData, color: Colors.white),
            ),
            title: Text(message['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(message['subtitle'] as String),
            trailing: Text(message['time'] as String,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          );
        },
      ),
    );
  }
}
