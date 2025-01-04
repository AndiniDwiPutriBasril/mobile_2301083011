import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class PengembalianScreen extends StatefulWidget {
  const PengembalianScreen({super.key});

  @override
  State<PengembalianScreen> createState() => _PengembalianScreenState();
}

class _PengembalianScreenState extends State<PengembalianScreen> {
  final _formKey = GlobalKey<FormState>();
  final _peminjamanController = TextEditingController();
  DateTime _tanggalDikembalikan = DateTime.now();
  final ApiService _apiService = ApiService();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalDikembalikan,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        _tanggalDikembalikan = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _apiService.tambahPengembalian({
          'peminjaman': _peminjamanController.text,
          'tanggal_dikembalikan': DateFormat('yyyy-MM-dd').format(_tanggalDikembalikan),
        });

        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pengembalian berhasil dicatat')),
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
    _peminjamanController.clear();
    setState(() {
      _tanggalDikembalikan = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengembalian Buku'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _peminjamanController,
                decoration: const InputDecoration(labelText: 'ID Peminjaman'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ID Peminjaman tidak boleh kosong';
                  }
                  return null;
                },
              ),
              ListTile(
                title: const Text('Tanggal Dikembalikan'),
                subtitle: Text(DateFormat('dd-MM-yyyy').format(_tanggalDikembalikan)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Simpan Pengembalian'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 