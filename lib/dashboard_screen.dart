import 'package:flutter/material.dart';
import 'kirim_screen.dart';
import 'topup_screen.dart';
import 'success_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DompetKu Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _buildMenuItem(
              context,
              icon: Icons.send,
              label: 'Kirim',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => KirimScreen()),
                );
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.account_balance_wallet,
              label: 'Isi Ulang',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TopupScreen()),
                );
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.message,
              label: 'Pesan',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SuccessScreen(amount: '20000'),
                  ),
                );
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.settings,
              label: 'Settings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.deepPurple),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
