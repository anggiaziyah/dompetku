import 'package:dompetku/Screen/transaksi/kirim_screen.dart'; 
import 'package:dompetku/lebih_screen.dart';
import 'package:dompetku/pesan_screen.dart';
import 'package:dompetku/setting_screen.dart';
import 'package:dompetku/topup_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  int _saldo = 0;

  Future<void> _signOut() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, '/riwayat');
        break;
      case 2:
        _showProfileActions();
        break;
    }
  }

  void _showProfileActions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Lihat Profil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _signOut();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _getSaldo() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final response = await Supabase.instance.client
          .from('users')
          .select('saldo')
          .eq('id', user.id)
          .single();
      setState(() {
        _saldo = (response['saldo'] as num?)?.toInt() ?? 0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getSaldo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getSaldo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.pink.shade600,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                      .format(_saldo),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Saldo tersedia',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    actionButton(Icons.send, 'Kirim', () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => KirimScreen()),
                      );
                      _getSaldo();
                    }),
                    actionButton(Icons.account_balance_wallet, 'Top Up', () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TopupScreen()),
                      );
                      _getSaldo();
                    }),
                    actionButton(Icons.message, 'Pesan', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PesanScreen()),
                      );
                    }),
                    actionButton(Icons.more_horiz, 'Lebih', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LebihScreen()),
                      );
                    }),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Riwayat Transaksi',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),
                transactionTile('Menerima', 'Fiver1', '\$100.00 | 13.00 WIB'),
                historyItem('Devon Lane', '+\$1.200', '09:39 AM'),
                historyItem('Esther Howard', '+\$1.200', '09:39 AM'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink.shade600,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget actionButton(IconData icon, String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              child: Icon(icon, color: Colors.pink),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget transactionTile(String type, String name, String amount) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          type == 'Menerima' ? Icons.call_received : Icons.call_made,
          color: type == 'Menerima' ? Colors.green : Colors.red,
        ),
        title: Text(type),
        subtitle: Text(name),
        trailing: Text(
          amount,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget historyItem(String name, String amount, String time) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
      ),
      title: Text(name),
      subtitle: const Text('Transfer'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            amount,
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(time, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
