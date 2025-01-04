import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/buku_provider.dart';

class ManageBukuPage extends StatefulWidget {
  const ManageBukuPage({Key? key}) : super(key: key);

  @override
  State<ManageBukuPage> createState() => _ManageBukuPageState();
}

class _ManageBukuPageState extends State<ManageBukuPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulController;
  late TextEditingController _pengarangController;
  late TextEditingController _penerbitController;
  late TextEditingController _tahunController;
  late TextEditingController _kategoriController;
  late TextEditingController _coverController;
  late TextEditingController _deskripsiController;
  bool _isLoading = false;
  int? _selectedBukuId;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController();
    _pengarangController = TextEditingController();
    _penerbitController = TextEditingController();
    _tahunController = TextEditingController();
    _kategoriController = TextEditingController();
    _coverController = TextEditingController();
    _deskripsiController = TextEditingController();
  }

  @override
  void dispose() {
    _judulController.dispose();
    _pengarangController.dispose();
    _penerbitController.dispose();
    _tahunController.dispose();
    _kategoriController.dispose();
    _coverController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _loadBukuData(int idBuku, BukuProvider provider) {
    setState(() {
      final buku = provider.selectById(idBuku);
      _selectedBukuId = idBuku;
      _judulController.text = buku.judul;
      _pengarangController.text = buku.pengarang;
      _penerbitController.text = buku.penerbit;
      _tahunController.text = buku.tahunTerbit;
      _kategoriController.text = buku.kategori;
      _coverController.text = buku.cover;
      _deskripsiController.text = buku.deskripsi;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6FA),
      appBar: AppBar(
        title: const Text('Kelola Buku'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Color(0xFFAC66CC),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Consumer<BukuProvider>(
        builder: (context, bukuProvider, child) {
          return Row(
            children: [
              // Daftar Buku (Sebelah Kiri)
              Expanded(
                flex: 2,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: bukuProvider.allBuku.length,
                  itemBuilder: (context, index) {
                    final buku = bukuProvider.allBuku[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        onTap: () => _loadBukuData(buku.idBuku, bukuProvider),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Cover Buku
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  buku.cover,
                                  width: 60,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 60,
                                      height: 90,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.broken_image),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Informasi Buku
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      buku.judul,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFAC66CC),
                                      ),
                                    ),
                                    Text(
                                      buku.pengarang,
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
                    );
                  },
                ),
              ),
              // Form Edit (Sebelah Kanan)
              if (_selectedBukuId != null)
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Edit Buku',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFAC66CC),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _judulController,
                                decoration: const InputDecoration(
                                  labelText: 'Judul Buku',
                                  prefixIcon: Icon(Icons.book, color: Color(0xFFAC66CC)),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Judul tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _pengarangController,
                                decoration: const InputDecoration(
                                  labelText: 'Pengarang',
                                  prefixIcon: Icon(Icons.person, color: Color(0xFFAC66CC)),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Pengarang tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _penerbitController,
                                decoration: const InputDecoration(
                                  labelText: 'Penerbit',
                                  prefixIcon: Icon(Icons.business, color: Color(0xFFAC66CC)),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Penerbit tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _tahunController,
                                decoration: const InputDecoration(
                                  labelText: 'Tahun Terbit',
                                  prefixIcon: Icon(Icons.calendar_today, color: Color(0xFFAC66CC)),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Tahun terbit tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _kategoriController,
                                decoration: const InputDecoration(
                                  labelText: 'Kategori',
                                  prefixIcon: Icon(Icons.category, color: Color(0xFFAC66CC)),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Kategori tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _coverController,
                                decoration: const InputDecoration(
                                  labelText: 'URL Cover',
                                  prefixIcon: Icon(Icons.image, color: Color(0xFFAC66CC)),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _deskripsiController,
                                decoration: const InputDecoration(
                                  labelText: 'Deskripsi',
                                  prefixIcon: Icon(Icons.description, color: Color(0xFFAC66CC)),
                                ),
                                maxLines: 3,
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _isLoading
                                          ? null
                                          : () {
                                              if (_formKey.currentState!.validate()) {
                                                setState(() => _isLoading = true);
                                                print('Editing book with ID: $_selectedBukuId'); // Debug print
                                                
                                                try {
                                                  bukuProvider.editBuku(
                                                    _selectedBukuId!,
                                                    _judulController.text,
                                                    _pengarangController.text,
                                                    _penerbitController.text,
                                                    _tahunController.text,
                                                    _kategoriController.text,
                                                    _coverController.text,
                                                    _deskripsiController.text,
                                                    context,
                                                  );
                                                  
                                                  // Reset form setelah berhasil
                                                  setState(() {
                                                    _selectedBukuId = null;
                                                    _isLoading = false;
                                                  });
                                                } catch (e) {
                                                  print('Error editing book: $e'); // Debug print
                                                  setState(() => _isLoading = false);
                                                }
                                              }
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFAC66CC),
                                        padding: const EdgeInsets.symmetric(vertical: 16),
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
                                          : const Text('Simpan'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _isLoading
                                          ? null
                                          : () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: const Text('Konfirmasi'),
                                                  content: const Text(
                                                    'Apakah Anda yakin ingin menghapus buku ini?',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      child: const Text(
                                                        'Batal',
                                                        style: TextStyle(
                                                          color: Color(0xFFAC66CC),
                                                        ),
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        bukuProvider.deleteBuku(
                                                          _selectedBukuId!,
                                                          context,
                                                        );
                                                        setState(() => _selectedBukuId = null);
                                                        Navigator.pop(context); // Tutup dialog konfirmasi
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.red,
                                                      ),
                                                      child: const Text('Hapus'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                      ),
                                      child: const Text('Hapus'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
} 