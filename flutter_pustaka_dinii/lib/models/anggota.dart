class Anggota {
  final String? id;
  final String nim;
  final String nama;
  final String alamat;
  final String jenisKelamin;

  Anggota({
    this.id,
    required this.nim,
    required this.nama,
    required this.alamat,
    required this.jenisKelamin,
  });

  factory Anggota.fromJson(Map<String, dynamic> json) {
    return Anggota(
      id: json['id'],
      nim: json['nim'],
      nama: json['nama'],
      alamat: json['alamat'],
      jenisKelamin: json['jenis_kelamin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nim': nim,
      'nama': nama,
      'alamat': alamat,
      'jenis_kelamin': jenisKelamin,
    };
  }
} 