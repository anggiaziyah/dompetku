import 'dart:convert';
import 'dart:io';

import 'package:dompetku/Screen/transaksi/kirim_screen.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isNavigated = false; // ✅ Cegah multiple scan

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) async {
      if (isNavigated) return; // ✅ Jangan lanjut kalau sudah navigasi
      final code = scanData.code;

      if (code == null) {
        showSnackBar("QR tidak terbaca");
        controller.resumeCamera();
        return;
      }

      print('📦 QR Terbaca: $code');

      try {
        final data = jsonDecode(code);

        if (data['type'] != 'user' || data['id'] == null) {
          showSnackBar("QR tidak valid");
          controller.resumeCamera();
          return;
        }

        final userId = data['id'].toString();

        final response = await Supabase.instance.client
            .from('users')
            .select('username, nama_lengkap')
            .eq('id', userId)
            .maybeSingle();

        if (!mounted || isNavigated) return;

        if (response == null) {
          showSnackBar("Pengguna tidak ditemukan");
          controller.resumeCamera();
          return;
        }

        setState(() {
          isNavigated = true; // ✅ Tandai sudah berpindah halaman
        });

        await controller.pauseCamera(); // Stop kamera sebelum navigasi

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => KirimScreen(
              penerimaId: userId,
              username: response['username'] ?? '-',
              namaLengkap: response['nama_lengkap'] ?? '-',
            ),
          ),
        );
      } catch (e) {
        showSnackBar("Gagal membaca QR: $e");
        controller.resumeCamera();
      }
    });
  }

  void showSnackBar(String message) {
    if (!mounted) return; // ✅ Hindari setState saat tidak mounted
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.pink,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 250,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: const Center(
                child: Text(
                  'Arahkan kamera ke QR code pengguna lain',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
