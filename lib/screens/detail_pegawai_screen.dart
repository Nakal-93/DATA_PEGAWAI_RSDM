import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/pegawai_model.dart';
import '../services/file_service.dart';
import 'add_pegawai_screen.dart';

class DetailPegawaiScreen extends StatefulWidget {
  final PegawaiModel pegawai;

  const DetailPegawaiScreen({Key? key, required this.pegawai}) : super(key: key);

  @override
  State<DetailPegawaiScreen> createState() => _DetailPegawaiScreenState();
}

class _DetailPegawaiScreenState extends State<DetailPegawaiScreen> {
  final FileService _fileService = FileService();
  late PegawaiModel _pegawai;

  @override
  void initState() {
    super.initState();
    _pegawai = widget.pegawai;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pegawai.nama),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEdit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderCard(),
            _buildPersonalInfoCard(),
            _buildAddressCard(),
            _buildContactCard(),
            _buildEducationCard(),
            _buildEmploymentCard(),
            _buildBankCard(),
            _buildHeirCard(),
            _buildDocumentsCard(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade600,
            Colors.blue.shade800,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile Photo
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage: _pegawai.fotoFilePath != null 
                  ? FileImage(File(_pegawai.fotoFilePath!)) as ImageProvider
                  : null,
              child: _pegawai.fotoFilePath == null
                  ? Text(
                      _pegawai.nama.isNotEmpty ? _pegawai.nama[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    )
                  : null,
            ),
            
            const SizedBox(height: 16),
            
            // Name and NIK
            Text(
              _pegawai.nama,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 4),
            
            Text(
              'NIK: ${_pegawai.nik}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Text(
                _pegawai.statusKepegawaian,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return _buildInfoCard(
      title: 'Data Pribadi',
      icon: Icons.person,
      children: [
        _buildInfoRow('Nama Lengkap', _pegawai.nama),
        _buildInfoRow('NIK', _pegawai.nik),
        _buildInfoRow('Tempat, Tanggal Lahir', 
            '${_pegawai.tempatLahir}, ${DateFormat('dd MMMM yyyy', 'id_ID').format(_pegawai.tanggalLahir)}'),
        _buildInfoRow('Jenis Kelamin', _pegawai.jenisKelamin),
        _buildInfoRow('Agama', _pegawai.agama),
        _buildInfoRow('Status Perkawinan', _pegawai.statusPerkawinan),
      ],
    );
  }

  Widget _buildAddressCard() {
    return _buildInfoCard(
      title: 'Alamat',
      icon: Icons.location_on,
      children: [
        _buildInfoRow('Alamat Lengkap', _pegawai.alamatLengkap),
        _buildInfoRow('RT/RW', '${_pegawai.rt}/${_pegawai.rw}'),
        _buildInfoRow('Kelurahan', _pegawai.kelurahan),
        _buildInfoRow('Kecamatan', _pegawai.kecamatan),
        _buildInfoRow('Kabupaten/Kota', _pegawai.kabupaten),
        _buildInfoRow('Provinsi', _pegawai.provinsi),
        _buildInfoRow('Kode Pos', _pegawai.kodePos),
      ],
    );
  }

  Widget _buildContactCard() {
    return _buildInfoCard(
      title: 'Kontak',
      icon: Icons.contact_phone,
      children: [
        _buildInfoRow('Nomor Telepon', _pegawai.noTelepon, 
            trailing: IconButton(
              icon: const Icon(Icons.phone, color: Colors.green),
              onPressed: () => _launchPhone(_pegawai.noTelepon),
            )),
        _buildInfoRow('Email', _pegawai.email,
            trailing: IconButton(
              icon: const Icon(Icons.email, color: Colors.blue),
              onPressed: () => _launchEmail(_pegawai.email),
            )),
      ],
    );
  }

  Widget _buildEducationCard() {
    return _buildInfoCard(
      title: 'Pendidikan',
      icon: Icons.school,
      children: [
        _buildInfoRow('Pendidikan Terakhir', _pegawai.pendidikanTerakhir),
        _buildInfoRow('Jurusan', _pegawai.jurusan),
        _buildInfoRow('Institusi', _pegawai.institusiPendidikan),
        _buildInfoRow('Tahun Lulus', _pegawai.tahunLulus),
      ],
    );
  }

  Widget _buildEmploymentCard() {
    return _buildInfoCard(
      title: 'Kepegawaian',
      icon: Icons.work,
      children: [
        _buildInfoRow('Jabatan', _pegawai.jabatan),
        _buildInfoRow('Departemen', _pegawai.departemen),
        _buildInfoRow('Tanggal Masuk', 
            DateFormat('dd MMMM yyyy', 'id_ID').format(_pegawai.tanggalMasuk)),
        _buildInfoRow('Status Kepegawaian', _pegawai.statusKepegawaian),
      ],
    );
  }

  Widget _buildBankCard() {
    return _buildInfoCard(
      title: 'Data Bank',
      icon: Icons.account_balance,
      children: [
        _buildInfoRow('Nomor Rekening', _pegawai.noRekening),
        _buildInfoRow('Nama Bank', _pegawai.namaBank),
      ],
    );
  }

  Widget _buildHeirCard() {
    return _buildInfoCard(
      title: 'Ahli Waris',
      icon: Icons.family_restroom,
      children: [
        _buildInfoRow('Nama Ahli Waris', _pegawai.namaAhliWaris),
        _buildInfoRow('Hubungan', _pegawai.hubunganAhliWaris),
        _buildInfoRow('Nomor Telepon', _pegawai.noTeleponAhliWaris,
            trailing: IconButton(
              icon: const Icon(Icons.phone, color: Colors.green),
              onPressed: () => _launchPhone(_pegawai.noTeleponAhliWaris),
            )),
      ],
    );
  }

  Widget _buildDocumentsCard() {
    final documents = [
      ('Foto Pegawai', _pegawai.fotoFilePath, Icons.photo),
      ('KTP', _pegawai.ktpFilePath, Icons.credit_card),
      ('Kartu Keluarga', _pegawai.kkFilePath, Icons.family_restroom),
      ('Ijazah', _pegawai.ijazahFilePath, Icons.school),
      ('Sertifikat', _pegawai.sertifikatFilePath, Icons.workspace_premium),
      ('CV/Resume', _pegawai.cvFilePath, Icons.description),
    ];

    return _buildInfoCard(
      title: 'Dokumen',
      icon: Icons.folder,
      children: documents.map((doc) => _buildDocumentRow(doc.$1, doc.$2, doc.$3)).toList(),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue.shade600, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildDocumentRow(String label, String? filePath, IconData icon) {
    final hasFile = filePath != null && filePath.isNotEmpty;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: hasFile ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: hasFile ? Colors.black87 : Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (hasFile) ...[
            FutureBuilder<bool>(
              future: _fileService.fileExists(filePath),
              builder: (context, snapshot) {
                final fileExists = snapshot.data ?? false;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      fileExists ? Icons.check_circle : Icons.error,
                      color: fileExists ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      fileExists ? 'Tersedia' : 'File hilang',
                      style: TextStyle(
                        color: fileExists ? Colors.green : Colors.red,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.visibility, size: 16),
                      onPressed: fileExists ? () => _viewFile(filePath) : null,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                    ),
                  ],
                );
              },
            ),
          ] else
            Text(
              'Tidak ada file',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }

  void _viewFile(String filePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: double.maxFinite,
          height: 400,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _fileService.getFileName(filePath),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _buildFilePreview(filePath),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilePreview(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    
    if (['jpg', 'jpeg', 'png'].contains(extension)) {
      return Image.file(
        File(filePath),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 48, color: Colors.red),
                SizedBox(height: 8),
                Text('Gagal memuat gambar'),
              ],
            ),
          );
        },
      );
    } else if (extension == 'pdf') {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.picture_as_pdf, size: 48, color: Colors.red),
            SizedBox(height: 8),
            Text('File PDF'),
            SizedBox(height: 8),
            Text(
              'Gunakan aplikasi PDF viewer untuk membuka file ini',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    } else {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.insert_drive_file, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text('Preview tidak tersedia'),
          ],
        ),
      );
    }
  }

  void _launchPhone(String phoneNumber) {
    // Implementasi untuk memanggil nomor telepon
    // Bisa menggunakan url_launcher package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Memanggil $phoneNumber')),
    );
  }

  void _launchEmail(String email) {
    // Implementasi untuk membuka email
    // Bisa menggunakan url_launcher package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Membuka email $email')),
    );
  }

  Future<void> _navigateToEdit() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddPegawaiScreen(pegawai: _pegawai),
      ),
    );
    
    if (result == true) {
      // Refresh data if needed
      Navigator.of(context).pop(true);
    }
  }
}
