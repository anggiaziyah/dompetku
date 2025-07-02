import 'package:flutter/material.dart';

class TopupScreen extends StatefulWidget {
  @override
  _TopupScreenState createState() => _TopupScreenState();
}

class _TopupScreenState extends State<TopupScreen> {
  String _amount = '';

  void _onKeyPressed(String value) {
    setState(() {
      if (value == 'delete') {
        if (_amount.isNotEmpty) {
          _amount = _amount.substring(0, _amount.length - 1);
        }
      } else {
        _amount += value;
      }
    });
  }

  String get formattedAmount {
    if (_amount.isEmpty) return 'Rp 0';
    String number = _amount.replaceAll('.', '');
    return 'Rp ' + number.replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Isi Ulang'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shopeepay
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Transaksi Terakhir", style: TextStyle(fontSize: 16)),
          ),
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFE0E7FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.account_balance_wallet, color: Colors.black),
            ),
            title: Text("ShopeePay"),
            subtitle: Text("**** **** 7576"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),

          // Jumlah
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Jumlah", style: TextStyle(fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              formattedAmount,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),

          Spacer(),

          // Keyboard
          GridView.count(
            shrinkWrap: true,
            padding: EdgeInsets.all(16),
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              ...List.generate(9, (index) {
                return _buildKey((index + 1).toString());
              }),
              _buildKey('.'),
              _buildKey('0'),
              _buildKey('delete', isDelete: true),
            ],
          ),

          // Tombol isi ulang
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // aksi isi ulang nanti ditambahkan
                  print("Isi ulang: $_amount");
                },
                child: Text('isi ulang'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue[200],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String value, {bool isDelete = false}) {
    return GestureDetector(
      onTap: () => _onKeyPressed(isDelete ? 'delete' : value),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: isDelete
            ? Icon(Icons.backspace_outlined)
            : Text(
                value,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
