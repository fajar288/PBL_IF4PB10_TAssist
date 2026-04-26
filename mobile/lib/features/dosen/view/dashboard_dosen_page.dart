import 'package:flutter/material.dart';
import '../../lecturer_selection/view/mentoring_request_store.dart';
import '../../../app/app.dart';

class DashboardDosenPage extends StatefulWidget {
  const DashboardDosenPage({super.key});

  @override
  State<DashboardDosenPage> createState() => _DashboardDosenPageState();
}

class _DashboardDosenPageState extends State<DashboardDosenPage> {
  int selectedIndex = 0;

  final List<_CounselingRequest> dummyRequests = const [
    _CounselingRequest(
      name: 'Aruna Fajar Prayoga',
      status: 'Pending',
      avatarText: 'A',
    ),
    _CounselingRequest(
      name: 'Eleanor Pena',
      status: 'Pending',
      avatarText: 'E',
    ),
    _CounselingRequest(
      name: 'Ralph Edwards',
      status: 'Pending',
      avatarText: 'R',
    ),
  ];

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(context, TAssistApp.loginRoute, (route) => false);
  }

  void _onNavTap(int index) {
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Mengubah Background menjadi terang sesuai dashboard mahasiswa
      backgroundColor: const Color(0xFFEEF2F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildCounselingCard(),
              const Spacer(),
              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hi, Dr. Lecturer!',
                    style: TextStyle(color: Color(0xFF2D3238), fontSize: 24, fontWeight: FontWeight.w800, height: 1.1)),
                SizedBox(height: 4),
                Text('Welcome to TAssist Dosen',
                    style: TextStyle(color: Color(0xFF5A6269), fontSize: 14, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: _logout,
          child: Container(
            width: 66, height: 66,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: const Color(0xFF0D4AA3), width: 2),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: const Icon(Icons.person, size: 34, color: Color(0xFF0D4AA3)),
          ),
        ),
      ],
    );
  }

  Widget _buildCounselingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Icon(Icons.mail_rounded, color: Color(0xFF0D4AA3), size: 24),
              SizedBox(width: 12),
              Text('Counseling Request',
                  style: TextStyle(color: Color(0xFF111111), fontSize: 18, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 20),
          // Memantau apakah sudah disetujui
          ValueListenableBuilder<bool>(
            valueListenable: MentoringRequestStore.isApproved,
            builder: (context, approved, _) {
              if (approved) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text("All requests handled ✅", style: TextStyle(color: Colors.grey)),
                );
              }
              return Column(
                children: dummyRequests.map((req) => _RequestCard(
                  request: req,
                  onAccept: () {
                    // Logika penyambungan: Klik accept di dosen, dashboard mahasiswa berubah!
                    MentoringRequestStore.approve();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mahasiswa Berhasil Disetujui!')),
                    );
                  },
                )).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 72,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_rounded, 'home'),
          _buildNavItem(1, Icons.more_time_rounded, 'schedule'),
          _buildNavItem(2, Icons.groups_rounded, 'students'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => _onNavTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0D4AA3) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : const Color(0xFF5A6269)),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ]
          ],
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final _CounselingRequest request;
  final VoidCallback onAccept;

  const _RequestCard({required this.request, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D4AA3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(request.avatarText, style: const TextStyle(color: Color(0xFF0D4AA3), fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(request.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                Text(request.status, style: const TextStyle(color: Color(0xFFFFC107), fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // Tombol Accept untuk simulasi approval
          ElevatedButton(
            onPressed: onAccept,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0D4AA3),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Accept', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _CounselingRequest {
  final String name;
  final String status;
  final String avatarText;
  const _CounselingRequest({required this.name, required this.status, required this.avatarText});
}