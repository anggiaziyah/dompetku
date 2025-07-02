import 'package:flutter/material.dart';

class DompetDigitalApp extends StatefulWidget {
  @override
  State<DompetDigitalApp> createState() => _DompetDigitalAppState();
}

class _DompetDigitalAppState extends State<DompetDigitalApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: KirimScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class KirimScreen extends StatefulWidget {
  @override
  _KirimScreenState createState() => _KirimScreenState();
}

class _KirimScreenState extends State<KirimScreen> {
  String selectedBank = 'GoPay';

  final List<String> banks = ['GoPay', 'ShopeePay', 'DANA'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF1F3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Bagian penerima
              Column(
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
              Text("ATM", style: TextStyle(fontSize: 16)),
              Text("Rp 5.000.000",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),

              SizedBox(height: 20),

              // Dropdown Bank
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

              SizedBox(height: 20),

              // Keypad
              Expanded(
                child: GridView.builder(
                  itemCount: 12,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                      onTap: () {},
                      child: Center(
                          child: Text(text, style: TextStyle(fontSize: 24))),
                    );
                  },
                ),
              ),

              // Tombol Kirim
              ElevatedButton(
                onPressed: () {
                  // aksi kirim
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade200,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Kirim", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
