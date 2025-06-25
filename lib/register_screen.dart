import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Container(
              decoration: const BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Masukkan email Anda', style: TextStyle(color: Colors.white)),
                  Text(
                    'Kami akan mengirimkan email untuk reset password',
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const TextField(decoration: InputDecoration(labelText: 'Nama Pengguna')),
            const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Buat password baru')),
            const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Konfirmasi password')),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Password harus mempunyai:',
                    style: TextStyle(color: Colors.green),
                  ),
                  Text('✔️ 8 sampai 20 huruf yang kuat'),
                  Text('✔️ Huruf, angka, dan karakter khusus yang kreatif'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // kembali ke login
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[300],
                minimumSize: const Size(double.infinity, 40),
              ),
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
