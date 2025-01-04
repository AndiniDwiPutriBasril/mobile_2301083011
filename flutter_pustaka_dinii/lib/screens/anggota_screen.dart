import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AnggotaScreen extends StatefulWidget {
  const AnggotaScreen({super.key});

  @override
  State<AnggotaScreen> createState() => _AnggotaScreenState();
}

class _AnggotaScreenState extends State<AnggotaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nimController = TextEditingController();
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  String _jenisKelamin = 'L';
  final ApiService _apiService = ApiService();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _apiService.tambahAnggota({
          'nim': _nimController.text,
          'nama': _namaController.text,
          'alamat': _alamatController.text,
          'jenis_kelamin': _jenisKelamin,
        });

        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data anggota berhasil ditambahkan')),
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
    _nimController.clear();
    _namaController.clear();
    _alamatController.clear();
    setState(() {
      _jenisKelamin = 'L';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Anggota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nimController,
                decoration: const InputDecoration(labelText: 'NIM'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'NIM tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(labelText: 'Alamat'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _jenisKelamin,
                decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
                items: const [
                  DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
                  DropdownMenuItem(value: 'P', child: Text('Perempuan')),
                ],
                onChanged: (value) {
                  setState(() {
                    _jenisKelamin = value!;
                  });
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