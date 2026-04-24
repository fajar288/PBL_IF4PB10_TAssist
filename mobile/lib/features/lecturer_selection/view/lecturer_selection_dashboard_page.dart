import 'package:flutter/material.dart';
// Path ke app.dart (naik 3 tingkat dari view > lecturer_selection > features)
import '../../../app/app.dart';

// Import lokal di folder yang sama
import 'lecturers_page.dart';
import 'mentoring_request_store.dart';
import 'lecturer_detail_page.dart';

class LecturerSelectionDashboardPage extends StatefulWidget {
  const LecturerSelectionDashboardPage({super.key});

  @override
  State<LecturerSelectionDashboardPage> createState() =>
      _LecturerSelectionDashboardPageState();
}

class _LecturerSelectionDashboardPageState
    extends State<LecturerSelectionDashboardPage> {
  
  // NAVBAR INTERNAL SUDAH DIHAPUS
  // Logika UI tetap sama seperti sebelumnya, hanya fokus pada konten dashboard.

  final List<LecturerCategory> categories = const [
    LecturerCategory(
      title: 'Informatics Lecturers',
      imageUrl: 'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?auto=format&fit=crop&w=1200&q=80',
    ),
    LecturerCategory(
      title: 'Business Lecturers',
      imageUrl: 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?auto=format&fit=crop&w=1200&q=80',
    ),
    LecturerCategory(
      title: 'Electrical Lecturers',
      imageUrl: 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80',
    ),
    LecturerCategory(
      title: 'Mechanical Lecturers',
      imageUrl: 'https://images.unsplash.com/photo-1581092580497-e0d23cbdf1dc?auto=format&fit=crop&w=1200&q=80',
    ),
    LecturerCategory(
      title: 'Arts and Cultural Lecturers',
      imageUrl: 'https://images.unsplash.com/photo-1518998053901-5348d3961a04?auto=format&fit=crop&w=1200&q=80',
    ),
  ];

  void _openLecturersPage({LecturerDepartment? department}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LecturersPage(
          initialDepartment: department,
        ),
      ),
    );
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      TAssistApp.loginRoute,
      (route) => false,
    );
  }

  void _openRequestedLecturerDetail(RequestedLecturer request) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LecturerDetailPage(
          lecturer: LecturerModel(
            id: request.id,
            name: request.name,
            department: _mapMajorToDepartment(request.major),
            imageUrl: request.imageUrl,
            quotaLeft: request.guidanceQuotaLeft,
            nid: request.nid,
          ),
        ),
      ),
    );
  }

  LecturerDepartment _mapMajorToDepartment(String major) {
    switch (major) {
      case 'Informatics Engineering': return LecturerDepartment.informatics;
      case 'Business Management': return LecturerDepartment.business;
      case 'Electrical Engineering': return LecturerDepartment.electrical;
      case 'Machine Engineering': return LecturerDepartment.mechanical;
      case 'Arts and Cultural': return LecturerDepartment.artsAndCulture;
      default: return LecturerDepartment.informatics;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF363C45),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 0),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildTopCard(),
              const SizedBox(height: 18),
              Expanded(child: _buildBottomEmptyCard()),
              const SizedBox(height: 20), // Space agar tidak tertutup navbar melayang
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
                Text('Hi, Aruna Fajar!', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, height: 1.1)),
                SizedBox(height: 4),
                Text('Welcome to TAssist', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400)),
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
              border: Border.all(color: Colors.white.withOpacity(0.9), width: 2),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=300&q=80'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 12),
      decoration: BoxDecoration(color: const Color(0xFFD9DDE2), borderRadius: BorderRadius.circular(18)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Let’s choose your lecturer first!", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF111111), fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          for (int i = 0; i < categories.length; i++) ...[
            _LecturerBannerCard(
              title: categories[i].title,
              imageUrl: categories[i].imageUrl,
              onTap: () => _openLecturersPage(department: _getDeptByIndex(i)),
            ),
            const SizedBox(height: 14),
          ],
          _buildViewAllButton(),
        ],
      ),
    );
  }

  LecturerDepartment _getDeptByIndex(int i) {
    return [LecturerDepartment.informatics, LecturerDepartment.business, LecturerDepartment.electrical, LecturerDepartment.mechanical, LecturerDepartment.artsAndCulture][i];
  }

  Widget _buildViewAllButton() {
    return InkWell(
      onTap: () => _openLecturersPage(),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('view all lecturers', style: TextStyle(color: Color(0xFF111111), fontSize: 14, fontWeight: FontWeight.w500)),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_ios_rounded, size: 17, color: Color(0xFF111111)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomEmptyCard() {
    return ValueListenableBuilder<RequestedLecturer?>(
      valueListenable: MentoringRequestStore.currentRequest,
      builder: (context, request, _) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: const Color(0xFFD9DDE2), borderRadius: BorderRadius.circular(18)),
          child: request == null
              ? const Center(child: Text("there’s nothing here...", style: TextStyle(color: Color(0xFF2B2B2B), fontSize: 16, fontWeight: FontWeight.w500)))
              : _buildRequestItem(request),
        );
      },
    );
  }

  Widget _buildRequestItem(RequestedLecturer request) {
    return Align(
      alignment: Alignment.topCenter,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openRequestedLecturerDetail(request),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: const Color(0xFF0D4AA3), borderRadius: BorderRadius.circular(14)),
            child: Row(
              children: [
                CircleAvatar(radius: 20, backgroundImage: NetworkImage(request.imageUrl)),
                const SizedBox(width: 10),
                Expanded(child: Text('Requested Counseling\nwith Mr. ${request.name}', style: const TextStyle(color: Colors.white, fontSize: 12))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LecturerBannerCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;
  const _LecturerBannerCard({required this.title, required this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
        ),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.black26),
          child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
        ),
      ),
    );
  }
}

class LecturerCategory {
  final String title;
  final String imageUrl;
  const LecturerCategory({required this.title, required this.imageUrl});
}