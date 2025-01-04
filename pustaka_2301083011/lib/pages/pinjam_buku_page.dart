import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/buku.dart';
import '../providers/peminjaman_provider.dart';
import '../providers/anggota_provider.dart';

class PinjamBukuPage extends StatefulWidget {
  final Buku buku;
  const PinjamBukuPage({super.key, required this.buku});

  @override
  State<PinjamBukuPage> createState() => _PinjamBukuPageState();
}

class _PinjamBukuPageState extends State<PinjamBukuPage> {
  DateTime _tanggalPinjam = DateTime.now();
  DateTime _tanggalKembali = DateTime.now().add(const Duration(days: 7));
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context, bool isPinjam) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isPinjam) {
          _tanggalPinjam = picked;
          // Set tanggal kembali otomatis 7 hari setelah tanggal pinjam
          _tanggalKembali = picked.add(const Duration(days: 7));
        } else {
          _tanggalKembali = picked;
        }
      });
    }
  }

  Future<void> _handlePinjam() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final anggotaProvider = Provider.of<AnggotaProvider>(context, listen: false);
      final currentAnggota = anggotaProvider.currentAnggota;

      if (currentAnggota == null) {
        throw Exception('Silakan login terlebih dahulu');
      }

      final peminjamanProvider = Provider.of<PeminjamanProvider>(context, listen: false);
      
      // Format tanggal dengan benar
      final tanggalPinjam = _tanggalPinjam.toIso8601String().split('T')[0];
      final tanggalKembali = _tanggalKembali.toIso8601String().split('T')[0];

      final success = await peminjamanProvider.addPeminjaman(
        tanggalPinjam,
        tanggalKembali,
        currentAnggota.id,
        widget.buku.idBuku,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Peminjaman buku berhasil'),
            backgroundColor: Color(0xFFAC66CC),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Gagal melakukan peminjaman buku');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Tambahkan error handling untuk image loading
  Widget _buildBookCover() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        widget.buku.cover,
        width: 100,
        height: 150,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 100,
            height: 150,
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFAC66CC)),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 100,
            height: 150,
            color: Colors.grey[200],
            child: const Icon(
              Icons.broken_image,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final anggotaProvider = Provider.of<AnggotaProvider>(context);
    final currentAnggota = anggotaProvider.currentAnggota;

    return Scaffold(
      backgroundColor: const Color(0xFFF5E6FA),
      appBar: AppBar(
        title: const Text('Pinjam Buku'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Color(0xFFAC66CC),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Detail Buku
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cover Buku
                    _buildBookCover(),
                    const SizedBox(width: 16),
                    // Info Buku
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.buku.judul,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFAC66CC),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.buku.pengarang,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.buku.penerbit,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Form Peminjaman
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Peminjaman',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFAC66CC),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Tanggal Pinjam
                    InkWell(
                      onTap: () => _selectDate(context, true),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFAC66CC).withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Color(0xFFAC66CC),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tanggal Pinjam',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  _tanggalPinjam.toLocal().toString().split(' ')[0],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Tanggal Kembali
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFAC66CC).withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFFF5E6FA).withOpacity(0.5),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.assignment_return,
                            color: Color(0xFFAC66CC),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tanggal Kembali',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                _tanggalKembali.toLocal().toString().split(' ')[0],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Pinjam
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handlePinjam,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAC66CC),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Pinjam Buku',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 