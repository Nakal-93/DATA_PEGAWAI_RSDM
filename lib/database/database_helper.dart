import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/pegawai_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'pegawai_rsdm.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pegawai (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        nik TEXT NOT NULL UNIQUE,
        tempat_lahir TEXT NOT NULL,
        tanggal_lahir INTEGER NOT NULL,
        jenis_kelamin TEXT NOT NULL,
        agama TEXT NOT NULL,
        status_perkawinan TEXT NOT NULL,
        alamat_lengkap TEXT NOT NULL,
        rt TEXT NOT NULL,
        rw TEXT NOT NULL,
        kelurahan TEXT NOT NULL,
        kecamatan TEXT NOT NULL,
        kabupaten TEXT NOT NULL,
        provinsi TEXT NOT NULL,
        kode_pos TEXT NOT NULL,
        no_telepon TEXT NOT NULL,
        email TEXT NOT NULL,
        pendidikan_terakhir TEXT NOT NULL,
        jurusan TEXT NOT NULL,
        institusi_pendidikan TEXT NOT NULL,
        tahun_lulus TEXT NOT NULL,
        jabatan TEXT NOT NULL,
        departemen TEXT NOT NULL,
        tanggal_masuk INTEGER NOT NULL,
        status_kepegawaian TEXT NOT NULL,
        no_rekening TEXT NOT NULL,
        nama_bank TEXT NOT NULL,
        nama_ahli_waris TEXT NOT NULL,
        hubungan_ahli_waris TEXT NOT NULL,
        no_telepon_ahli_waris TEXT NOT NULL,
        ktp_file_path TEXT,
        kk_file_path TEXT,
        ijazah_file_path TEXT,
        sertifikat_file_path TEXT,
        cv_file_path TEXT,
        foto_file_path TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER
      )
    ''');
  }

  // Insert pegawai
  Future<int> insertPegawai(PegawaiModel pegawai) async {
    final db = await database;
    return await db.insert('pegawai', pegawai.toMap());
  }

  // Get all pegawai
  Future<List<PegawaiModel>> getAllPegawai() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pegawai',
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return PegawaiModel.fromMap(maps[i]);
    });
  }

  // Get pegawai by id
  Future<PegawaiModel?> getPegawaiById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pegawai',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PegawaiModel.fromMap(maps.first);
    }
    return null;
  }

  // Update pegawai
  Future<int> updatePegawai(PegawaiModel pegawai) async {
    final db = await database;
    return await db.update(
      'pegawai',
      pegawai.toMap(),
      where: 'id = ?',
      whereArgs: [pegawai.id],
    );
  }

  // Delete pegawai
  Future<int> deletePegawai(int id) async {
    final db = await database;
    return await db.delete(
      'pegawai',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Search pegawai by name or NIK
  Future<List<PegawaiModel>> searchPegawai(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pegawai',
      where: 'nama LIKE ? OR nik LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'nama ASC',
    );

    return List.generate(maps.length, (i) {
      return PegawaiModel.fromMap(maps[i]);
    });
  }

  // Get pegawai by department
  Future<List<PegawaiModel>> getPegawaiByDepartment(String department) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pegawai',
      where: 'departemen = ?',
      whereArgs: [department],
      orderBy: 'nama ASC',
    );

    return List.generate(maps.length, (i) {
      return PegawaiModel.fromMap(maps[i]);
    });
  }

  // Get total count of pegawai
  Future<int> getTotalPegawai() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM pegawai');
    return result.first['count'] as int;
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
