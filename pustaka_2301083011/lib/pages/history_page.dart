import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pengembalian_provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    // Fetch data saat halaman dibuka
    if (mounted) {
      Future.microtask(() {
        Provider.of<PengembalianProvider>(context, listen: false).initialData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6FA),
      appBar: AppBar(
        title: const Text('History Pengembalian'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Color(0xFFAC66CC),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Consumer<PengembalianProvider>(
        builder: (context, pengembalianProvider, child) {
          final pengembalianList = pengembalianProvider.allPengembalian;

          if (pengembalianList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Color(0xFFAC66CC).withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada history pengembalian',
                    style: TextStyle(
                      color: Color(0xFFAC66CC),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pengembalianList.length,
            itemBuilder: (context, index) {
              final pengembalian = pengembalianList[index];
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
                    // Header dengan status dan tanggal
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5B8F4).withOpacity(0.3),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Color(0xFFAC66CC),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Dikembalikan',
                                style: TextStyle(
                                  color: Color(0xFFAC66CC),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            pengembalian.tanggalDikembalikan,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Informasi buku
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pengembalian.judulBuku ?? 'Judul tidak tersedia',
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
                            pengembalian.namaAnggota ?? 'Tidak ada nama',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.attach_money,
                            'Denda',
                            'Rp${pengembalian.denda}',
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