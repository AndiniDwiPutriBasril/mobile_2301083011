class Peminjaman {
  final String? id;
  final String anggotaId;
  final String bukuId;
  final String tanggalPinjam;
  final String tanggalKembali;

  Peminjaman({
    this.id,
    required this.anggotaId,
    required this.bukuId,
    required this.tanggalPinjam,
    required this.tanggalKembali,
  });

  factory Peminjaman.fromJson(Map<String, dynamic> json) {
    return Peminjaman(
      id: json['id'],
      anggotaId: json['anggota'],
      bukuId: json['buku'],
      tanggalPinjam: json['tanggal_pinjam'],
      tanggalKembali: json['tanggal_kembali'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'anggota': anggotaId,
      'buku': bukuId,
      'tanggal_pinjam': tanggalPinjam,
      'tanggal_kembali': tanggalKembali,
    };
  }
} 