# Data Pegawai RSDM
tes branch push ke main origin
Aplikasi pendataan pegawai untuk Rumah Sakit Daerah Madani (RSDM) yang dibuat dengan Flutter. Aplikasi ini memungkinkan pengelolaan data pegawai secara komprehensif dengan fitur upload dokumen dalam format JPG dan PDF.

## 🚀 Fitur Utama

### 📋 Manajemen Data Pegawai
- **Data Pribadi Lengkap**: Nama, NIK, tempat/tanggal lahir, jenis kelamin, agama, status perkawinan
- **Alamat Lengkap**: RT/RW, kelurahan, kecamatan, kabupaten, provinsi, kode pos
- **Kontak**: Nomor telepon dan email
- **Pendidikan**: Pendidikan terakhir, jurusan, institusi, tahun lulus
- **Kepegawaian**: Jabatan, departemen, tanggal masuk, status kepegawaian
- **Data Bank**: Nomor rekening dan nama bank
- **Ahli Waris**: Nama, hubungan, dan kontak ahli waris

### 📁 Upload Dokumen
- **Foto Pegawai**: Upload dari kamera atau galeri
- **KTP**: Format JPG/PDF
- **Kartu Keluarga (KK)**: Format JPG/PDF
- **Ijazah**: Format JPG/PDF
- **Sertifikat**: Format JPG/PDF
- **CV/Resume**: Format JPG/PDF

### 🔍 Fitur Pencarian & Filter
- Pencarian berdasarkan nama, NIK, atau jabatan
- Filter berdasarkan departemen
- Statistik total pegawai dan departemen

### 📱 Antarmuka yang User-Friendly
- Desain modern dengan Material 3
- Navigasi yang intuitif
- Form yang terstruktur dengan validasi
- Preview dokumen yang telah diupload

## 🛠️ Teknologi yang Digunakan

- **Framework**: Flutter
- **Database**: SQLite (sqflite)
- **File Management**: file_picker, image_picker, path_provider
- **Form**: flutter_form_builder, form_builder_validators
- **PDF**: pdf, printing
- **Permissions**: permission_handler
- **Date**: intl

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  file_picker: ^8.0.7
  image_picker: ^1.1.2
  path_provider: ^2.1.3
  sqflite: ^2.3.3+1
  path: ^1.9.0
  form_builder_validators: ^11.0.0
  flutter_form_builder: ^10.1.0
  pdf: ^3.11.1
  printing: ^5.12.0
  intl: ^0.20.2
  shared_preferences: ^2.2.3
  permission_handler: ^11.3.1
```

## 🚀 Instalasi & Setup

### Prasyarat
- Flutter SDK (versi 3.0 atau lebih baru)
- Android Studio / VS Code
- Android SDK untuk development Android
- Xcode untuk development iOS (opsional)

### Langkah Instalasi

1. **Clone repository**
```bash
git clone <repository-url>
cd DATA_PEGAWAI_RSDM
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Jalankan aplikasi**
```bash
flutter run
```

### Build untuk Production

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

## 📱 Permissions

### Android
Aplikasi memerlukan permissions berikut yang sudah dikonfigurasi di `android/app/src/main/AndroidManifest.xml`:

- `INTERNET` - Akses internet
- `CAMERA` - Akses kamera
- `READ_EXTERNAL_STORAGE` - Baca file dari storage
- `WRITE_EXTERNAL_STORAGE` - Tulis file ke storage
- `MANAGE_EXTERNAL_STORAGE` - Kelola storage eksternal

### iOS
Tambahkan konfigurasi berikut di `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Aplikasi memerlukan akses kamera untuk mengambil foto pegawai</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Aplikasi memerlukan akses galeri untuk memilih foto</string>
```

## 📁 Struktur Project

```
lib/
├── models/
│   └── pegawai_model.dart      # Model data pegawai
├── database/
│   └── database_helper.dart    # Helper database SQLite
├── services/
│   └── file_service.dart       # Service untuk upload/download file
├── screens/
│   ├── home_screen.dart        # Halaman utama/daftar pegawai
│   ├── add_pegawai_screen.dart # Form tambah/edit pegawai
│   └── detail_pegawai_screen.dart # Detail pegawai
├── widgets/
│   └── file_upload_widget.dart # Widget upload file
└── main.dart                   # Entry point aplikasi
```

## 🗃️ Database Schema

### Tabel `pegawai`
- `id` (INTEGER PRIMARY KEY)
- `nama` (TEXT NOT NULL)
- `nik` (TEXT NOT NULL UNIQUE)
- `tempat_lahir` (TEXT NOT NULL)
- `tanggal_lahir` (INTEGER NOT NULL)
- `jenis_kelamin` (TEXT NOT NULL)
- `agama` (TEXT NOT NULL)
- `status_perkawinan` (TEXT NOT NULL)
- `alamat_lengkap` (TEXT NOT NULL)
- `rt`, `rw` (TEXT NOT NULL)
- `kelurahan`, `kecamatan`, `kabupaten`, `provinsi` (TEXT NOT NULL)
- `kode_pos` (TEXT NOT NULL)
- `no_telepon`, `email` (TEXT NOT NULL)
- `pendidikan_terakhir`, `jurusan`, `institusi_pendidikan`, `tahun_lulus` (TEXT NOT NULL)
- `jabatan`, `departemen` (TEXT NOT NULL)
- `tanggal_masuk` (INTEGER NOT NULL)
- `status_kepegawaian` (TEXT NOT NULL)
- `no_rekening`, `nama_bank` (TEXT NOT NULL)
- `nama_ahli_waris`, `hubungan_ahli_waris`, `no_telepon_ahli_waris` (TEXT NOT NULL)
- `ktp_file_path`, `kk_file_path`, `ijazah_file_path`, `sertifikat_file_path`, `cv_file_path`, `foto_file_path` (TEXT)
- `created_at`, `updated_at` (INTEGER)

## 🔧 Fitur yang Akan Datang

- [ ] Export data ke Excel/PDF
- [ ] Backup dan restore database
- [ ] Notifikasi untuk ulang tahun pegawai
- [ ] Dashboard analytics
- [ ] Sync dengan cloud storage
- [ ] Dark mode theme
- [ ] Multi-language support

## 🤝 Kontribusi

Kontribusi sangat diterima! Silakan:

1. Fork repository ini
2. Buat branch fitur baru (`git checkout -b feature/amazing-feature`)
3. Commit perubahan (`git commit -m 'Add some amazing feature'`)
4. Push ke branch (`git push origin feature/amazing-feature`)
5. Buat Pull Request

## 📄 Lisensi

Project ini dilisensikan di bawah MIT License - lihat file [LICENSE](LICENSE) untuk detail.

## 👨‍💻 Pengembang

**Tim Pengembangan RSDM**
- Email: development@rsdm.com
- Website: https://rsdm.com

## 📞 Support

Jika Anda mengalami masalah atau memiliki pertanyaan:

1. Buka issue di GitHub repository
2. Email: support@rsdm.com
3. WhatsApp: +62-xxx-xxxx-xxxx

---

**Data Pegawai RSDM** - Mengelola data pegawai dengan mudah dan aman 🏥
