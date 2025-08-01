import 'package:flutter/material.dart';

class LebihScreen extends StatefulWidget {
  const LebihScreen({super.key});

  @override
  State<LebihScreen> createState() => _LebihScreenState();
}

class _LebihScreenState extends State<LebihScreen> {
  bool _darkMode = false;
  String _bahasa = 'Indonesia';
  final TextEditingController _passwordController = TextEditingController();

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showTentangAplikasiDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tentang Aplikasi'),
        content: const Text(
          'Aplikasi DompetKu\n\nVersi: 1.0.0\nDibuat untuk mempermudah transaksi digital pengguna.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showGantiPasswordDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ganti Password'),
        content: TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Password Baru'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              String passwordBaru = _passwordController.text.trim();
              Navigator.pop(context);
              _passwordController.clear();
              if (passwordBaru.isNotEmpty) {
                _showSnackbar('Password berhasil diubah!');
              } else {
                _showSnackbar('Password tidak boleh kosong.');
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _darkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink.shade600,
          foregroundColor: Colors.white,
          title: const Text('Menu Tambahan'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            // Mode Gelap
            SwitchListTile(
              title: const Text('Mode Gelap'),
              secondary: const Icon(Icons.dark_mode),
              value: _darkMode,
              onChanged: (val) {
                setState(() => _darkMode = val);
                _showSnackbar('Mode Gelap: ${val ? "Aktif" : "Nonaktif"}');
              },
            ),
            const Divider(),

            // Bahasa
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Bahasa'),
              subtitle: Text(_bahasa),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        const Text('Pilih Bahasa',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ListTile(
                          title: const Text('Indonesia'),
                          onTap: () {
                            setState(() => _bahasa = 'Indonesia');
                            Navigator.pop(context);
                            _showSnackbar('Bahasa diubah ke Indonesia');
                          },
                        ),
                        ListTile(
                          title: const Text('English'),
                          onTap: () {
                            setState(() => _bahasa = 'English');
                            Navigator.pop(context);
                            _showSnackbar('Language changed to English');
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const Divider(),

            // Tentang Aplikasi
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Tentang Aplikasi'),
              onTap: _showTentangAplikasiDialog,
            ),
            const Divider(),

            // Ganti Password
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Ganti Password'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _showGantiPasswordDialog,
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
