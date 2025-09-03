class PegawaiModel {
  int? id;
  String nama;
  String nik;
  String tempatLahir;
  DateTime tanggalLahir;
  String jenisKelamin;
  String agama;
  String statusPerkawinan;
  String alamatLengkap;
  String rt;
  String rw;
  String kelurahan;
  String kecamatan;
  String kabupaten;
  String provinsi;
  String kodePos;
  String noTelepon;
  String email;
  String pendidikanTerakhir;
  String jurusan;
  String institusiPendidikan;
  String tahunLulus;
  String jabatan;
  String departemen;
  DateTime tanggalMasuk;
  String statusKepegawaian;
  String noRekening;
  String namaBank;
  String namaAhliWaris;
  String hubunganAhliWaris;
  String noTeleponAhliWaris;
  
  // File paths untuk dokumen
  String? ktpFilePath;
  String? kkFilePath;
  String? ijazahFilePath;
  String? sertifikatFilePath;
  String? cvFilePath;
  String? fotoFilePath;
  
  DateTime createdAt;
  DateTime? updatedAt;

  PegawaiModel({
    this.id,
    required this.nama,
    required this.nik,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.agama,
    required this.statusPerkawinan,
    required this.alamatLengkap,
    required this.rt,
    required this.rw,
    required this.kelurahan,
    required this.kecamatan,
    required this.kabupaten,
    required this.provinsi,
    required this.kodePos,
    required this.noTelepon,
    required this.email,
    required this.pendidikanTerakhir,
    required this.jurusan,
    required this.institusiPendidikan,
    required this.tahunLulus,
    required this.jabatan,
    required this.departemen,
    required this.tanggalMasuk,
    required this.statusKepegawaian,
    required this.noRekening,
    required this.namaBank,
    required this.namaAhliWaris,
    required this.hubunganAhliWaris,
    required this.noTeleponAhliWaris,
    this.ktpFilePath,
    this.kkFilePath,
    this.ijazahFilePath,
    this.sertifikatFilePath,
    this.cvFilePath,
    this.fotoFilePath,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'nik': nik,
      'tempat_lahir': tempatLahir,
      'tanggal_lahir': tanggalLahir.millisecondsSinceEpoch,
      'jenis_kelamin': jenisKelamin,
      'agama': agama,
      'status_perkawinan': statusPerkawinan,
      'alamat_lengkap': alamatLengkap,
      'rt': rt,
      'rw': rw,
      'kelurahan': kelurahan,
      'kecamatan': kecamatan,
      'kabupaten': kabupaten,
      'provinsi': provinsi,
      'kode_pos': kodePos,
      'no_telepon': noTelepon,
      'email': email,
      'pendidikan_terakhir': pendidikanTerakhir,
      'jurusan': jurusan,
      'institusi_pendidikan': institusiPendidikan,
      'tahun_lulus': tahunLulus,
      'jabatan': jabatan,
      'departemen': departemen,
      'tanggal_masuk': tanggalMasuk.millisecondsSinceEpoch,
      'status_kepegawaian': statusKepegawaian,
      'no_rekening': noRekening,
      'nama_bank': namaBank,
      'nama_ahli_waris': namaAhliWaris,
      'hubungan_ahli_waris': hubunganAhliWaris,
      'no_telepon_ahli_waris': noTeleponAhliWaris,
      'ktp_file_path': ktpFilePath,
      'kk_file_path': kkFilePath,
      'ijazah_file_path': ijazahFilePath,
      'sertifikat_file_path': sertifikatFilePath,
      'cv_file_path': cvFilePath,
      'foto_file_path': fotoFilePath,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory PegawaiModel.fromMap(Map<String, dynamic> map) {
    return PegawaiModel(
      id: map['id'],
      nama: map['nama'],
      nik: map['nik'],
      tempatLahir: map['tempat_lahir'],
      tanggalLahir: DateTime.fromMillisecondsSinceEpoch(map['tanggal_lahir']),
      jenisKelamin: map['jenis_kelamin'],
      agama: map['agama'],
      statusPerkawinan: map['status_perkawinan'],
      alamatLengkap: map['alamat_lengkap'],
      rt: map['rt'],
      rw: map['rw'],
      kelurahan: map['kelurahan'],
      kecamatan: map['kecamatan'],
      kabupaten: map['kabupaten'],
      provinsi: map['provinsi'],
      kodePos: map['kode_pos'],
      noTelepon: map['no_telepon'],
      email: map['email'],
      pendidikanTerakhir: map['pendidikan_terakhir'],
      jurusan: map['jurusan'],
      institusiPendidikan: map['institusi_pendidikan'],
      tahunLulus: map['tahun_lulus'],
      jabatan: map['jabatan'],
      departemen: map['departemen'],
      tanggalMasuk: DateTime.fromMillisecondsSinceEpoch(map['tanggal_masuk']),
      statusKepegawaian: map['status_kepegawaian'],
      noRekening: map['no_rekening'],
      namaBank: map['nama_bank'],
      namaAhliWaris: map['nama_ahli_waris'],
      hubunganAhliWaris: map['hubungan_ahli_waris'],
      noTeleponAhliWaris: map['no_telepon_ahli_waris'],
      ktpFilePath: map['ktp_file_path'],
      kkFilePath: map['kk_file_path'],
      ijazahFilePath: map['ijazah_file_path'],
      sertifikatFilePath: map['sertifikat_file_path'],
      cvFilePath: map['cv_file_path'],
      fotoFilePath: map['foto_file_path'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      updatedAt: map['updated_at'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['updated_at']) 
          : null,
    );
  }

  PegawaiModel copyWith({
    int? id,
    String? nama,
    String? nik,
    String? tempatLahir,
    DateTime? tanggalLahir,
    String? jenisKelamin,
    String? agama,
    String? statusPerkawinan,
    String? alamatLengkap,
    String? rt,
    String? rw,
    String? kelurahan,
    String? kecamatan,
    String? kabupaten,
    String? provinsi,
    String? kodePos,
    String? noTelepon,
    String? email,
    String? pendidikanTerakhir,
    String? jurusan,
    String? institusiPendidikan,
    String? tahunLulus,
    String? jabatan,
    String? departemen,
    DateTime? tanggalMasuk,
    String? statusKepegawaian,
    String? noRekening,
    String? namaBank,
    String? namaAhliWaris,
    String? hubunganAhliWaris,
    String? noTeleponAhliWaris,
    String? ktpFilePath,
    String? kkFilePath,
    String? ijazahFilePath,
    String? sertifikatFilePath,
    String? cvFilePath,
    String? fotoFilePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PegawaiModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      nik: nik ?? this.nik,
      tempatLahir: tempatLahir ?? this.tempatLahir,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      agama: agama ?? this.agama,
      statusPerkawinan: statusPerkawinan ?? this.statusPerkawinan,
      alamatLengkap: alamatLengkap ?? this.alamatLengkap,
      rt: rt ?? this.rt,
      rw: rw ?? this.rw,
      kelurahan: kelurahan ?? this.kelurahan,
      kecamatan: kecamatan ?? this.kecamatan,
      kabupaten: kabupaten ?? this.kabupaten,
      provinsi: provinsi ?? this.provinsi,
      kodePos: kodePos ?? this.kodePos,
      noTelepon: noTelepon ?? this.noTelepon,
      email: email ?? this.email,
      pendidikanTerakhir: pendidikanTerakhir ?? this.pendidikanTerakhir,
      jurusan: jurusan ?? this.jurusan,
      institusiPendidikan: institusiPendidikan ?? this.institusiPendidikan,
      tahunLulus: tahunLulus ?? this.tahunLulus,
      jabatan: jabatan ?? this.jabatan,
      departemen: departemen ?? this.departemen,
      tanggalMasuk: tanggalMasuk ?? this.tanggalMasuk,
      statusKepegawaian: statusKepegawaian ?? this.statusKepegawaian,
      noRekening: noRekening ?? this.noRekening,
      namaBank: namaBank ?? this.namaBank,
      namaAhliWaris: namaAhliWaris ?? this.namaAhliWaris,
      hubunganAhliWaris: hubunganAhliWaris ?? this.hubunganAhliWaris,
      noTeleponAhliWaris: noTeleponAhliWaris ?? this.noTeleponAhliWaris,
      ktpFilePath: ktpFilePath ?? this.ktpFilePath,
      kkFilePath: kkFilePath ?? this.kkFilePath,
      ijazahFilePath: ijazahFilePath ?? this.ijazahFilePath,
      sertifikatFilePath: sertifikatFilePath ?? this.sertifikatFilePath,
      cvFilePath: cvFilePath ?? this.cvFilePath,
      fotoFilePath: fotoFilePath ?? this.fotoFilePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
