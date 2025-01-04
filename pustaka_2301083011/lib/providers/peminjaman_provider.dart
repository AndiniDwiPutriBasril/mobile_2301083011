import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/peminjaman.dart';

class PeminjamanProvider with ChangeNotifier {
  final List<Peminjaman> _allPeminjaman = [];
  final String _baseUrl = 'http://localhost/pustaka2_2301083011/pustaka/peminjaman.php';
  
  List<Peminjaman> get allPeminjaman => _allPeminjaman;
  int get jumlahPeminjaman => _allPeminjaman.length;

  Peminjaman selectById(int id) =>
      _allPeminjaman.firstWhere((element) => element.id == id);

  Future<bool> addPeminjaman(String tanggalPinjam, String tanggalKembali, 
      int anggotaId, int bukuId) async {
    try {
      print('Mengirim data peminjaman:');
      print('tanggal_pinjam: $tanggalPinjam');
      print('tanggal_kembali: $tanggalKembali');
      print('id_anggota: $anggotaId');
      print('id_buku: $bukuId');

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'tanggal_pinjam': tanggalPinjam,
          'tanggal_kembali': tanggalKembali,
          'anggota': anggotaId.toString(),
          'buku': bukuId.toString(),
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          try {
            _allPeminjaman.add(
              Peminjaman(
                id: int.parse(responseData['data']['id'].toString()),
                tanggalPinjam: tanggalPinjam,
                tanggalKembali: tanggalKembali,
                anggota: anggotaId,
                buku: bukuId,
                namaAnggota: responseData['data']['nama_anggota'] ?? '',
                judulBuku: responseData['data']['judul_buku'] ?? '',
                cover: responseData['data']['cover'] ?? '',
              ),
            );
            notifyListeners();
            return true;
          } catch (e) {
            print('Error parsing response data: $e');
            return false;
          }
        } else {
          print('API returned error: ${responseData['message']}');
          return false;
        }
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error dalam peminjaman: $error');
      return false;
    }
  }

  void editPeminjaman(int id, String tanggalPinjam, String tanggalKembali, 
      int anggotaId, int bukuId, BuildContext context) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl?id=$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'tanggal_pinjam': tanggalPinjam,
          'tanggal_kembali': tanggalKembali,
          'anggota': anggotaId,
          'buku': bukuId,
        }),
      );

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        final peminjaman = _allPeminjaman.firstWhere((element) => element.id == id);
        peminjaman.tanggalPinjam = tanggalPinjam;
        peminjaman.tanggalKembali = tanggalKembali;
        peminjaman.anggota = anggotaId;
        peminjaman.buku = bukuId;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Peminjaman berhasil diubah")),
        );
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  void deletePeminjaman(int id, BuildContext context) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl?id=$id'));
      final data = json.decode(response.body);
      
      if (data['status'] == 'success') {
        _allPeminjaman.removeWhere((element) => element.id == id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Peminjaman berhasil dihapus")),
        );
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> initialData() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      final data = json.decode(response.body);
      
      if (data['status'] == 'success') {
        final List<dynamic> peminjamanList = data['data'];
        _allPeminjaman.clear();
        
        for (var peminjaman in peminjamanList) {
          _allPeminjaman.add(Peminjaman(
            id: int.parse(peminjaman['id'].toString()),
            tanggalPinjam: peminjaman['tanggal_pinjam'],
            tanggalKembali: peminjaman['tanggal_kembali'],
            anggota: int.parse(peminjaman['anggota'].toString()),
            buku: int.parse(peminjaman['buku'].toString()),
            namaAnggota: peminjaman['nama_anggota'],
            judulBuku: peminjaman['judul_buku'],
            cover: peminjaman['cover'],
          ));
        }
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }
} 