import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/peminjaman_provider.dart';
import '../providers/pengembalian_provider.dart';

class PeminjamanPage extends StatelessWidget {
  const PeminjamanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6FA),
      appBar: AppBar(
        title: const Text('Daftar Peminjaman'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Color(0xFFAC66CC),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Consumer<PeminjamanProvider>(
        builder: (context, peminjamanProvider, child) {
          if (peminjamanProvider.allPeminjaman.isEmpty) {
            peminjamanProvider.initialData();
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFAC66CC)),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: peminjamanProvider.allPeminjaman.length,
            itemBuilder: (context, index) {
              final peminjaman = peminjamanProvider.allPeminjaman[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header dengan gambar buku
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(peminjaman.cover ?? ''),
                          fit: BoxFit.cover,
                          onError: (_, __) => const Icon(Icons.error),
                        ),
                      ),
                    ),
                    
                    // Informasi peminjaman
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            peminjaman.judulBuku ?? 'Judul tidak tersedia',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFAC66CC),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Icons.person,
                            'Peminjam',
                            peminjaman.namaAnggota,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.calendar_today,
                            'Tanggal Pinjam',
                            peminjaman.tanggalPinjam,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.assignment_return,
                            'Tanggal Kembali',
                            peminjaman.tanggalKembali,
                          ),
                          const SizedBox(height: 16),
                          
                          // Tombol kembalikan
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Konfirmasi'),
                                    content: const Text(
                                      'Apakah Anda yakin ingin mengembalikan buku ini?'
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text('Tidak'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: const Text('Ya'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true && context.mounted) {
                                  try {
                                    final pengembalianProvider = Provider.of<PengembalianProvider>(
                                      context, 
                                      listen: false
                                    );
                                    
                                    final result = await pengembalianProvider.addPengembalian(
                                      DateTime.now().toIso8601String().split('T')[0],
                                      peminjaman.id,
                                    );

                                    if (result != null && result['success'] && context.mounted) {
                                      await peminjamanProvider.initialData();
                                      
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Buku berhasil dikembalikan. ' +
                                              (result['terlambat'] > 0
                                                  ? 'Terlambat ${result['terlambat']} hari. Denda: Rp${result['denda']}'
                                                  : 'Tepat waktu.')
                                            ),
                                            backgroundColor: result['terlambat'] > 0 
                                                ? Colors.red 
                                                : const Color(0xFFAC66CC),
                                          ),
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Terjadi kesalahan saat mengembalikan buku'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFAC66CC),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text(
                                'Kembalikan Buku',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF5E6FA),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFAC66CC),
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 