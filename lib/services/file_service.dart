import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileService {
  static final FileService _instance = FileService._internal();
  factory FileService() => _instance;
  FileService._internal();

  final ImagePicker _imagePicker = ImagePicker();

  // Membuat direktori untuk menyimpan file
  Future<String> _getDocumentDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final pegawaiDir = Directory('${directory.path}/pegawai_documents');
    if (!await pegawaiDir.exists()) {
      await pegawaiDir.create(recursive: true);
    }
    return pegawaiDir.path;
  }

  // Upload foto dari kamera atau galeri
  Future<String?> pickImage({required ImageSource source}) async {
    try {
      // Tambahan logging untuk debugging
      print('Attempting to pick image from: ${source.name}');
      
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
        requestFullMetadata: false, // Tambahan untuk iOS
      );

      print('Image picked: ${image?.path}');

      if (image != null) {
        // Validasi file sebelum menyimpan
        final file = File(image.path);
        if (!await file.exists()) {
          print('Error: Picked image file does not exist');
          throw Exception('File gambar tidak ditemukan');
        }
        
        final fileSize = await file.length();
        print('Image file size: $fileSize bytes');
        
        if (fileSize == 0) {
          print('Error: Picked image file is empty');
          throw Exception('File gambar kosong');
        }
        
        return await _saveFile(file, 'foto');
      }
      
      print('No image was selected');
      return null;
    } catch (e) {
      print('Error picking image: $e');
      rethrow; // Re-throw untuk ditangkap oleh UI
    }
  }

  // Upload dokumen PDF atau JPG
  Future<String?> pickDocument({
    required String documentType,
    List<String>? allowedExtensions,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions ?? ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        return await _saveFile(file, documentType);
      }
      return null;
    } catch (e) {
      print('Error picking document: $e');
      return null;
    }
  }

  // Menyimpan file ke direktori aplikasi
  Future<String> _saveFile(File sourceFile, String documentType) async {
    try {
      final String documentsPath = await _getDocumentDirectory();
      final String fileName = '${documentType}_${DateTime.now().millisecondsSinceEpoch}${path.extension(sourceFile.path)}';
      final String targetPath = path.join(documentsPath, fileName);
      
      final File targetFile = await sourceFile.copy(targetPath);
      return targetFile.path;
    } catch (e) {
      print('Error saving file: $e');
      rethrow;
    }
  }

  // Method khusus untuk menyimpan file gambar
  Future<String?> saveImageFile(String sourcePath, String prefix) async {
    try {
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        throw Exception('File sumber tidak ditemukan');
      }

      final String documentsPath = await _getDocumentDirectory();
      final String fileName = '${prefix}_${DateTime.now().millisecondsSinceEpoch}${path.extension(sourcePath)}';
      final String targetPath = path.join(documentsPath, fileName);
      
      print('Copying file from $sourcePath to $targetPath');
      final File targetFile = await sourceFile.copy(targetPath);
      
      // Verifikasi file tersimpan dengan benar
      if (await targetFile.exists() && await targetFile.length() > 0) {
        print('File saved successfully: ${targetFile.path}');
        return targetFile.path;
      } else {
        throw Exception('File gagal disimpan atau kosong');
      }
    } catch (e) {
      print('Error saving image file: $e');
      return null;
    }
  }

  // Hapus file dari storage
  Future<bool> deleteFile(String? filePath) async {
    try {
      if (filePath == null || filePath.isEmpty) return false;
      
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }

  // Cek apakah file ada
  Future<bool> fileExists(String? filePath) async {
    if (filePath == null || filePath.isEmpty) return false;
    return await File(filePath).exists();
  }

  // Dapatkan ukuran file dalam bytes
  Future<int> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.length();
      }
      return 0;
    } catch (e) {
      print('Error getting file size: $e');
      return 0;
    }
  }

  // Format ukuran file untuk display
  String formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    var i = (bytes.bitLength - 1) ~/ 10;
    return '${(bytes / (1 << (i * 10))).toStringAsFixed(1)} ${suffixes[i]}';
  }

  // Dapatkan nama file dari path
  String getFileName(String filePath) {
    return path.basename(filePath);
  }

  // Validasi tipe file
  bool isValidFileType(String filePath, List<String> allowedExtensions) {
    final extension = path.extension(filePath).toLowerCase().replaceAll('.', '');
    return allowedExtensions.contains(extension);
  }

  // Upload multiple files untuk sertifikat
  Future<List<String>> pickMultipleDocuments({
    required String documentType,
    List<String>? allowedExtensions,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions ?? ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        List<String> savedPaths = [];
        
        for (var platformFile in result.files) {
          if (platformFile.path != null) {
            final file = File(platformFile.path!);
            final savedPath = await _saveFile(file, documentType);
            savedPaths.add(savedPath);
          }
        }
        
        return savedPaths;
      }
      return [];
    } catch (e) {
      print('Error picking multiple documents: $e');
      return [];
    }
  }

  // Cleanup - hapus file lama yang tidak terpakai
  Future<void> cleanupOldFiles({int daysOld = 30}) async {
    try {
      final documentsPath = await _getDocumentDirectory();
      final directory = Directory(documentsPath);
      
      if (await directory.exists()) {
        final files = directory.listSync();
        final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
        
        for (var entity in files) {
          if (entity is File) {
            final stat = await entity.stat();
            if (stat.modified.isBefore(cutoffDate)) {
              await entity.delete();
            }
          }
        }
      }
    } catch (e) {
      print('Error cleaning up old files: $e');
    }
  }
}
