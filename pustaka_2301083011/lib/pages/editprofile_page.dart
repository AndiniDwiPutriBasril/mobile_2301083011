import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/anggota_provider.dart';
import '../models/anggota.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _fotoController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final currentAnggota = Provider.of<AnggotaProvider>(context, listen: false).currentAnggota;
    _namaController.text = currentAnggota?.nama ?? '';
    _nimController.text = currentAnggota?.nim ?? '';
    _emailController.text = currentAnggota?.email ?? '';
    _alamatController.text = currentAnggota?.alamat ?? '';
    _fotoController.text = currentAnggota?.foto ?? '';
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _alamatController.dispose();
    _fotoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final anggotaProvider = Provider.of<AnggotaProvider>(context);
    final currentAnggota = anggotaProvider.currentAnggota;

    if (currentAnggota == null) {
      return const Center(child: Text('Data tidak ditemukan'));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5E6FA),
      appBar: AppBar(
        title: const Text('Edit Profil'),
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
            // Foto Profil Preview
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipOval(
                child: _fotoController.text.isNotEmpty
                    ? Image.network(
                        _fotoController.text,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.person,
                          size: 60,
                          color: Color(0xFFAC66CC),
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 60,
                        color: Color(0xFFAC66CC),
                      ),
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
                        controller: _namaController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Lengkap',
                          prefixIcon: Icon(Icons.person, color: Color(0xFFAC66CC)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nimController,
                        decoration: const InputDecoration(
                          labelText: 'NIM',
                          prefixIcon: Icon(Icons.badge, color: Color(0xFFAC66CC)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'NIM tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email, color: Color(0xFFAC66CC)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _alamatController,
                        decoration: const InputDecoration(
                          labelText: 'Alamat',
                          prefixIcon: Icon(Icons.location_on, color: Color(0xFFAC66CC)),
                        ),
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Alamat tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _fotoController,
                        decoration: const InputDecoration(
                          labelText: 'URL Foto',
                          prefixIcon: Icon(Icons.photo, color: Color(0xFFAC66CC)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => _isLoading = true);
                              try {
                                final updatedAnggota = Anggota(
                                  id: currentAnggota.id,
                                  nim: _nimController.text,
                                  nama: _namaController.text,
                                  alamat: _alamatController.text,
                                  email: _emailController.text,
                                  password: currentAnggota.password,
                                  tingkat: currentAnggota.tingkat,
                                  foto: _fotoController.text,
                                );

                                final success = await anggotaProvider.editAnggota(
                                  currentAnggota.id,
                                  updatedAnggota.nim,
                                  updatedAnggota.nama,
                                  updatedAnggota.alamat,
                                  updatedAnggota.email,
                                  updatedAnggota.foto,
                                  context,
                                );

                                if (success && context.mounted) {
                                  await anggotaProvider.refreshCurrentAnggota();
                                  
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Profil berhasil diperbarui'),
                                        backgroundColor: Color(0xFFAC66CC),
                                      ),
                                    );
                                    Navigator.pop(context);
                                  }
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Gagal memperbarui profil'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } finally {
                                setState(() => _isLoading = false);
                              }
                            }
                          },
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
                                  'Simpan Perubahan',
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
}
