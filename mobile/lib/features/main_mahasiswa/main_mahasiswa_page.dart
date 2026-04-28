import 'package:flutter/material.dart';
import 'navbar_mahasiswa.dart';
import '../lecturer_selection/view/lecturer_selection_dashboard_page.dart';
import '../lecturer_selection/view/mentoring_request_store.dart';
import 'dashboard_main_mahasiswa_page.dart';
import 'schedule_page.dart';
import 'upload_document_page.dart';

class MainMahasiswaPage extends StatefulWidget {
  const MainMahasiswaPage({super.key});

  @override
  State<MainMahasiswaPage> createState() => _MainMahasiswaPageState();
}

class _MainMahasiswaPageState extends State<MainMahasiswaPage> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Widget helper untuk menampilkan pesan fitur belum tersedia
  Widget _buildLockedFeaturePage() {
    return const Scaffold(
      backgroundColor: Color(0xFFEEF2F6),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            "kamu belum ada dosen pembimbing,\nfitur ini belum tersedia",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Kita pantau status approval dosen di sini
    return ValueListenableBuilder<bool>(
      valueListenable: MentoringRequestStore.isApproved,
      builder: (context, isApproved, _) {
        
        // Daftar halaman dinamis berdasarkan status bimbingan
        final List<Widget> pages = isApproved 
          ? [
              const DashboardMainMahasiswaPage(), // Index 0: Dashboard Progres
              const SchedulePage(),              // Index 1: Laman Schedule baru
              const UploadDocumentPage(),          // Index 2: Upload Dokumen
            ]
          : [
              const LecturerSelectionDashboardPage(), // Index 0: Pilih Dosen
              _buildLockedFeaturePage(),             // Index 1: Terkunci
              _buildLockedFeaturePage(),             // Index 2: Terkunci
            ];

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: pages,
          ),
          bottomNavigationBar: NavbarMahasiswa(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
          ),
          extendBody: true,
        );
      },
    );
  }
}