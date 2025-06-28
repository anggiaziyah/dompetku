import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart'; // pastikan file ini ada

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://wzrrcdpobmurcsxkabeu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6cnJjZHBvYm11cmNzeGthYmV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTEwOTAwODAsImV4cCI6MjA2NjY2NjA4MH0.c2haAReE4mK94riwtEvo7E_JaQduLn5cMryqXRbvZvU', // ganti dengan anon key kamu
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DompetKu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) {
          final session = Supabase.instance.client.auth.currentSession;
          if (session == null) {
            return const LoginScreen(); // belum login
          } else {
            return const MyHomePage(title: 'DompetKu'); // sudah login
          }
        },
        '/home': (context) => const MyHomePage(title: 'DompetKu'),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Future<void> fetchTransactionCount() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      print('Belum login');
      return;
    }

    final response = await Supabase.instance.client
        .from('transactions')
        .select()
        .eq('user_id', user.id);

    setState(() {
      _counter = response.length;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTransactionCount();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      Supabase.instance.client.from('transactions').insert({
        'user_id': user.id,
        'tipe': 'masuk',
        'metode': 'shopeepay',
        'jumlah': 10000,
        'deskripsi': 'Dummy transaksi',
      });
    }
  }

  void _logout() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Jumlah transaksi di Supabase:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Tambah Dummy Transaksi',
        child: const Icon(Icons.add),
      ),
    );
  }
}
