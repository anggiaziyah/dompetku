
import 'package:dompetku/dashboard_screen.dart';
import 'package:dompetku/kirim_screen.dart';
import 'package:dompetku/login_screen.dart';
import 'package:dompetku/pesan_screen.dart';
import 'package:dompetku/register_screen.dart';
import 'package:dompetku/riwayat_screen.dart';

import 'package:dompetku/settings_screen.dart';
import 'package:dompetku/splash_screen.dart';
import 'package:dompetku/success_screen.dart';
import 'package:dompetku/topup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



// SuccessScreen tidak perlu di-import di sini karena dipanggil via MaterialPageRoute

void main() async {
  // Pastikan semua binding Flutter siap
  WidgetsFlutterBinding.ensureInitialized();


  // Mengatur orientasi aplikasi hanya potrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://dhglvbfvjepnjswotubq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRoZ2x2YmZ2amVwbmpzd290dWJxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE3MDE5NzUsImV4cCI6MjA2NzI3Nzk3NX0.t6lyL3yWbHcePj7_9tE3vXgSIpWzX7g-o8ZZnrxndeE',
  );

  // Inisialisasi format tanggal untuk bahasa Indonesia
  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Dompet App',
      debugShowCheckedModeBanner: false,
      // Tema aplikasi disesuaikan dengan desain yang ada (warna pink/rose)
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.grey.shade50,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE91E63)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE91E63),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      // Rute awal aplikasi
      initialRoute: '/',
      // Daftar semua rute yang bisa dinavigasi menggunakan nama
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const SignupScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/pesan': (context) => const PesanScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/kirim': (context) => KirimScreen(),
        '/success': (context) => const SuccessScreen(amount: '',),
        '/riwayat': (context) => RiwayatScreen(),
        'topup': (context) => TopUpScreen(),
      },
    );
  }
}
