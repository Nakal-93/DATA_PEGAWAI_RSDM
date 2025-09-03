import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/file_service.dart';

class FileUploadWidget extends StatefulWidget {
  final String label;
  final String? filePath;
  final Function(String?) onFileSelected;
  final List<String> allowedExtensions;
  final bool isImageOnly;
  final String documentType;

  const FileUploadWidget({
    Key? key,
    required this.label,
    this.filePath,
    required this.onFileSelected,
    this.allowedExtensions = const ['pdf', 'jpg', 'jpeg', 'png'],
    this.isImageOnly = false,
    required this.documentType,
  }) : super(key: key);

  @override
  State<FileUploadWidget> createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  final FileService _fileService = FileService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // File info atau upload area
              if (widget.filePath != null && widget.filePath!.isNotEmpty)
                _buildFileInfo()
              else
                _buildUploadArea(),
              
              // Tombol aksi
              _buildActionButtons(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFileInfo() {
    return FutureBuilder<bool>(
      future: _fileService.fileExists(widget.filePath),
      builder: (context, snapshot) {
        final fileExists = snapshot.data ?? false;
        
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                _getFileIcon(),
                size: 32,
                color: fileExists ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _fileService.getFileName(widget.filePath!),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    FutureBuilder<int>(
                      future: _fileService.getFileSize(widget.filePath!),
                      builder: (context, sizeSnapshot) {
                        if (sizeSnapshot.hasData) {
                          return Text(
                            _fileService.formatFileSize(sizeSnapshot.data!),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          );
                        }
                        return Text(
                          fileExists ? 'Mengecek ukuran...' : 'File tidak ditemukan',
                          style: TextStyle(
                            color: fileExists ? Colors.grey.shade600 : Colors.red,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUploadArea() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'Pilih file untuk ${widget.label}',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Format: ${widget.allowedExtensions.join(', ').toUpperCase()}',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          if (widget.isImageOnly) ...[
            Expanded(
              child: _buildActionButton(
                icon: Icons.camera_alt,
                label: 'Kamera',
                onPressed: _isLoading ? null : () => _pickFromCamera(),
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.grey.shade200,
            ),
            Expanded(
              child: _buildActionButton(
                icon: Icons.photo_library,
                label: 'Galeri',
                onPressed: _isLoading ? null : () => _pickFromGallery(),
              ),
            ),
          ] else ...[
            Expanded(
              child: _buildActionButton(
                icon: Icons.folder_open,
                label: 'Pilih File',
                onPressed: _isLoading ? null : () => _pickDocument(),
              ),
            ),
          ],
          
          if (widget.filePath != null && widget.filePath!.isNotEmpty) ...[
            Container(
              width: 1,
              height: 40,
              color: Colors.grey.shade200,
            ),
            Expanded(
              child: _buildActionButton(
                icon: Icons.delete_outline,
                label: 'Hapus',
                onPressed: _isLoading ? null : () => _removeFile(),
                color: Colors.red,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    Color? color,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: _isLoading 
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  color ?? Theme.of(context).primaryColor,
                ),
              ),
            )
          : Icon(icon, size: 18),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: color ?? Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  IconData _getFileIcon() {
    if (widget.filePath == null) return Icons.insert_drive_file;
    
    final extension = widget.filePath!.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  Future<void> _pickFromCamera() async {
    setState(() => _isLoading = true);
    try {
      print('Starting camera picker...');
      final filePath = await _fileService.pickImage(
        source: ImageSource.camera,
      );
      print('Camera picker result: $filePath');
      
      if (filePath != null) {
        widget.onFileSelected(filePath);
        _showSuccessSnackBar('Foto berhasil diambil dari kamera');
      } else {
        _showInfoSnackBar('Pengambilan foto dibatalkan');
      }
    } catch (e) {
      print('Error in _pickFromCamera: $e');
      String errorMessage = 'Gagal mengambil foto dari kamera';
      
      if (e.toString().contains('permission')) {
        errorMessage = 'Izin kamera diperlukan. Silakan aktifkan di pengaturan.';
      } else if (e.toString().contains('not found') || e.toString().contains('tidak ditemukan')) {
        errorMessage = 'File gambar tidak ditemukan. Coba lagi.';
      } else if (e.toString().contains('empty') || e.toString().contains('kosong')) {
        errorMessage = 'File gambar kosong. Coba ambil foto lagi.';
      }
      
      _showErrorSnackBar(errorMessage);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickFromGallery() async {
    setState(() => _isLoading = true);
    try {
      final filePath = await _fileService.pickImage(
        source: ImageSource.gallery,
      );
      widget.onFileSelected(filePath);
    } catch (e) {
      _showErrorSnackBar('Gagal mengambil foto dari galeri');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickDocument() async {
    setState(() => _isLoading = true);
    try {
      final filePath = await _fileService.pickDocument(
        documentType: widget.documentType,
        allowedExtensions: widget.allowedExtensions,
      );
      widget.onFileSelected(filePath);
    } catch (e) {
      _showErrorSnackBar('Gagal memilih dokumen');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removeFile() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus File'),
        content: Text('Apakah Anda yakin ingin menghapus file ${widget.label}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await _fileService.deleteFile(widget.filePath);
        widget.onFileSelected(null);
      } catch (e) {
        _showErrorSnackBar('Gagal menghapus file');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
