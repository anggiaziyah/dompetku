import 'package:dompetku/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KirimScreen extends StatefulWidget {
  @override
  _KirimScreenState createState() => _KirimScreenState();
}

class _KirimScreenState extends State<KirimScreen> {
  String selectedBank = 'GoPay';
  String jumlahKirim = '';
  final List<String> banks = ['GoPay', 'ShopeePay', 'DANA'];

  void _handleKeypadTap(String value) {
    setState(() {
      if (value == '⌫') {
        if (jumlahKirim.isNotEmpty) {
          jumlahKirim = jumlahKirim.substring(0, jumlahKirim.length - 1);
        }
      } else if (value != '.') {
        jumlahKirim += value;
      }
    });
  }

  Future<void> _kirimUang() async {
    if (jumlahKirim.isEmpty || jumlahKirim == '0') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan jumlah uang yang valid')),
      );
      return;
    }

    final supabase = Supabase.instance.client;
    final jumlahInt = int.tryParse(jumlahKirim) ?? 0;
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User belum login')),
      );
      return;
    }

    final userId = user.id;
    const angilinId = '51b91472-d565-4a4c-a1ad-a842b7314560';
    final catatan = 'Transfer ke Angilin via $selectedBank';

    try {
      final res = await supabase.rpc('transfer_uang', params: {
  'pengirim': userId,
  'penerima': angilinId,
  'jumlah': jumlahInt,
  'catatan': catatan,
}).execute();

if (res.error != null) {
  throw Exception(res.error!.message);
}


      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessScreen(amount: jumlahKirim),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal kirim uang: $e')),
      );
    }
  }

  String _formatCurrency(String angka) {
    final raw = angka.replaceAll(RegExp(r'\D'), '');
    if (raw.isEmpty) return '0';
    final num = int.parse(raw);
    return num.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Icon(Icons.person, size: 40),
              const Text("Angilin", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Text("5338-9049-8708-6105", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),
              Text(
                jumlahKirim.isEmpty ? "Rp 0" : "Rp ${_formatCurrency(jumlahKirim)}",
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedBank,
                    items: banks.map((String bank) {
                      return DropdownMenuItem<String>(
                        value: bank,
                        child: Text(bank),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedBank = newValue!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  itemCount: 12,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2,
                  ),
                  itemBuilder: (context, index) {
                    String text = '';
                    if (index < 9) text = '${index + 1}';
                    if (index == 9) text = '.';
                    if (index == 10) text = '0';
                    if (index == 11) text = '⌫';
                    return InkWell(
                      onTap: () => _handleKeypadTap(text),
                      child: Center(
                        child: Text(text, style: const TextStyle(fontSize: 24)),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _kirimUang,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade200,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Kirim", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on PostgrestResponse {
  get error => null;
}
