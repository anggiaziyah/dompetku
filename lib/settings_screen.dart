import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String username = '';
  String email = '';
  bool darkMode = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user != null) {
      final data = await supabase
          .from('users')
          .select('username, email')
          .eq('id', user.id)
          .single();

      setState(() {
        username = data['username'] ?? '-';
        email = data['email'] ?? '-';
      });
    }
  }

  void _logout() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Pengaturan Profile', style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("Umum", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildTile("Mata uang Bawaan", "Rupiah"),
            _buildTile("Negara", "Indonesia"),
            _buildTile("Bahasa", "Indonesia"),
            const SizedBox(height: 20),

            const Text("Pengaturan Profile", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildTile("Username", username),
            _buildTile("Alamat Email", email),

            SwitchListTile(
              value: darkMode,
              onChanged: (val) {
                setState(() {
                  darkMode = val;
                });
              },
              title: const Text("Mode Gelap"),
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            ),

            const SizedBox(height: 10),
            _buildTile("App Versi", "v1.0.0"),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Log Out", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTile(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
