import 'package:flutter/material.dart';

class LebihScreen extends StatefulWidget {
  const LebihScreen({super.key});

  @override
  State<LebihScreen> createState() => _LebihScreenState();
}

class _LebihScreenState extends State<LebihScreen> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    // Update Theme ketika mode gelap diaktifkan
    // ignore: unused_local_variable
    final theme = Theme.of(context);

    return Theme(
      data: _darkMode ? ThemeData.dark() : ThemeData.light(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.pink.shade600,
            foregroundColor: Colors.white,
            title: const Text('Menu Tambahan'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Pengaturan'),
                Tab(text: 'Keamanan'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              PengaturanTab(
                isDarkMode: _darkMode,
                onToggleDarkMode: (val) {
                  setState(() => _darkMode = val);
                },
              ),
              const KeamananTab(),
            ],
          ),
        ),
      ),
    );
  }
}

class PengaturanTab extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggleDarkMode;

  const PengaturanTab({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  State<PengaturanTab> createState() => _PengaturanTabState();
}

class _PengaturanTabState extends State<PengaturanTab> {
  String _bahasa = 'Indonesia';

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

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        SwitchListTile(
          title: const Text('Mode Gelap'),
          secondary: const Icon(Icons.dark_mode),
          value: widget.isDarkMode,
          onChanged: (val) {
            widget.onToggleDarkMode(val);
            _showSnackbar('Mode Gelap: ${val ? "Aktif" : "Nonaktif"}');
          },
        ),
        const Divider(),
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
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Tentang Aplikasi'),
          onTap: _showTentangAplikasiDialog,
        ),
      ],
    );
  }
}

class KeamananTab extends StatefulWidget {
  const KeamananTab({super.key});

  @override
  State<KeamananTab> createState() => _KeamananTabState();
}

class _KeamananTabState extends State<KeamananTab> {
  bool _verifikasi2Langkah = false;
  bool _sidikJari = true;
  final TextEditingController _passwordController = TextEditingController();

  void _showSnackbar(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
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
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        ListTile(
          leading: const Icon(Icons.lock_outline),
          title: const Text('Ganti Password'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: _showGantiPasswordDialog,
        ),
        const Divider(),
        SwitchListTile(
          title: const Text('Verifikasi 2 Langkah'),
          secondary: const Icon(Icons.verified_user),
          value: _verifikasi2Langkah,
          onChanged: (val) {
            setState(() => _verifikasi2Langkah = val);
            _showSnackbar('Verifikasi 2 Langkah ${val ? "Aktif" : "Nonaktif"}');
          },
        ),
        SwitchListTile(
          title: const Text('Gunakan Sidik Jari'),
          secondary: const Icon(Icons.fingerprint),
          value: _sidikJari,
          onChanged: (val) {
            setState(() => _sidikJari = val);
            _showSnackbar('Sidik Jari ${val ? "Diaktifkan" : "Dinonaktifkan"}');
          },
        ),
      ],
    );
  }
}
