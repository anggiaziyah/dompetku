import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RiwayatScreen extends StatefulWidget {
  @override
  _RiwayatScreenState createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  final supabase = Supabase.instance.client;
  List<dynamic> riwayat = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRiwayat();
  }

  Future<void> fetchRiwayat() async {
    try {
      final response = await supabase
          .from('riwayat')
          .select()
          .order('waktu', ascending: false)
          .limit(7);

      setState(() {
        riwayat = response;
        isLoading = false;
      });
    } catch (e) {
      print('Gagal ambil data riwayat: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatTanggal(String waktuIso) {
    final date = DateTime.parse(waktuIso);
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
  }

  IconData getIcon(String jenis) {
    switch (jenis.toLowerCase()) {
      case 'top up':
        return Icons.arrow_downward;
      case 'kirim':
        return Icons.arrow_upward;
      case 'terima':
        return Icons.call_received;
      default:
        return Icons.receipt;
    }
  }

  Color getIconColor(String jenis) {
    switch (jenis.toLowerCase()) {
      case 'top up':
        return Colors.green;
      case 'kirim':
        return Colors.red;
      case 'terima':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Transaksi"),
        backgroundColor: Colors.pink.shade600,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : riwayat.isEmpty
              ? const Center(child: Text("Belum ada riwayat transaksi"))
              : ListView.builder(
                  itemCount: riwayat.length,
                  itemBuilder: (context, index) {
                    final item = riwayat[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              getIconColor(item['jenis']).withOpacity(0.1),
                          child: Icon(
                            getIcon(item['jenis']),
                            color: getIconColor(item['jenis']),
                          ),
                        ),
                        title: Text("${item['jenis']} ke ${item['tujuan']}"),
                        subtitle: Text(formatTanggal(item['waktu'])),
                        trailing: Text(
                          "Rp ${item['jumlah']}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
