class Peminjaman {
  String kode;
  String nama;
  String kodePeminjaman;
  DateTime tanggal;
  String kodeNasabah;
  String namaNasabah;
  double jumlahPinjaman;
  int lamaPinjaman;
  double bunga = 0;
  double angsuranPokok = 0;
  double bungaPerBulan = 0;
  double angsuranPerBulan = 0;
  double totalHutang = 0;

  Peminjaman({
    required this.kode,
    required this.nama,
    required this.kodePeminjaman,
    required this.tanggal,
    required this.kodeNasabah,
    required this.namaNasabah,
    required this.jumlahPinjaman,
    required this.lamaPinjaman,
  }) {
    hitungPinjaman();
  }

  void hitungPinjaman() {
    bunga = 0.12 * jumlahPinjaman;
    angsuranPokok = jumlahPinjaman / lamaPinjaman;
    bungaPerBulan = bunga / 12;
    angsuranPerBulan = bungaPerBulan + angsuranPokok;
    totalHutang = jumlahPinjaman + bunga;
  }

  // Tambahkan metode toMap() untuk memudahkan konversi ke Map
  Map<String, dynamic> toMap() {
    return {
      'kode': kode,
      'nama': nama,
      'kodePeminjaman': kodePeminjaman,
      'tanggal': tanggal.toIso8601String(),
      'kodeNasabah': kodeNasabah,
      'namaNasabah': namaNasabah,
      'jumlahPinjaman': jumlahPinjaman,
      'lamaPinjaman': lamaPinjaman,
      'bunga': bunga,
      'angsuranPokok': angsuranPokok,
      'bungaPerBulan': bungaPerBulan,
      'angsuranPerBulan': angsuranPerBulan,
      'totalHutang': totalHutang,
    };
  }

  // Tambahkan metode fromMap() untuk membuat objek dari Map
  static Peminjaman? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    
    return Peminjaman(
      kode: map['kode'] ?? '',
      nama: map['nama'] ?? '',
      kodePeminjaman: map['kodePeminjaman'] ?? '',
      tanggal: DateTime.tryParse(map['tanggal'] ?? '') ?? DateTime.now(),
      kodeNasabah: map['kodeNasabah'] ?? '',
      namaNasabah: map['namaNasabah'] ?? '',
      jumlahPinjaman: (map['jumlahPinjaman'] as num?)?.toDouble() ?? 0.0,
      lamaPinjaman: map['lamaPinjaman'] as int? ?? 0,
    );
  }
}
