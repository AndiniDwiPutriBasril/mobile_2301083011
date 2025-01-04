import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/anggota_provider.dart';
import '../pages/editprofile_page.dart';
import '../pages/tambah_buku.dart';
import '../pages/login_page.dart';
import '../pages/manage_buku_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final anggotaProvider = Provider.of<AnggotaProvider>(context);
    final currentAnggota = anggotaProvider.currentAnggota;

    if (currentAnggota == null) {
      return const Center(child: Text('Data tidak ditemukan'));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5E6FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header dengan foto profil
            Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
              decoration: BoxDecoration(
                color: const Color(0xFFE5B8F4),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(currentAnggota.foto),
                    onBackgroundImageError: (_, __) => const Icon(Icons.person),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentAnggota.nama,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    currentAnggota.email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Informasi Profil
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Card Informasi
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildProfileItem(
                            icon: Icons.badge,
                            label: 'NIM',
                            value: currentAnggota.nim,
                          ),
                          const Divider(height: 20),
                          _buildProfileItem(
                            icon: Icons.location_on,
                            label: 'Alamat',
                            value: currentAnggota.alamat,
                          ),
                          if (currentAnggota.tingkat == 1) ...[
                            const Divider(height: 20),
                            _buildProfileItem(
                              icon: Icons.admin_panel_settings,
                              label: 'Status',
                              value: 'Admin',
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tombol Edit Profil
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Profil'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfilePage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFFAC66CC),
                        foregroundColor: Colors.white,
                        elevation: 0,
                      ),
                    ),
                  ),

                  // Tombol Tambah Buku (Admin only)
                  if (currentAnggota.tingkat == 1) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.library_add),
                        label: const Text('Tambah Buku'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TambahBukuPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFFAC66CC),
                          foregroundColor: Colors.white,
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],

                  // Tombol Kelola Buku (Admin only)
                  if (currentAnggota.tingkat == 1) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ManageBukuPage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.library_books),
                        label: const Text('Kelola Buku'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFAC66CC),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],

                  // Tombol Logout
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      onPressed: () {
                        anggotaProvider.logout();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.red[400],
                        foregroundColor: Colors.white,
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF5E6FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFAC66CC),
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
