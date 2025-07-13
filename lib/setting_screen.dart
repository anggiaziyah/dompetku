import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// PERUBAHAN DI SINI: Tambahkan 'hide Provider'
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
// Impor ThemeNotifier dari main.dart (sesuaikan path jika perlu)
import 'main.dart'; 

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final supabase = Supabase.instance.client;
  bool _isLoading = true;

  String username = '-';
  String email = '-';
  String currency = 'Rupiah';
  String country = 'Indonesia';
  String language = 'Indonesia';
  bool darkMode = false;

  @override
  void initState() {
    super.initState();
    // Memanggil _loadUserData setelah frame pertama selesai dibangun
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final data = await supabase
          .from('users')
          .select('username, currency, country, language, dark_mode')
          .eq('id', user.id)
          .single();

      if (mounted) {
        setState(() {
          username = data['username'] ?? '-';
          email = user.email ?? '-';
          currency = data['currency'] ?? 'Rupiah';
          country = data['country'] ?? 'Indonesia';
          language = data['language'] ?? 'Indonesia';
          darkMode = data['dark_mode'] ?? false;
          
          final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
          themeNotifier.setThemeMode(darkMode ? ThemeMode.dark : ThemeMode.light);

          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          email = user.email ?? '-';
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memuat data profile: ${e.toString()}')));

      }
    }
  }

  Future<void> _showEditDialog(
      String title, String initialValue, Function(String) onSave) async {
    final controller = TextEditingController(text: initialValue);
    final newValue = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ubah $title'),
        content: TextFormField(
          controller: controller,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(controller.text);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (newValue != null && newValue.isNotEmpty) {
      onSave(newValue);
    }
  }

  Future<void> _updateProfileField(String column, dynamic value) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    try {
      await supabase
          .from('users')
          .update({column: value}).eq('id', user.id);
      await _loadUserData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memperbarui $column: ${e.toString()}')));
      }
    } finally {
      if(mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  void _logout() async {
    await supabase.auth.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Pengaturan Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 8),
                const Text("Umum", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                _settingTile("Mata uang Bawaan", currency, () {
                  _showEditDialog("Mata Uang", currency, (newValue) {
                    _updateProfileField('currency', newValue);
                  });
                }),
                _settingTile("Negara", country, () {
                  _showEditDialog("Negara", country, (newValue) {
                    _updateProfileField('country', newValue);
                  });
                }),
                _settingTile("Bahasa", language, () {
                  _showEditDialog("Bahasa", language, (newValue) {
                    _updateProfileField('language', newValue);
                  });
                }),
                const SizedBox(height: 20),
                const Text("Pengaturan Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                _settingTile("Username", username, () {
                  _showEditDialog("Username", username, (newValue) {
                    _updateProfileField('username', newValue);
                  });
                }),
                _settingTile("Alamat Email", email, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Perubahan email harus melalui proses verifikasi. Fitur ini sedang dalam pengembangan.'))
                  );
                }),
                _darkModeSwitch(themeNotifier),
                _settingTile("App Versi", "v1.0.0", null),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Log Out", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
    );
  }

  Widget _darkModeSwitch(ThemeNotifier themeNotifier) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: SwitchListTile(
        value: themeNotifier.themeMode == ThemeMode.dark,
        onChanged: (val) {
          themeNotifier.setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
          _updateProfileField('dark_mode', val);
        },
        title: const Text("Mode Gelap"),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }

  Widget _settingTile(String title, String value, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Row(
              children: [
                Text(value, style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7)
                )),
                if (onTap != null) const SizedBox(width: 8),
                if (onTap != null) const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}