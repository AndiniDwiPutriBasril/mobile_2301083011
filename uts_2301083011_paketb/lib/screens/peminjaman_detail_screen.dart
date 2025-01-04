import 'package:flutter/material.dart';
import '../models/peminjaman.dart';

class PeminjamanDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final peminjaman = ModalRoute.of(context)!.settings.arguments as Peminjaman;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Peminjaman'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard('Informasi Umum', [
                _buildInfoRow('Kode', peminjaman.kode),
                _buildInfoRow('Nama', peminjaman.nama),
                _buildInfoRow('Kode Peminjaman', peminjaman.kodePeminjaman),
                _buildInfoRow('Tanggal', peminjaman.tanggal.toString()),
              ]),
              SizedBox(height: 16),
              _buildInfoCard('Informasi Nasabah', [
                _buildInfoRow('Kode Nasabah', peminjaman.kodeNasabah),
                _buildInfoRow('Nama Nasabah', peminjaman.namaNasabah),
              ]),
              SizedBox(height: 16),
              _buildInfoCard('Detail Pinjaman', [
                _buildInfoRow('Jumlah Pinjaman', peminjaman.jumlahPinjaman.toString()),
                _buildInfoRow('Lama Pinjaman', '${peminjaman.lamaPinjaman} bulan'),
                _buildInfoRow('Bunga', '${peminjaman.bunga}%'),
                _buildInfoRow('Angsuran Pokok', peminjaman.angsuranPokok.toString()),
                _buildInfoRow('Bunga Per Bulan', peminjaman.bungaPerBulan.toString()),
                _buildInfoRow('Angsuran Per Bulan', peminjaman.angsuranPerBulan.toString()),
                _buildInfoRow('Total Hutang', peminjaman.totalHutang.toString()),
              ]),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                  },
                  child: Text('Kembali ke Menu Utama'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }
}
