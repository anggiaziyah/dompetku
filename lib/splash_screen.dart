// lib/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Tunggu frame pertama selesai render sebelum navigasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthAndNavigate();
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    // Beri jeda agar splash screen terlihat
    await Future.delayed(const Duration(seconds: 2));

    // Cek sesi pengguna saat ini di Supabase
    final session = Supabase.instance.client.auth.currentSession;

    if (!mounted) return; // Pastikan widget masih ada di tree

    if (session != null) {
      // Jika ada sesi, langsung ke dashboard
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      // Jika tidak ada sesi, ke halaman login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade600, Colors.grey.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Container(
            width: 315,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'SELAMAT DATANG\nDI DOMPETKU',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                CircularProgressIndicator(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}