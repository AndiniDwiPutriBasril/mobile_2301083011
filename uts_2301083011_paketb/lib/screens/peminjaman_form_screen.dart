import 'package:flutter/material.dart';
import '../models/peminjaman.dart';

class PeminjamanFormScreen extends StatefulWidget {
  @override
  _PeminjamanFormScreenState createState() => _PeminjamanFormScreenState();
}

class _PeminjamanFormScreenState extends State<PeminjamanFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late Peminjaman _peminjaman;

  @override
  void initState() {
    super.initState();
    _peminjaman = Peminjaman(
      kode: '',
      nama: '',
      kodePeminjaman: '',
      tanggal: DateTime.now(),
      kodeNasabah: '',
      namaNasabah: '',
      jumlahPinjaman: 0,
      lamaPinjaman: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Peminjaman'),
        backgroundColor: Colors.green[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[100]!, Colors.white],
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildTextField('Kode', (value) => _peminjaman.kode = value),
                      _buildTextField('Nama', (value) => _peminjaman.nama = value),
                      _buildTextField('Kode Peminjaman', (value) => _peminjaman.kodePeminjaman = value),
                      _buildTextField('Kode Nasabah', (value) => _peminjaman.kodeNasabah = value),
                      _buildTextField('Nama Nasabah', (value) => _peminjaman.namaNasabah = value),
                      _buildNumberField('Jumlah Pinjaman', (value) => _peminjaman.jumlahPinjaman = double.parse(value)),
                      _buildNumberField('Lama Pinjaman (Bulan)', (value) => _peminjaman.lamaPinjaman = int.parse(value)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text('Kembali'),
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                  ElevatedButton(
                    child: Text('Simpan'),
                    onPressed: _saveForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _peminjaman.hitungPinjaman();
      Navigator.pushNamed(context, '/detail', arguments: _peminjaman);
    }
  }

  Widget _buildTextField(String label, Function(String) onSaved) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Harap masukkan $label';
          }
          return null;
        },
        onSaved: (value) => onSaved(value!),
      ),
    );
  }

  Widget _buildNumberField(String label, Function(String) onSaved) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Harap masukkan $label';
          }
          if (double.tryParse(value) == null) {
            return 'Harap masukkan angka yang valid';
          }
          return null;
        },
        onSaved: (value) => onSaved(value!),
      ),
    );
  }
}
