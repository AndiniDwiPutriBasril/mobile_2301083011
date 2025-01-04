import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class PeminjamanScreen extends StatefulWidget {
  const PeminjamanScreen({super.key});

  @override
  State<PeminjamanScreen> createState() => _PeminjamanScreenState();
}

class _PeminjamanScreenState extends State<PeminjamanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _anggotaController = TextEditingController();
  final _bukuController = TextEditingController();
  DateTime _tanggalPinjam = DateTime.now();
  DateTime _tanggalKembali = DateTime.now().add(const Duration(days: 7));
  final ApiService _apiService = ApiService();

  Future<void> _selectDate(BuildContext context, bool isPinjam) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isPinjam ? _tanggalPinjam : _tanggalKembali,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        if (isPinjam) {
          _tanggalPinjam = picked;
        } else {
          _tanggalKembali = picked;
        }
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _apiService.tambahPeminjaman({
          'anggota': _anggotaController.text,
          'buku': _bukuController.text,
          'tanggal_pinjam': DateFormat('yyyy-MM-dd').format(_tanggalPinjam),
          'tanggal_kembali': DateFormat('yyyy-MM-dd').format(_tanggalKembali),
        });

        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Peminjaman berhasil ditambahkan')),
          );
          _clearForm();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  void _clearForm() {
    _anggotaController.clear();
    _bukuController.clear();
    setState(() {
      _tanggalPinjam = DateTime.now();
      _tanggalKembali = DateTime.now().add(const Duration(days: 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peminjaman Buku'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _anggotaController,
                decoration: const InputDecoration(labelText: 'ID Anggota'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ID Anggota tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bukuController,
                decoration: const InputDecoration(labelText: 'ID Buku'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ID Buku tidak boleh kosong';
                  }
                  return null;
                },
              ),
              ListTile(
                title: const Text('Tanggal Pinjam'),
                subtitle: Text(DateFormat('dd-MM-yyyy').format(_tanggalPinjam)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, true),
              ),
              ListTile(
                title: const Text('Tanggal Kembali'),
                subtitle: Text(DateFormat('dd-MM-yyyy').format(_tanggalKembali)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, false),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Simpan Peminjaman'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 