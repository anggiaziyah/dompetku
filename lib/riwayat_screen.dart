import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;
import 'package:supabase_flutter/supabase_flutter.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

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
    return DateFormat('d MMM yyyy • HH:mm', 'id_ID').format(date);
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

  Future<void> _unduhBukti(Map<String, dynamic> data) async {
    final pdf = pw.Document();
    final waktu = DateTime.parse(data['waktu']);
    final formattedDate = DateFormat('d MMMM yyyy - HH:mm', 'id_ID').format(waktu);
    final idTransaksi =
        "TRX${waktu.year}${waktu.month.toString().padLeft(2, '0')}${waktu.day.toString().padLeft(2, '0')}${waktu.hour}${waktu.minute}";

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a6,
        build: (context) => pw.Padding(
          padding: const pw.EdgeInsets.all(16),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text('MY DOMPET APP',
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              ),
              pw.Center(child: pw.Text('BUKTI TRANSAKSI')),
              pw.SizedBox(height: 10),
              pw.Divider(),

              pw.Table(
                columnWidths: {
                  0: pw.FlexColumnWidth(3),
                  1: pw.FlexColumnWidth(5),
                },
                children: [
                  _buildRow('Tanggal', '$formattedDate WIB'),
                  _buildRow('ID Transaksi', idTransaksi),
                  _buildRow('Jenis', data['jenis']),
                  _buildRow('Keterangan', data['keterangan'] ?? '-'),
                  _buildRow('Jumlah', "Rp ${data['nominal']}"),
                  _buildRow('Status', 'BERHASIL'),
                ],
              ),

              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.Center(child: pw.Text('Terima kasih telah menggunakan')),
              pw.Center(child: pw.Text('My Dompet App')),
            ],
          ),
        ),
      ),
    );

    final Uint8List bytes = await pdf.save();
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    // ignore: unused_local_variable
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "bukti_transaksi_$idTransaksi.pdf")
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  pw.TableRow _buildRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          child: pw.Text(label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          child: pw.Text(value),
        ),
      ],
    );
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
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              getIconColor(item['jenis']).withOpacity(0.1),
                          child: Icon(
                            getIcon(item['jenis']),
                            color: getIconColor(item['jenis']),
                          ),
                        ),
                        title: Text("${item['jenis']} - ${item['keterangan']}"),
                        subtitle: Text(formatTanggal(item['waktu'])),
                        trailing: IconButton(
                          icon: const Icon(Icons.download, color: Colors.pink),
                          onPressed: () => _unduhBukti(item),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
