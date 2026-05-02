import 'package:flutter/material.dart';
import '../../../app/app.dart';
import 'lecturers_page.dart';
import 'mentoring_request_store.dart';
import 'lecturer_detail_page.dart';
import 'package:google_fonts/google_fonts.dart';

class LecturerSelectionDashboardPage extends StatefulWidget {
  const LecturerSelectionDashboardPage({super.key});

  @override
  State<LecturerSelectionDashboardPage> createState() =>
      _LecturerSelectionDashboardPageState();
}

class _LecturerSelectionDashboardPageState
    extends State<LecturerSelectionDashboardPage> {

  final List<LecturerCategory> categories = const [
    LecturerCategory(title: 'Informatics Lecturers', imageUrl: 'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?auto=format&fit=crop&w=1200&q=80'),
    LecturerCategory(title: 'Business Lecturers', imageUrl: 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?auto=format&fit=crop&w=1200&q=80'),
    LecturerCategory(title: 'Electrical Lecturers', imageUrl: 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80'),
    LecturerCategory(title: 'Mechanical Lecturers', imageUrl: 'https://images.unsplash.com/photo-1581092580497-e0d23cbdf1dc?auto=format&fit=crop&w=1200&q=80'),
    LecturerCategory(title: 'Arts and Cultural Lecturers', imageUrl: 'https://images.unsplash.com/photo-1518998053901-5348d3961a04?auto=format&fit=crop&w=1200&q=80'),
  ];

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      TAssistApp.loginRoute,
      (route) => false,
    );
  }

  void _openLecturersPage({LecturerDepartment? department}) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => LecturersPage(initialDepartment: department),
    ));
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
      case 'Business Management':     return LecturerDepartment.business;
      case 'Electrical Engineering':  return LecturerDepartment.electrical;
      case 'Machine Engineering':     return LecturerDepartment.mechanical;
      case 'Arts and Cultural':       return LecturerDepartment.artsAndCulture;
      default:                        return LecturerDepartment.informatics;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF2F6),
      extendBody: true,
      // Tidak ada Padding/SafeArea di sini — dihandle masing-masing widget
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Header full-width tanpa padding luar
            _buildHeader(),

            // Konten di bawah header pakai padding sendiri
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
              child: Column(
                children: [
                  _buildTopCard(),
                  const SizedBox(height: 18),
                  _buildBottomRequestList(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF082E6B), Color(0xFF0D4AA3), Color(0xFF1A65C8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Teks kiri
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('👋  ', style: TextStyle(fontSize: 18)),
                        Text(
                          'Good Morning,',
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Aruna Fajar!',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Welcome to TAssist',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Avatar kanan
              GestureDetector(
                onTap: _logout,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=300&q=80',
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 56,
                        height: 56,
                        color: Colors.white24,
                        child: const Center(
                          child: Text(
                            'AF',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Top Card ────────────────────────────────────────────────────────────────
  Widget _buildTopCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 20, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Let's choose your lecturer first!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF111111), fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
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
    return [
      LecturerDepartment.informatics,
      LecturerDepartment.business,
      LecturerDepartment.electrical,
      LecturerDepartment.mechanical,
      LecturerDepartment.artsAndCulture,
    ][i];
  }

  Widget _buildViewAllButton() {
    return InkWell(
      onTap: () => _openLecturersPage(),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('view all lecturers', style: TextStyle(color: Color(0xFF111111), fontSize: 14, fontWeight: FontWeight.w600)),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF111111)),
          ],
        ),
      ),
    );
  }

  // ─── Bottom Request List ─────────────────────────────────────────────────────
  Widget _buildBottomRequestList() {
    return ValueListenableBuilder<List<RequestedLecturer>>(
      valueListenable: MentoringRequestStore.requests,
      builder: (context, requestList, _) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: requestList.isEmpty
              ? const SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(
                      "there's nothing here...",
                      style: TextStyle(color: Color(0xFF7D848C), fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              : Column(
                  children: requestList.map((request) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildRequestItem(request),
                  )).toList(),
                ),
        );
      },
    );
  }

  Widget _buildRequestItem(RequestedLecturer request) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openRequestedLecturerDetail(request),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF0D4AA3),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0D4AA3).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(radius: 20, backgroundImage: NetworkImage(request.imageUrl)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Requested Counseling', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w500)),
                    Text('with Mr. ${request.name}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Lecturer Banner Card ────────────────────────────────────────────────────
class _LecturerBannerCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  const _LecturerBannerCard({
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.black.withOpacity(0.3),
          ),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 0.5),
          ),
        ),
      ),
    );
  }
}

// ─── Models ──────────────────────────────────────────────────────────────────
class LecturerCategory {
  final String title;
  final String imageUrl;
  const LecturerCategory({required this.title, required this.imageUrl});
}