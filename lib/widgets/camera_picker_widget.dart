import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../services/file_service.dart';

class CameraPickerWidget extends StatefulWidget {
  final String label;
  final Function(String?) onImageSelected;

  const CameraPickerWidget({
    Key? key,
    required this.label,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  State<CameraPickerWidget> createState() => _CameraPickerWidgetState();
}

class _CameraPickerWidgetState extends State<CameraPickerWidget> {
  final FileService _fileService = FileService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _pickFromCamera,
                    icon: _isLoading 
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.camera_alt),
                    label: const Text('Ambil Foto'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _pickFromGallery,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Dari Galeri'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    // Haptic feedback
    HapticFeedback.selectionClick();
    
    setState(() => _isLoading = true);
    
    try {
      // Cek permission terlebih dahulu
      await _checkCameraPermission();
      
      print('🎥 Membuka kamera...');
      
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (image != null) {
        print('✅ Foto berhasil diambil: ${image.path}');
        
        // Simpan file
        final savedPath = await _fileService.saveImageFile(image.path, 'camera');
        
        if (savedPath != null) {
          widget.onImageSelected(savedPath);
          _showSuccessMessage('Foto berhasil disimpan!');
        } else {
          throw Exception('Gagal menyimpan foto');
        }
      } else {
        print('ℹ️ Pengambilan foto dibatalkan');
        _showInfoMessage('Pengambilan foto dibatalkan');
      }
    } catch (e) {
      print('❌ Error taking photo: $e');
      _handleCameraError(e);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickFromGallery() async {
    HapticFeedback.selectionClick();
    
    setState(() => _isLoading = true);
    
    try {
      print('📷 Membuka galeri...');
      
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        print('✅ Foto dipilih dari galeri: ${image.path}');
        
        // Simpan file
        final savedPath = await _fileService.saveImageFile(image.path, 'gallery');
        
        if (savedPath != null) {
          widget.onImageSelected(savedPath);
          _showSuccessMessage('Foto berhasil dipilih!');
        } else {
          throw Exception('Gagal menyimpan foto');
        }
      } else {
        print('ℹ️ Pemilihan foto dibatalkan');
        _showInfoMessage('Pemilihan foto dibatalkan');
      }
    } catch (e) {
      print('❌ Error picking from gallery: $e');
      _showErrorMessage('Gagal memilih foto dari galeri: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _checkCameraPermission() async {
    // Ini adalah placeholder - implementasi permission check bisa ditambahkan
    // Untuk saat ini, kita biarkan system iOS handle permission
    print('📋 Checking camera permission...');
  }

  void _handleCameraError(dynamic error) {
    String message = 'Gagal mengambil foto dari kamera';
    
    if (error.toString().contains('camera_access_denied')) {
      message = 'Akses kamera ditolak. Silakan aktifkan di Pengaturan > Privacy > Camera';
    } else if (error.toString().contains('camera_unavailable')) {
      message = 'Kamera tidak tersedia pada perangkat ini';
    } else if (error.toString().contains('photo_access_denied')) {
      message = 'Akses foto ditolak. Silakan aktifkan di Pengaturan > Privacy > Photos';
    }
    
    _showErrorMessage(message);
  }

  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showInfoMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.info, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Tutup',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }
}
