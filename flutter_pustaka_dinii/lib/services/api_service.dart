import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Sesuaikan dengan lokasi folder PHP Anda
  static const String baseUrl = 'http://10.0.2.2/flutter_pustaka_2301083011';

  // API Anggota
  Future<List<dynamic>> getAnggota() async {
    final response = await http.get(Uri.parse('$baseUrl/anggota.php?action=read'));
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> tambahAnggota(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/anggota.php?action=create'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return json.decode(response.body);
  }

  // API Buku
  Future<List<dynamic>> getBuku() async {
    final response = await http.get(Uri.parse('$baseUrl/buku.php?action=read'));
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> tambahBuku(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/buku.php?action=create'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return json.decode(response.body);
  }

  // API Peminjaman
  Future<List<dynamic>> getPeminjaman() async {
    final response = await http.get(Uri.parse('$baseUrl/peminjaman.php?action=read'));
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> tambahPeminjaman(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/peminjaman.php?action=create'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return json.decode(response.body);
  }

  // API Pengembalian
  Future<List<dynamic>> getPengembalian() async {
    final response = await http.get(Uri.parse('$baseUrl/pengembalian.php?action=read'));
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> tambahPengembalian(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pengembalian.php?action=create'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return json.decode(response.body);
  }
} 