import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class PesanScreen extends StatefulWidget {
  const PesanScreen({super.key});

  @override
  State<PesanScreen> createState() => _PesanScreenState();
}

class _PesanScreenState extends State<PesanScreen> {
  List<Message> _messages = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) return;

    final response = await supabase
        .from('pesan')
        .select()
        .eq('id_user', user.id)
        .order('waktu', ascending: false);

    setState(() {
      _messages = response.map<Message>((data) => Message.fromMap(data)).toList();
      _loading = false;
    });
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _messages.isEmpty
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
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFF8BBD0),
                        child: Icon(Icons.message, color: Color(0xFFE91E63)),
                      ),
                      title: const Text(
                        'Pesan Transaksi',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        message.isi,
                        style: const TextStyle(color: Colors.black87),
                      ),
                      trailing: Text(
                        DateFormat('dd MMM HH:mm', 'id_ID').format(message.waktu),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      // onTap tidak digunakan lagi karena halaman detail dihapus
                    );
                  },
                ),
    );
  }
}

// Buat class model Message jika belum ada
class Message {
  final String isi;
  final DateTime waktu;

  Message({required this.isi, required this.waktu});

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      isi: map['isi'] ?? '',
      waktu: DateTime.parse(map['waktu']),
    );
  }
}
