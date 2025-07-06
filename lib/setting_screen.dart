import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  String? _userEmail; // State untuk menyimpan email pengguna

  @override
  void initState() {
    super.initState();
    // Ambil email pengguna saat halaman dimuat
    _loadUserData();
  }

  // Fungsi untuk mengambil data pengguna dari Supabase
  void _loadUserData() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email;
      });
    }
  }

  // Fungsi untuk logout dengan aman
  Future<void> _signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      // Tangani error jika ada, misal: tidak ada koneksi internet
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal logout: ${e.toString()}")),
      );
    }

    if (mounted) {
      // Kembali ke halaman login dan hapus semua rute sebelumnya
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  // Fungsi untuk menampilkan snackbar placeholder
  void _showFeatureNotAvailable() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur ini belum tersedia.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEEEEE),
      body: SafeArea(
        child: Column(
          children: [
            // AppBar Custom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      // Gunakan pop untuk kembali ke halaman sebelumnya (Dashboard)
                      Navigator.of(context).pop();
                    },
                  ),
                  const Spacer(),
                  const Text(
                    "Pengaturan Profile",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48), // Placeholder untuk menyeimbangkan judul
                ],
              ),
            ),

            // Grup Pengaturan "Umum"
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _SettingItem(
                    title: "Mata uang Bawaan",
                    value: "Rupiah (IDR)",
                    onTap: _showFeatureNotAvailable,
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _SettingItem(
                    title: "Negara",
                    value: "Indonesia",
                    onTap: _showFeatureNotAvailable,
                  ),
                   const Divider(height: 1, indent: 16, endIndent: 16),
                  _SettingItem(
                    title: "Bahasa",
                    value: "Indonesia",
                    onTap: _showFeatureNotAvailable,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Grup Pengaturan "Profile"
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _SettingItem(
                    title: "Ubah Password",
                    onTap: _showFeatureNotAvailable,
                  ),
                   const Divider(height: 1, indent: 16, endIndent: 16),
                  // Menampilkan email pengguna yang sudah login
                  _SettingItem(
                    title: "Alamat Email",
                    value: _userEmail ?? "Memuat...",
                    onTap: _showFeatureNotAvailable,
                  ),
                   const Divider(height: 1, indent: 16, endIndent: 16),
                  // Item Mode Gelap dengan Switch
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Mode Gelap"),
                        Switch(
                          value: isDarkMode,
                          onChanged: (val) {
                            setState(() {
                              isDarkMode = val;
                            });
                            // Logika untuk mengubah tema aplikasi bisa ditambahkan di sini
                             _showFeatureNotAvailable();
                          },
                          activeColor: Colors.pink.shade600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Info Versi Aplikasi
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("App Versi"),
                  Text("v1.0.0"),
                ],
              ),
            ),

            const Spacer(),

            // Tombol Logout
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _signOut, // Panggil fungsi signOut
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Log Out", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget kustom untuk setiap baris pengaturan agar bisa diklik
class _SettingItem extends StatelessWidget {
  final String title;
  final String? value;
  final VoidCallback? onTap;

  const _SettingItem({required this.title, this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 15)),
            Row(
              children: [
                if (value != null)
                  Text(value!, style: const TextStyle(color: Colors.grey, fontSize: 15)),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 22),
              ],
            )
          ],
        ),
      ),
    );
  }
}
