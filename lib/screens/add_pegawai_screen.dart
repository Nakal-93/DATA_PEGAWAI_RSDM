import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/pegawai_model.dart';
import '../database/database_helper.dart';
import '../services/file_service.dart';

class AddPegawaiScreen extends StatefulWidget {
  final PegawaiModel? pegawai; // Untuk edit mode
  
  const AddPegawaiScreen({Key? key, this.pegawai}) : super(key: key);

  @override
  State<AddPegawaiScreen> createState() => _AddPegawaiScreenState();
}

class _AddPegawaiScreenState extends State<AddPegawaiScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  bool _isLoading = false;
  bool get _isEditMode => widget.pegawai != null;
  
  // File paths
  String? _ktpFilePath;
  String? _kkFilePath;
  String? _ijazahFilePath;
  String? _sertifikatFilePath;
  String? _cvFilePath;
  String? _fotoFilePath;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _loadExistingData();
    }
  }

  void _loadExistingData() {
    final pegawai = widget.pegawai!;
    _ktpFilePath = pegawai.ktpFilePath;
    _kkFilePath = pegawai.kkFilePath;
    _ijazahFilePath = pegawai.ijazahFilePath;
    _sertifikatFilePath = pegawai.sertifikatFilePath;
    _cvFilePath = pegawai.cvFilePath;
    _fotoFilePath = pegawai.fotoFilePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          _isEditMode ? 'Edit Pegawai' : 'Tambah Pegawai',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey.shade800,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey.shade600),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: FormBuilder(
        key: _formKey,
        initialValue: _isEditMode ? _getInitialValues() : {},
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Profile Picture Section
              _buildProfilePictureSection(),
              
              // Form Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionCard('Data Pribadi', _buildPersonalDataSection()),
                    const SizedBox(height: 20),
                    _buildSectionCard('Alamat', _buildAddressSection()),
                    const SizedBox(height: 20),
                    _buildSectionCard('Kontak', _buildContactSection()),
                    const SizedBox(height: 20),
                    _buildSectionCard('Pendidikan', _buildEducationSection()),
                    const SizedBox(height: 20),
                    _buildSectionCard('Kepegawaian', _buildEmploymentSection()),
                    const SizedBox(height: 20),
                    _buildSectionCard('Data Bank', _buildBankDataSection()),
                    const SizedBox(height: 20),
                    _buildSectionCard('Ahli Waris', _buildHeirSection()),
                    const SizedBox(height: 20),
                    _buildSectionCard('Dokumen', _buildDocumentSection()),
                    const SizedBox(height: 32),
                    _buildSaveButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _showProfileImageOptions(),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blue.shade100,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: _fotoFilePath != null && _fotoFilePath!.isNotEmpty
                      ? Image.file(
                          File(_fotoFilePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
                        )
                      : _buildDefaultAvatar(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _showProfileImageOptions(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Colors.blue.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _fotoFilePath != null ? 'Ganti Foto' : 'Tambah Foto',
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey.shade100,
      child: Icon(
        Icons.person,
        size: 60,
        color: Colors.grey.shade400,
      ),
    );
  }

  Widget _buildSectionCard(String title, Widget content) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            content,
          ],
        ),
      ),
    );
  }

  void _showProfileImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pilih Foto Profil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildImageOptionButton(
                      icon: Icons.camera_alt,
                      label: 'Kamera',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImageFromCamera();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildImageOptionButton(
                      icon: Icons.photo_library,
                      label: 'Galeri',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImageFromGallery();
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (_fotoFilePath != null)
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: _buildImageOptionButton(
                    icon: Icons.delete,
                    label: 'Hapus Foto',
                    color: Colors.red.shade50,
                    iconColor: Colors.red.shade600,
                    textColor: Colors.red.shade600,
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _fotoFilePath = null);
                    },
                  ),
                ),
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
    Color? iconColor,
    Color? textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color ?? Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: (color ?? Colors.blue.shade50) == Colors.blue.shade50 
                ? Colors.blue.shade200 
                : Colors.red.shade200,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: iconColor ?? Colors.blue.shade600,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: textColor ?? Colors.blue.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    try {
      setState(() => _isLoading = true);
      // Menggunakan FileService untuk konsistensi
      final fileService = FileService();
      final filePath = await fileService.pickImage(source: ImageSource.camera);
      if (filePath != null) {
        setState(() => _fotoFilePath = filePath);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error mengambil foto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      setState(() => _isLoading = true);
      // Menggunakan FileService untuk konsistensi
      final fileService = FileService();
      final filePath = await fileService.pickImage(source: ImageSource.gallery);
      if (filePath != null) {
        setState(() => _fotoFilePath = filePath);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error memilih foto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField({
    required String name,
    required String label,
    required IconData icon,
    String? hint,
    bool isRequired = false,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return FormBuilderTextField(
      name: name,
      decoration: InputDecoration(
        labelText: '$label${isRequired ? ' *' : ''}',
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.blue.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }

  Widget _buildDateField({
    required String name,
    required String label,
    required IconData icon,
    bool isRequired = false,
    String? Function(DateTime?)? validator,
  }) {
    return FormBuilderDateTimePicker(
      name: name,
      decoration: InputDecoration(
        labelText: '$label${isRequired ? ' *' : ''}',
        prefixIcon: Icon(icon, color: Colors.blue.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      inputType: InputType.date,
      format: DateFormat('dd/MM/yyyy'),
      validator: validator,
    );
  }

  Widget _buildDropdownField({
    required String name,
    required String label,
    required IconData icon,
    required List<String> items,
    bool isRequired = false,
    String? Function(String?)? validator,
  }) {
    return FormBuilderDropdown<String>(
      name: name,
      decoration: InputDecoration(
        labelText: '$label${isRequired ? ' *' : ''}',
        prefixIcon: Icon(icon, color: Colors.blue.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: validator,
      items: items.map((item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      )).toList(),
    );
  }

  Widget _buildPersonalDataSection() {
    return Column(
      children: [
        _buildTextField(
          name: 'nama',
          label: 'Nama Lengkap',
          icon: Icons.person,
          isRequired: true,
          validator: FormBuilderValidators.required(
            errorText: 'Nama wajib diisi',
          ),
        ),
        
        const SizedBox(height: 20),
        _buildTextField(
          name: 'nik',
          label: 'NIK',
          icon: Icons.credit_card,
          hint: 'Nomor Induk Kependudukan',
          isRequired: true,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: 'NIK wajib diisi'),
            FormBuilderValidators.minLength(16, errorText: 'NIK harus 16 digit'),
            FormBuilderValidators.maxLength(16, errorText: 'NIK harus 16 digit'),
            FormBuilderValidators.numeric(errorText: 'NIK harus berupa angka'),
          ]),
        ),
        
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildTextField(
                name: 'tempat_lahir',
                label: 'Tempat Lahir',
                icon: Icons.location_city,
                isRequired: true,
                validator: FormBuilderValidators.required(
                  errorText: 'Tempat lahir wajib diisi',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: _buildDateField(
                name: 'tanggal_lahir',
                label: 'Tanggal Lahir',
                icon: Icons.calendar_today,
                isRequired: true,
                validator: FormBuilderValidators.required(
                  errorText: 'Tanggal lahir wajib diisi',
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                name: 'jenis_kelamin',
                label: 'Jenis Kelamin',
                icon: Icons.wc,
                isRequired: true,
                items: ['Laki-laki', 'Perempuan'],
                validator: FormBuilderValidators.required(
                  errorText: 'Jenis kelamin wajib dipilih',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDropdownField(
                name: 'agama',
                label: 'Agama',
                icon: Icons.brightness_7,
                isRequired: true,
                items: ['Islam', 'Kristen', 'Katolik', 'Hindu', 'Buddha', 'Konghucu'],
                validator: FormBuilderValidators.required(
                  errorText: 'Agama wajib dipilih',
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        _buildDropdownField(
          name: 'status_perkawinan',
          label: 'Status Perkawinan',
          icon: Icons.favorite,
          isRequired: true,
          items: ['Belum Kawin', 'Kawin', 'Cerai Hidup', 'Cerai Mati'],
          validator: FormBuilderValidators.required(
            errorText: 'Status perkawinan wajib dipilih',
          ),
        ),
      ],
    );
  }

  Widget _buildAddressSection() {
    return Column(
      children: [
        _buildTextField(
          name: 'alamat_lengkap',
          label: 'Alamat Lengkap',
          icon: Icons.home,
          isRequired: true,
          maxLines: 3,
          validator: FormBuilderValidators.required(
            errorText: 'Alamat wajib diisi',
          ),
        ),
        
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                name: 'rt',
                label: 'RT',
                icon: Icons.location_on,
                isRequired: true,
                validator: FormBuilderValidators.required(
                  errorText: 'RT wajib diisi',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                name: 'rw',
                label: 'RW',
                icon: Icons.location_on,
                isRequired: true,
                validator: FormBuilderValidators.required(
                  errorText: 'RW wajib diisi',
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        _buildTextField(
          name: 'kelurahan',
          label: 'Kelurahan/Desa',
          icon: Icons.location_city,
          isRequired: true,
          validator: FormBuilderValidators.required(
            errorText: 'Kelurahan wajib diisi',
          ),
        ),
        
        const SizedBox(height: 20),
        _buildTextField(
          name: 'kecamatan',
          label: 'Kecamatan',
          icon: Icons.location_city,
          isRequired: true,
          validator: FormBuilderValidators.required(
            errorText: 'Kecamatan wajib diisi',
          ),
        ),
        
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildTextField(
                name: 'kabupaten',
                label: 'Kabupaten/Kota',
                icon: Icons.location_city,
                isRequired: true,
                validator: FormBuilderValidators.required(
                  errorText: 'Kabupaten wajib diisi',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: _buildTextField(
                name: 'provinsi',
                label: 'Provinsi',
                icon: Icons.map,
                isRequired: true,
                validator: FormBuilderValidators.required(
                  errorText: 'Provinsi wajib diisi',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                name: 'kode_pos',
                label: 'Kode Pos',
                icon: Icons.mail,
                isRequired: true,
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: 'Kode pos wajib diisi'),
                  FormBuilderValidators.numeric(errorText: 'Kode pos harus berupa angka'),
                  FormBuilderValidators.minLength(5, errorText: 'Kode pos harus 5 digit'),
                  FormBuilderValidators.maxLength(5, errorText: 'Kode pos harus 5 digit'),
                ]),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      children: [
        _buildTextField(
          name: 'no_telepon',
          label: 'Nomor Telepon',
          icon: Icons.phone,
          hint: '08xxxxxxxxxx',
          isRequired: true,
          keyboardType: TextInputType.phone,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: 'Nomor telepon wajib diisi'),
            FormBuilderValidators.numeric(errorText: 'Nomor telepon harus berupa angka'),
          ]),
        ),
        
        const SizedBox(height: 20),
        _buildTextField(
          name: 'email',
          label: 'Email',
          icon: Icons.email,
          isRequired: true,
          keyboardType: TextInputType.emailAddress,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: 'Email wajib diisi'),
            FormBuilderValidators.email(errorText: 'Format email tidak valid'),
          ]),
        ),
      ],
    );
  }

  Widget _buildEducationSection() {
    return Column(
      children: [
        _buildDropdownField(
          name: 'pendidikan_terakhir',
          label: 'Pendidikan Terakhir',
          icon: Icons.school,
          items: ['SD', 'SMP', 'SMA/SMK', 'D1', 'D2', 'D3', 'S1', 'S2', 'S3'],
          isRequired: true,
          validator: FormBuilderValidators.required(
            errorText: 'Pendidikan terakhir wajib dipilih',
          ),
        ),
        
        const SizedBox(height: 20),
        _buildTextField(
          name: 'jurusan',
          label: 'Jurusan',
          icon: Icons.library_books,
          isRequired: true,
          validator: FormBuilderValidators.required(
            errorText: 'Jurusan wajib diisi',
          ),
        ),
        
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildTextField(
                name: 'institusi_pendidikan',
                label: 'Institusi Pendidikan',
                icon: Icons.business,
                isRequired: true,
                validator: FormBuilderValidators.required(
                  errorText: 'Institusi pendidikan wajib diisi',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                name: 'tahun_lulus',
                label: 'Tahun Lulus',
                icon: Icons.calendar_today,
                isRequired: true,
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: 'Tahun lulus wajib diisi'),
                  FormBuilderValidators.numeric(errorText: 'Tahun harus berupa angka'),
                  FormBuilderValidators.minLength(4, errorText: 'Format tahun tidak valid'),
                  FormBuilderValidators.maxLength(4, errorText: 'Format tahun tidak valid'),
                ]),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmploymentSection() {
    return Column(
      children: [
        _buildTextField(
          name: 'jabatan',
          label: 'Jabatan',
          icon: Icons.work,
          isRequired: true,
          validator: FormBuilderValidators.required(
            errorText: 'Jabatan wajib diisi',
          ),
        ),
        
        const SizedBox(height: 20),
        _buildTextField(
          name: 'departemen',
          label: 'Departemen',
          icon: Icons.business_center,
          isRequired: true,
          validator: FormBuilderValidators.required(
            errorText: 'Departemen wajib diisi',
          ),
        ),
        
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                name: 'tanggal_masuk',
                label: 'Tanggal Masuk',
                icon: Icons.event,
                isRequired: true,
                validator: FormBuilderValidators.required(
                  errorText: 'Tanggal masuk wajib diisi',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDropdownField(
                name: 'status_kepegawaian',
                label: 'Status Kepegawaian',
                icon: Icons.badge,
                items: ['Tetap', 'Kontrak', 'Magang', 'Freelance'],
                isRequired: true,
                validator: FormBuilderValidators.required(
                  errorText: 'Status kepegawaian wajib dipilih',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBankDataSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                name: 'no_rekening',
                label: 'Nomor Rekening',
                icon: Icons.account_balance,
                isRequired: true,
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: 'Nomor rekening wajib diisi'),
                  FormBuilderValidators.numeric(errorText: 'Nomor rekening harus berupa angka'),
                ]),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                name: 'nama_bank',
                label: 'Nama Bank',
                icon: Icons.account_balance_wallet,
                isRequired: true,
                validator: FormBuilderValidators.required(
                  errorText: 'Nama bank wajib diisi',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeirSection() {
    return Column(
      children: [
        _buildTextField(
          name: 'nama_ahli_waris',
          label: 'Nama Ahli Waris',
          icon: Icons.family_restroom,
          isRequired: true,
          validator: FormBuilderValidators.required(
            errorText: 'Nama ahli waris wajib diisi',
          ),
        ),
        
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                name: 'hubungan_ahli_waris',
                label: 'Hubungan',
                icon: Icons.people,
                items: ['Orang Tua', 'Suami/Istri', 'Anak', 'Saudara', 'Lainnya'],
                isRequired: true,
                validator: FormBuilderValidators.required(
                  errorText: 'Hubungan ahli waris wajib dipilih',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                name: 'no_telepon_ahli_waris',
                label: 'No. Telepon Ahli Waris',
                icon: Icons.phone,
                isRequired: true,
                keyboardType: TextInputType.phone,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: 'Nomor telepon ahli waris wajib diisi'),
                  FormBuilderValidators.numeric(errorText: 'Nomor telepon harus berupa angka'),
                ]),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDocumentSection() {
    return Column(
      children: [
        // Note: Foto profil sudah ada di bagian atas, jadi tidak perlu di sini lagi
        _buildModernFileUpload(
          label: 'KTP',
          icon: Icons.credit_card,
          filePath: _ktpFilePath,
          onFileSelected: (path) => setState(() => _ktpFilePath = path),
          documentType: 'ktp',
        ),
        
        const SizedBox(height: 16),
        _buildModernFileUpload(
          label: 'Kartu Keluarga (KK)',
          icon: Icons.family_restroom,
          filePath: _kkFilePath,
          onFileSelected: (path) => setState(() => _kkFilePath = path),
          documentType: 'kk',
        ),
        
        const SizedBox(height: 16),
        _buildModernFileUpload(
          label: 'Ijazah',
          icon: Icons.school,
          filePath: _ijazahFilePath,
          onFileSelected: (path) => setState(() => _ijazahFilePath = path),
          documentType: 'ijazah',
        ),
        
        const SizedBox(height: 16),
        _buildModernFileUpload(
          label: 'Sertifikat',
          icon: Icons.verified,
          filePath: _sertifikatFilePath,
          onFileSelected: (path) => setState(() => _sertifikatFilePath = path),
          documentType: 'sertifikat',
        ),
        
        const SizedBox(height: 16),
        _buildModernFileUpload(
          label: 'CV/Resume',
          icon: Icons.description,
          filePath: _cvFilePath,
          onFileSelected: (path) => setState(() => _cvFilePath = path),
          documentType: 'cv',
        ),
      ],
    );
  }

  Widget _buildModernFileUpload({
    required String label,
    required IconData icon,
    required String? filePath,
    required Function(String?) onFileSelected,
    required String documentType,
  }) {
    final hasFile = filePath != null && filePath.isNotEmpty;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasFile ? Colors.green.shade300 : Colors.grey.shade300,
          width: 1,
        ),
        color: hasFile ? Colors.green.shade50 : Colors.grey.shade50,
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: hasFile ? Colors.green.shade100 : Colors.grey.shade200,
              child: Icon(
                icon,
                color: hasFile ? Colors.green.shade600 : Colors.grey.shade600,
              ),
            ),
            title: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            subtitle: hasFile
                ? Text(
                    'File dipilih: ${filePath.split('/').last}',
                    style: TextStyle(
                      color: Colors.green.shade600,
                      fontSize: 12,
                    ),
                  )
                : const Text(
                    'Belum ada file dipilih',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
            trailing: hasFile
                ? Icon(
                    Icons.check_circle,
                    color: Colors.green.shade600,
                  )
                : Icon(
                    Icons.upload_file,
                    color: Colors.grey.shade600,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showFilePickerOptions(onFileSelected),
                    icon: const Icon(Icons.camera_alt, size: 18),
                    label: const Text('Kamera'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue.shade600,
                      side: BorderSide(color: Colors.blue.shade200),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showFilePickerOptions(onFileSelected),
                    icon: const Icon(Icons.photo_library, size: 18),
                    label: const Text('Galeri'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue.shade600,
                      side: BorderSide(color: Colors.blue.shade200),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                if (hasFile) ...[
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 40,
                    child: IconButton(
                      onPressed: () => onFileSelected(null),
                      icon: const Icon(Icons.delete, size: 18),
                      style: IconButton.styleFrom(
                        foregroundColor: Colors.red.shade600,
                        backgroundColor: Colors.red.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilePickerOptions(Function(String?) onFileSelected) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pilih Sumber File',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildImageOptionButton(
                      icon: Icons.camera_alt,
                      label: 'Kamera',
                      onTap: () {
                        Navigator.pop(context);
                        // Implement camera picker
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildImageOptionButton(
                      icon: Icons.photo_library,
                      label: 'Galeri',
                      onTap: () {
                        Navigator.pop(context);
                        // Implement gallery picker
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade700],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _savePegawai,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Menyimpan...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Text(
                _isEditMode ? 'Update Pegawai' : 'Simpan Pegawai',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Map<String, dynamic> _getInitialValues() {
    final pegawai = widget.pegawai!;
    return {
      'nama': pegawai.nama,
      'nik': pegawai.nik,
      'tempat_lahir': pegawai.tempatLahir,
      'tanggal_lahir': pegawai.tanggalLahir,
      'jenis_kelamin': pegawai.jenisKelamin,
      'agama': pegawai.agama,
      'status_perkawinan': pegawai.statusPerkawinan,
      'alamat_lengkap': pegawai.alamatLengkap,
      'rt': pegawai.rt,
      'rw': pegawai.rw,
      'kelurahan': pegawai.kelurahan,
      'kecamatan': pegawai.kecamatan,
      'kabupaten': pegawai.kabupaten,
      'provinsi': pegawai.provinsi,
      'kode_pos': pegawai.kodePos,
      'no_telepon': pegawai.noTelepon,
      'email': pegawai.email,
      'pendidikan_terakhir': pegawai.pendidikanTerakhir,
      'jurusan': pegawai.jurusan,
      'institusi_pendidikan': pegawai.institusiPendidikan,
      'tahun_lulus': pegawai.tahunLulus,
      'jabatan': pegawai.jabatan,
      'departemen': pegawai.departemen,
      'tanggal_masuk': pegawai.tanggalMasuk,
      'status_kepegawaian': pegawai.statusKepegawaian,
      'no_rekening': pegawai.noRekening,
      'nama_bank': pegawai.namaBank,
      'nama_ahli_waris': pegawai.namaAhliWaris,
      'hubungan_ahli_waris': pegawai.hubunganAhliWaris,
      'no_telepon_ahli_waris': pegawai.noTeleponAhliWaris,
    };
  }

  Future<void> _savePegawai() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() => _isLoading = true);
      
      try {
        final formData = _formKey.currentState!.value;
        
        final pegawai = PegawaiModel(
          id: _isEditMode ? widget.pegawai!.id : null,
          nama: formData['nama'],
          nik: formData['nik'],
          tempatLahir: formData['tempat_lahir'],
          tanggalLahir: formData['tanggal_lahir'],
          jenisKelamin: formData['jenis_kelamin'],
          agama: formData['agama'],
          statusPerkawinan: formData['status_perkawinan'],
          alamatLengkap: formData['alamat_lengkap'],
          rt: formData['rt'],
          rw: formData['rw'],
          kelurahan: formData['kelurahan'],
          kecamatan: formData['kecamatan'],
          kabupaten: formData['kabupaten'],
          provinsi: formData['provinsi'],
          kodePos: formData['kode_pos'],
          noTelepon: formData['no_telepon'],
          email: formData['email'],
          pendidikanTerakhir: formData['pendidikan_terakhir'],
          jurusan: formData['jurusan'],
          institusiPendidikan: formData['institusi_pendidikan'],
          tahunLulus: formData['tahun_lulus'],
          jabatan: formData['jabatan'],
          departemen: formData['departemen'],
          tanggalMasuk: formData['tanggal_masuk'],
          statusKepegawaian: formData['status_kepegawaian'],
          noRekening: formData['no_rekening'],
          namaBank: formData['nama_bank'],
          namaAhliWaris: formData['nama_ahli_waris'],
          hubunganAhliWaris: formData['hubungan_ahli_waris'],
          noTeleponAhliWaris: formData['no_telepon_ahli_waris'],
          ktpFilePath: _ktpFilePath,
          kkFilePath: _kkFilePath,
          ijazahFilePath: _ijazahFilePath,
          sertifikatFilePath: _sertifikatFilePath,
          cvFilePath: _cvFilePath,
          fotoFilePath: _fotoFilePath,
          createdAt: _isEditMode ? widget.pegawai!.createdAt : DateTime.now(),
          updatedAt: _isEditMode ? DateTime.now() : null,
        );

        if (_isEditMode) {
          await _dbHelper.updatePegawai(pegawai);
        } else {
          await _dbHelper.insertPegawai(pegawai);
        }

        if (mounted) {
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isEditMode 
                  ? 'Data pegawai berhasil diupdate!' 
                  : 'Data pegawai berhasil disimpan!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
}
