
import 'package:flutter/material.dart';

class LebihScreen extends StatefulWidget {
  const LebihScreen({super.key});

  @override
  State<LebihScreen> createState() => _LebihScreenState();
}

class _LebihScreenState extends State<LebihScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Ada 2 tab: Pengaturan dan Keamanan
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink.shade600,
          title: const Text('Menu Tambahan'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pengaturan'),
              Tab(text: 'Keamanan'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PengaturanTab(),
            KeamananTab(),
          ],
        ),
      ),
    );
  }
}

class PengaturanTab extends StatefulWidget {
  const PengaturanTab({super.key});

  @override
  State<PengaturanTab> createState() => _PengaturanTabState();
}

class _PengaturanTabState extends State<PengaturanTab> {
  bool _darkMode = false;
  String _bahasa = 'Indonesia';

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SwitchListTile(
          title: const Text('Mode Gelap'),
          value: _darkMode,
          onChanged: (val) {
            setState(() {
              _darkMode = val;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Mode Gelap: ${val ? "Aktif" : "Nonaktif"}'),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Bahasa'),
          subtitle: Text(_bahasa),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (_) {
                return ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      title: const Text('Indonesia'),
                      onTap: () {
                        setState(() => _bahasa = 'Indonesia');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text('English'),
                      onTap: () {
                        setState(() => _bahasa = 'English');
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Versi Aplikasi'),
          subtitle: const Text('1.0.0'),
        ),
      ],
    );
  }
}

class KeamananTab extends StatelessWidget {
  const KeamananTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.lock),
          title: const Text('Ganti Password'),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Navigasi ke ganti password')),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.verified_user),
          title: const Text('Verifikasi 2 Langkah'),
          trailing: Switch(value: false, onChanged: (_) {}),
        ),
        ListTile(
          leading: const Icon(Icons.fingerprint),
          title: const Text('Gunakan Sidik Jari'),
          trailing: Switch(value: true, onChanged: (_) {}),
        ),
      ],
    );
  }
}
