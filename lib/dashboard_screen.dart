import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEEEEE),
      body: Column(
        children: [
          // Header Saldo
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFE91E63),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Rp 325.550.000",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Saldo tersedia",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _DashboardIcon(
                        title: "Kirim", icon: Icons.send, onTap: () {}),
                    _DashboardIcon(
                        title: "Isi Ulang", icon: Icons.add, onTap: () {}),
                    _DashboardIcon(
                        title: "Pesan", icon: Icons.message, onTap: () {}),
                    _DashboardIcon(
                        title: "Lebih", icon: Icons.more_horiz, onTap: () {}),
                  ],
                ),
              ],
            ),
          ),

          // Riwayat Transaksi
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: const [
                Text("Riwayat Transaksi",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 10),
                _TransactionItem(
                    title: "Fiver", amount: "Rp200.000", type: "Menerima"),
                _TransactionItem(
                    title: "Shoope", amount: "Rp35.000", type: "Kirim"),
                _TransactionItem(
                    title: "Fiver1", amount: "\$100.00", type: "Menerima"),
                _TransactionItem(
                    title: "Devon Lane", amount: "\$1.200", type: "Transfer"),
                _TransactionItem(
                    title: "Esther Howard",
                    amount: "\$1.200",
                    type: "Transfer"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardIcon extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardIcon(
      {required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(icon, color: Colors.pink),
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final String title;
  final String amount;
  final String type;

  const _TransactionItem(
      {required this.title, required this.amount, required this.type});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(type),
        subtitle: Text(title),
        trailing: Text(amount),
      ),
    );
  }
}
