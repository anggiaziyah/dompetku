import 'package:dompetku/Screen/home/dashboard_screen.dart';
import 'package:dompetku/Screen/splash/splash_screen.dart';
import 'package:dompetku/Screen/transaksi/kirim_screen.dart';
import 'package:dompetku/pesan_screen.dart';
import 'package:dompetku/riwayat_screen.dart';
import 'package:dompetku/ScanQR_screen.dart';
import 'package:dompetku/setting_screen.dart';
import 'package:dompetku/success_screen.dart';
import 'package:dompetku/topup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
// PERUBAHAN DI SINI: Tambahkan 'hide Provider'
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;

// Import semua halaman yang akan digunakan
import 'Screen/auth/login_screen.dart';
import 'Screen/auth/signup_screen.dart';

// Kelas ThemeNotifier tetap sama
class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode;

  ThemeNotifier(this._themeMode);

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void toggleTheme(bool val) {}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Supabase.initialize(
    url: 'https://kbziuovdgpzvsmkztwvs.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imtieml1b3ZkZ3B6dnNta3p0d3ZzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTIwNDc5MzgsImV4cCI6MjA2NzYyMzkzOH0.q8l-wPzjpiy-obmZrnTVQD7WTLKxGCecFS64Nbx14Bw',
  );

  await initializeDateFormatting('id_ID', null);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(ThemeMode.light),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'My Dompet App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.grey.shade50,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE91E63),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE91E63),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE91E63),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      themeMode: themeNotifier.themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const SignupScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/pesan': (context) =>  PesanScreen(),
        '/settings': (context) => const SettingScreen(),
        '/kirim': (context) => KirimScreen(penerimaId: '', username: '', namaLengkap: '',),
        '/success': (context) => SuccessScreen(
              amount: '',
            ),
        '/riwayat': (context) => RiwayatScreen(),
        'topup': (context) => TopupScreen(),
        '/scanqr': (context) => ScanQRScreen(),
        
      },
    );
  }
}
