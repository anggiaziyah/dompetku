import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TopUpScreen extends StatefulWidget {
  @override
  _TopUpScreenState createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final TextEditingController _amountController = TextEditingController();
  String? selectedMethod;

  final List<String> paymentMethods = ['Dana', 'GoPay', 'OVO', 'ShopeePay'];
  final Map<String, IconData> methodIcons = {
    'Dana': Icons.account_balance,
    'GoPay': Icons.credit_card,
    'OVO': Icons.phone_android,
    'ShopeePay': Icons.account_balance_wallet,
  };

  int get amount {
    final raw = _amountController.text.replaceAll('.', '').replaceAll(',', '');
    return int.tryParse(raw) ?? 0;
  }

  String formatRupiah(int value) {
    final formatter = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(value);
  }

  Future<void> topUpSaldo({
    required int jumlahTopup,
    required String metode,
  }) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception("User belum login");

    final userId = user.id;

    // 1. Tambahkan data ke tabel topup
    await supabase.from('topup').insert({
      'id_user': userId,
      'jumlah_topup': jumlahTopup,
      'metode': metode,
      'status': 'sukses',
    });

    // 2. Ambil saldo lama dari user_data
    final result = await supabase
        .from('user_data')
        .select('saldo')
        .eq('id', userId)
        .single();

    final saldoLama = (result['saldo'] as num?) ?? 0;
    final saldoBaru = saldoLama + jumlahTopup;

    // 3. Update saldo user_data
    await supabase
        .from('user_data')
        .update({'saldo': saldoBaru})
        .eq('id', userId);

    // 4. Catat ke tabel transaksi
    await supabase.from('transaksi').insert({
      'id_user': userId,
      'tipe_transaksi': 'topup',
      'nominal': jumlahTopup,
      'keterangan': 'Top up via $metode',
    });

    print("✅ Top up sukses. Saldo sekarang: $saldoBaru");
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: Text("Isi Ulang", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [Icon(Icons.more_vert, color: Colors.black)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Metode Pembayaran", style: TextStyle(fontSize: 14)),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedMethod,
                  hint: Text("Pilih metode"),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down),
                  items: paymentMethods.map((method) {
                    return DropdownMenuItem<String>(
                      value: method,
                      child: Row(
                        children: [
                          Icon(methodIcons[method], color: Colors.purple),
                          SizedBox(width: 10),
                          Text(method),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMethod = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 30),

            Text("Jumlah", style: TextStyle(fontSize: 14)),
            SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: 'Rp ',
                hintText: 'Masukkan nominal',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: 20),

            Text(
              "Total: ${formatRupiah(amount)}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),

            ElevatedButton(
              onPressed: (amount > 0 && selectedMethod != null)
                  ? () async {
                      try {
                        await topUpSaldo(
                          jumlahTopup: amount,
                          metode: selectedMethod!,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Top up berhasil!")),
                        );
                        _amountController.clear();
                        setState(() {
                          selectedMethod = null;
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Gagal top up: $e")),
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade300,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text("Isi Ulang", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
