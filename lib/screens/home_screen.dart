import 'dart:io';
import 'package:flutter/material.dart';
import '../models/pegawai_model.dart';
import '../database/database_helper.dart';
import 'add_pegawai_screen.dart';
import 'detail_pegawai_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _searchController = TextEditingController();
  
  List<PegawaiModel> _pegawaiList = [];
  List<PegawaiModel> _filteredPegawaiList = [];
  bool _isLoading = true;
  String _selectedDepartment = 'Semua';
  
  final List<String> _departments = [
    'Semua',
    'IT',
    'HRD',
    'Finance',
    'Marketing',
    'Operations',
    'Medical',
    'Nursing',
    'Pharmacy',
    'Laboratory',
    'Radiology',
  ];

  @override
  void initState() {
    super.initState();
    _loadPegawaiData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPegawaiData() async {
    setState(() => _isLoading = true);
    try {
      final pegawaiList = await _dbHelper.getAllPegawai();
      setState(() {
        _pegawaiList = pegawaiList;
        _filteredPegawaiList = pegawaiList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Gagal memuat data pegawai: ${e.toString()}');
    }
  }

  void _filterPegawai() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPegawaiList = _pegawaiList.where((pegawai) {
        final matchesSearch = pegawai.nama.toLowerCase().contains(query) ||
            pegawai.nik.toLowerCase().contains(query) ||
            pegawai.jabatan.toLowerCase().contains(query);
        
        final matchesDepartment = _selectedDepartment == 'Semua' ||
            pegawai.departemen == _selectedDepartment;
        
        return matchesSearch && matchesDepartment;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Pegawai RSDM'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPegawaiData,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          _buildStatistics(),
          Expanded(
            child: _isLoading ? _buildLoadingWidget() : _buildPegawaiList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddPegawai(),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari berdasarkan nama, NIK, atau jabatan...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _filterPegawai();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              fillColor: Colors.white,
              filled: true,
            ),
            onChanged: (value) => _filterPegawai(),
          ),
          
          const SizedBox(height: 12),
          
          // Department Filter
          Row(
            children: [
              const Text(
                'Departemen: ',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedDepartment,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: _departments.map((department) {
                    return DropdownMenuItem(
                      value: department,
                      child: Text(department),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedDepartment = value!);
                    _filterPegawai();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Pegawai',
              _pegawaiList.length.toString(),
              Icons.people,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Hasil Filter',
              _filteredPegawaiList.length.toString(),
              Icons.filter_list,
              Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Departemen',
              _getUniqueDepartments().length.toString(),
              Icons.business,
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Set<String> _getUniqueDepartments() {
    return _pegawaiList.map((p) => p.departemen).toSet();
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Memuat data pegawai...'),
        ],
      ),
    );
  }

  Widget _buildPegawaiList() {
    if (_filteredPegawaiList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              _pegawaiList.isEmpty 
                  ? 'Belum ada data pegawai.\nTambah pegawai baru dengan menekan tombol +' 
                  : 'Tidak ada pegawai yang sesuai dengan pencarian.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPegawaiData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredPegawaiList.length,
        itemBuilder: (context, index) {
          final pegawai = _filteredPegawaiList[index];
          return _buildPegawaiCard(pegawai);
        },
      ),
    );
  }

  Widget _buildPegawaiCard(PegawaiModel pegawai) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToDetailPegawai(pegawai),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blue.shade100,
                    backgroundImage: pegawai.fotoFilePath != null 
                        ? FileImage(File(pegawai.fotoFilePath!)) as ImageProvider
                        : null,
                    child: pegawai.fotoFilePath == null
                        ? Text(
                            pegawai.nama.isNotEmpty ? pegawai.nama[0].toUpperCase() : '?',
                            style: TextStyle(
                              color: Colors.blue.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          )
                        : null,
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pegawai.nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'NIK: ${pegawai.nik}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(pegawai.statusKepegawaian).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getStatusColor(pegawai.statusKepegawaian).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      pegawai.statusKepegawaian,
                      style: TextStyle(
                        color: _getStatusColor(pegawai.statusKepegawaian),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Job info
              Row(
                children: [
                  Icon(
                    Icons.work_outline,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${pegawai.jabatan} • ${pegawai.departemen}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 6),
              
              // Contact info
              Row(
                children: [
                  Icon(
                    Icons.phone_outlined,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    pegawai.noTelepon,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.email_outlined,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      pegawai.email,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _navigateToEditPegawai(pegawai),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue.shade600,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _deletePegawai(pegawai),
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text('Hapus'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'tetap':
        return Colors.green;
      case 'kontrak':
        return Colors.orange;
      case 'magang':
        return Colors.blue;
      case 'freelance':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Future<void> _navigateToAddPegawai() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddPegawaiScreen(),
      ),
    );
    
    if (result == true) {
      _loadPegawaiData();
    }
  }

  Future<void> _navigateToEditPegawai(PegawaiModel pegawai) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddPegawaiScreen(pegawai: pegawai),
      ),
    );
    
    if (result == true) {
      _loadPegawaiData();
    }
  }

  void _navigateToDetailPegawai(PegawaiModel pegawai) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailPegawaiScreen(pegawai: pegawai),
      ),
    );
  }

  Future<void> _deletePegawai(PegawaiModel pegawai) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pegawai'),
        content: Text('Apakah Anda yakin ingin menghapus data ${pegawai.nama}?'),
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
      try {
        await _dbHelper.deletePegawai(pegawai.id!);
        _loadPegawaiData();
        _showSuccessSnackBar('Data ${pegawai.nama} berhasil dihapus');
      } catch (e) {
        _showErrorSnackBar('Gagal menghapus data: ${e.toString()}');
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
