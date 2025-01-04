import 'package:flutter/material.dart';
import '../services/api_service.dart';

class BukuScreen extends StatefulWidget {
  const BukuScreen({super.key});

  @override
  State<BukuScreen> createState() => _BukuScreenState();
}

class _BukuScreenState extends State<BukuScreen> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _pengarangController = TextEditingController();
  final _penerbitController = TextEditingController();
  final _tahunTerbitController = TextEditingController();
  final ApiService _apiService = ApiService();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _apiService.tambahBuku({
          'judul': _judulController.text,
          'pengarang': _pengarangController.text,
          'penerbit': _penerbitController.text,
          'tahun_terbit': _tahunTerbitController.text,
        });

        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data buku berhasil ditambahkan')),
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
    _judulController.clear();
    _pengarangController.clear();
    _penerbitController.clear();
    _tahunTerbitController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Buku'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(labelText: 'Judul Buku'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul buku tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _pengarangController,
                decoration: const InputDecoration(labelText: 'Pengarang'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pengarang tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _penerbitController,
                decoration: const InputDecoration(labelText: 'Penerbit'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Penerbit tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tahunTerbitController,
                decoration: const InputDecoration(labelText: 'Tahun Terbit'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tahun terbit tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 