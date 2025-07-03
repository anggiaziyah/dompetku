// lib/main.dart

import 'package:dompetku/dashboard_screen.dart';
import 'package:dompetku/kirim_screen.dart';
import 'package:dompetku/login_screen.dart';
import 'package:dompetku/register_screen.dart';
import 'package:dompetku/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // Pastikan semua widget siap sebelum menjalankan aplikasi
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://wzrrcdpobmurcsxkabeu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6cnJjZHBvYm11cmNzeGthYmV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTEwOTAwODAsImV4cCI6MjA2NjY2NjA4MH0.c2haAReE4mK94riwtEvo7E_JaQduLn5cMryqXRbvZvU',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DompetKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink.shade600),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey.shade100,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.pink.shade600,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      // Rute awal saat aplikasi pertama kali dibuka
      initialRoute: '/',
      // Daftar semua rute (halaman) yang ada di aplikasi
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const SignupScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/kirim': (context) => const TransferPage(),
      },
    );
  }
}