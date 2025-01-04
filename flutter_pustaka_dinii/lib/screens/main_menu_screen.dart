import 'package:flutter/material.dart';
import 'anggota_screen.dart';
import 'buku_screen.dart';
import 'peminjaman_screen.dart';
import 'pengembalian_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Utama'),
        backgroundColor: Colors.green,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(25),
        crossAxisCount: 2,
        children: [
          _buildMenuItem(
            context,
            'Anggota',
            Icons.people,
            const AnggotaScreen(),
          ),
          _buildMenuItem(
            context,
            'Buku',
            Icons.book,
            const BukuScreen(),
          ),
          _buildMenuItem(
            context,
            'Peminjaman',
            Icons.assignment_turned_in,
            const PeminjamanScreen(),
          ),
          _buildMenuItem(
            context,
            'Pengembalian',
            Icons.assignment_return,
            const PengembalianScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String title, IconData icon, Widget destination) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.green),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
} 