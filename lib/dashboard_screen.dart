import 'package:flutter/material.dart';

class DashboardScreen
 extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.pink.shade600,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rp 325.550.000',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Saldo tersedia',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    actionButton(Icons.send, 'Kirimmmmmmmmmm'),
                    actionButton(Icons.add, 'Isi Ulang'),
                    actionButton(Icons.receipt, 'Tagihan'),
                    actionButton(Icons.more_horiz, 'Lebih'),
                  ],
                )
              ],
            ),
          ),

          // Riwayat Transaksi
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Riwayat Transaksi',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      'Lihat semua',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                transactionTile('Menerima', 'Fiver', 'Rp 200.000'),
                transactionTile('Kirim', 'Shoope', 'Rp 35.000'),
                transactionTile('Menerima', 'Fiver1', '\$100.00 | 13.00 WIB'),
                SizedBox(height: 16),
                historyItem('Devon Lane', '+\$1.200', '09:39 AM'),
                historyItem('Esther Howard', '+\$1.200', '09:39 AM'),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget actionButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white,
          child: Icon(icon, color: Colors.pink),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }

  Widget transactionTile(String type, String name, String amount) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          type == 'Menerima' ? Icons.call_received : Icons.call_made,
          color: type == 'Menerima' ? Colors.green : Colors.red,
        ),
        title: Text('$type'),
        subtitle: Text(name),
        trailing: Text(
          amount,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget historyItem(String name, String amount, String time) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
      ),
      title: Text(name),
      subtitle: Text('Transfer'),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            amount,
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(time, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
