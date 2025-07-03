import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0; // Untuk Bottom Navigation

  // Fungsi untuk logout
  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Di sini Anda bisa menambahkan navigasi untuk item lain
    // Contoh:
    if (index == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Halaman Riwayat belum tersedia.')),
      );
    } else if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Halaman Profil belum tersedia.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DompetKu'),
        automaticallyImplyLeading: false, // Menghilangkan tombol back
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          )
        ],
      ),
      body: Column(
        children: [
          // Bagian Header Saldo
          Container(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rp 325.550.000',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Saldo tersedia',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    actionButton(Icons.send, 'Kirim', () {
                      Navigator.pushNamed(context, '/kirim');
                    }),
                    actionButton(Icons.add, 'Isi Ulang', () {}),
                    actionButton(Icons.receipt, 'Tagihan', () {}),
                    actionButton(Icons.more_horiz, 'Lebih', () {}),
                  ],
                )
              ],
            ),
          ),

          // Riwayat Transaksi
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Riwayat Transaksi',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      'Lihat semua',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                transactionTile('Menerima', 'Fiver', 'Rp 200.000'),
                transactionTile('Kirim', 'Shoope', 'Rp 35.000'),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.pink.shade600,
        unselectedItemColor: Colors.grey.shade500,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
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
      ),
    );
  }

  Widget actionButton(IconData icon, String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.pink.withOpacity(0.1),
            child: Icon(icon, color: Colors.pink.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.black87),
          )
        ],
      ),
    );
  }

  Widget transactionTile(String type, String name, String amount) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
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
}