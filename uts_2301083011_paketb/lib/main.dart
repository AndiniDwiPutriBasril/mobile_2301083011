import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/peminjaman_form_screen.dart';
import 'screens/peminjaman_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Peminjaman',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/form': (context) => PeminjamanFormScreen(),
        '/detail': (context) => PeminjamanDetailScreen(),
      },
    );
  }
}