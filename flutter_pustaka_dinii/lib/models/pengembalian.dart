class Pengembalian {
  final String? id;
  final String peminjamanId;
  final String tanggalDikembalikan;
  final int terlambat;
  final double denda;

  Pengembalian({
    this.id,
    required this.peminjamanId,
    required this.tanggalDikembalikan,
    required this.terlambat,
    required this.denda,
  });

  factory Pengembalian.fromJson(Map<String, dynamic> json) {
    return Pengembalian(
      id: json['id'],
      peminjamanId: json['peminjaman'],
      tanggalDikembalikan: json['tanggal_dikembalikan'],
      terlambat: int.parse(json['terlambat'].toString()),
      denda: double.parse(json['denda'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'peminjaman': peminjamanId,
      'tanggal_dikembalikan': tanggalDikembalikan,
      'terlambat': terlambat,
      'denda': denda,
    };
  }
} 