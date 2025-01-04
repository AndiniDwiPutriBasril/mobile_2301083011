import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/anggota.dart';

class AnggotaProvider with ChangeNotifier {
  final List<Anggota> _allAnggota = [];
  final String _baseUrl = 'http://localhost/pustaka2_2301083011/pustaka/anggota.php';
  Anggota? _currentAnggota;
  
  List<Anggota> get allAnggota => _allAnggota;
  int get jumlahAnggota => _allAnggota.length;
  Anggota? get currentAnggota => _currentAnggota;

  Anggota selectById(int id) =>
      _allAnggota.firstWhere((element) => element.id == id);

  Future<void> addAnggota(String nim, String nama, String alamat, 
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nim': nim,
          'nama': nama,
          'alamat': alamat,
          'email': email,
          'password': password,
          'tingkat': 1,
          'foto': '',
        }),
      );

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        _allAnggota.add(
          Anggota(
            id: data['data']['id'],
            nim: nim,
            nama: nama,
            alamat: alamat,
            email: email,
            password: password,
            tingkat: 1,
            foto: '',
          ),
        );
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> editAnggota(int id, String nim, String nama, String alamat, 
      String email, String foto, BuildContext context) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl?id=$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nim': nim,
          'nama': nama,
          'alamat': alamat,
          'email': email,
          'foto': foto,
        }),
      );

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        final index = _allAnggota.indexWhere((element) => element.id == id);
        
        if (index != -1) {
          _allAnggota[index] = Anggota(
            id: id,
            nim: nim,
            nama: nama,
            alamat: alamat,
            email: email,
            password: _allAnggota[index].password,
            tingkat: _allAnggota[index].tingkat,
            foto: foto,
          );
        }
        
        if (_currentAnggota?.id == id) {
          _currentAnggota = Anggota(
            id: id,
            nim: nim,
            nama: nama,
            alamat: alamat,
            email: email,
            password: _currentAnggota!.password,
            tingkat: _currentAnggota!.tingkat,
            foto: foto,
          );
        }

        notifyListeners();
        return true;
      }
      return false;
    } catch (error) {
      print('Error updating anggota: $error');
      return false;
    }
  }

  void deleteAnggota(int id, BuildContext context) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl?id=$id'));
      final data = json.decode(response.body);
      
      if (data['status'] == 'success') {
        _allAnggota.removeWhere((element) => element.id == id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Berhasil dihapus")),
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
        final List<dynamic> anggotaList = data['data'];
        _allAnggota.clear();
        
        for (var anggota in anggotaList) {
          _allAnggota.add(Anggota(
            id: anggota['id'],
            nim: anggota['nim'],
            nama: anggota['nama'],
            alamat: anggota['alamat'],
            email: anggota['email'],
            password: anggota['password'],
            tingkat: anggota['tingkat'],
            foto: anggota['foto'],
          ));
        }
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      print('Attempting login with email: $email');

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'method': 'login',
          'email': email,
          'password': password,
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        final anggotaData = data['data'];
        print('Login successful, anggota data: $anggotaData');
        
        _currentAnggota = Anggota(
          id: int.parse(anggotaData['id'].toString()),
          nim: anggotaData['nim'],
          nama: anggotaData['nama'],
          alamat: anggotaData['alamat'],
          email: anggotaData['email'],
          password: anggotaData['password'],
          tingkat: int.parse(anggotaData['tingkat'].toString()),
          foto: anggotaData['foto'] ?? '',
        );
        notifyListeners();
      } else {
        print('Login failed: ${data['message']}');
        throw Exception(data['message']);
      }
    } catch (error) {
      print('Login error: $error');
      rethrow;
    }
  }

  void logout() {
    _currentAnggota = null;
    notifyListeners();
  }

  Future<bool> register(String nim, String nama, String alamat, String email, String password, String foto) async {
    try {
      print('Attempting register with data:');
      print('nim: $nim, nama: $nama, email: $email');
      
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nim': nim,
          'nama': nama,
          'alamat': alamat,
          'email': email,
          'password': password,
          'tingkat': 1,
          'foto': foto,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = json.decode(response.body);
      return data['status'] == 'success';
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  Future<void> refreshCurrentAnggota() async {
    if (currentAnggota != null) {
      // Ambil data terbaru dari API
      final updatedAnggota = await fetchAnggotaById(currentAnggota!.id);
      if (updatedAnggota != null) {
        _currentAnggota = updatedAnggota;
        notifyListeners();
      }
    }
  }

  Future<Anggota?> fetchAnggotaById(int id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?id=$id'));
      final data = json.decode(response.body);
      
      if (data['status'] == 'success') {
        final anggotaData = data['data'];
        return Anggota(
          id: int.parse(anggotaData['id'].toString()),
          nim: anggotaData['nim'],
          nama: anggotaData['nama'],
          alamat: anggotaData['alamat'],
          email: anggotaData['email'],
          password: anggotaData['password'],
          tingkat: int.parse(anggotaData['tingkat'].toString()),
          foto: anggotaData['foto'] ?? '',
        );
      }
      return null;
    } catch (error) {
      print('Error fetching anggota by ID: $error');
      return null;
    }
  }
}