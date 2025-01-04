import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/buku_provider.dart';
import '../models/buku.dart';

class TambahBukuPage extends StatefulWidget {
  const TambahBukuPage({super.key});

  @override
  State<TambahBukuPage> createState() => _TambahBukuPageState();
}

class _TambahBukuPageState extends State<TambahBukuPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _penulisController = TextEditingController();
  final _penerbitController = TextEditingController();
  final _tahunController = TextEditingController();
  final _kategoriController = TextEditingController();
  final _coverController = TextEditingController();
  final _deskripsiController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _judulController.dispose();
    _penulisController.dispose();
    _penerbitController.dispose();
    _tahunController.dispose();
    _kategoriController.dispose();
    _coverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6FA),
      appBar: AppBar(
        title: const Text('Tambah Buku'),
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
          children: [
            // Header Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFE5B8F4),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.library_books,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // Form
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                        controller: _penulisController,
                        decoration: const InputDecoration(
                          labelText: 'Penulis',
                          prefixIcon: Icon(Icons.person, color: Color(0xFFAC66CC)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Penulis tidak boleh kosong';
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
                          labelText: 'URL Cover Buku',
                          prefixIcon: Icon(Icons.image, color: Color(0xFFAC66CC)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'URL cover tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _deskripsiController,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi',
                          prefixIcon: Icon(Icons.description, color: Color(0xFFAC66CC)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Deskripsi tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : () => _handleSubmit(context),
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
                                  'Tambah Buku',
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final bukuProvider = Provider.of<BukuProvider>(context, listen: false);
        final buku = Buku(
          idBuku: 0,
          judul: _judulController.text,
          pengarang: _penulisController.text,
          penerbit: _penerbitController.text,
          tahunTerbit: _tahunController.text,
          kategori: _kategoriController.text,
          cover: _coverController.text,
          deskripsi: _deskripsiController.text,
        );

        await bukuProvider.addBuku(
          buku.judul, 
          buku.pengarang, 
          buku.penerbit, 
          buku.tahunTerbit, 
          buku.kategori, 
          buku.cover,
          buku.deskripsi,
        );

        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Buku berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menambahkan buku'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Widget buildCoverImage(String imageUrl) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / 
                  loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[200],
          child: const Icon(
            Icons.broken_image,
            size: 50,
          ),
        );
      },
    );
  }
}
