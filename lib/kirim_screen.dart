import 'package:flutter/material.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  String selectedBank = 'GoPay';
  final List<String> banks = ['GoPay', 'ShopeePay', 'DANA'];
  String amount = 'Rp 5.000.000'; // Contoh data

  void _onKeyPress(String value) {
    // Logika untuk keypad bisa ditambahkan di sini
    print("Key pressed: $value");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF1F3),
      appBar: AppBar(
        title: const Text('Kirim Uang'),
        backgroundColor: Colors.pink.shade600,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Bagian penerima
              const Column(
                children: [
                  Icon(Icons.person, size: 40),
                  Text("Anilin",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("5338-9049-8708-6105",
                      style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 20),
                ],
              ),

              // Jumlah
              const Text("Jumlah Transfer", style: TextStyle(fontSize: 16)),
              Text(amount,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // Dropdown Bank
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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

              // Keypad
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 12,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.8,
                  ),
                  itemBuilder: (context, index) {
                    String text = '';
                    if (index < 9) text = '${index + 1}';
                    if (index == 9) text = '.';
                    if (index == 10) text = '0';
                    if (index == 11) text = '⌫';
                    return InkWell(
                      onTap: () => _onKeyPress(text),
                      borderRadius: BorderRadius.circular(30),
                      child: Center(
                          child: Text(text, style: const TextStyle(fontSize: 24))),
                    );
                  },
                ),
              ),

              // Tombol Kirim
              ElevatedButton(
                onPressed: () {
                  // Aksi kirim
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fitur kirim sedang dalam pengembangan.')));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade200,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
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