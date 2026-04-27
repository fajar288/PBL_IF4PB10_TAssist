import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../app/app.dart';

class DashboardMainMahasiswaPage extends StatefulWidget {
  const DashboardMainMahasiswaPage({super.key});

  @override
  State<DashboardMainMahasiswaPage> createState() => _DashboardMainMahasiswaPageState();
}

class _DashboardMainMahasiswaPageState extends State<DashboardMainMahasiswaPage> {
  // Fungsi logout yang sama dengan dashboard sebelumnya
  void _logout() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      TAssistApp.loginRoute,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF2F6),
      extendBody: true, // Agar konten bisa terlihat di belakang navbar glass
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16), 
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SafeArea(
            bottom: false, 
            child: Padding(
              // Padding internal untuk konten
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildMeetingSchedule(),
                  const SizedBox(height: 18),
                  _buildGoalStatistics(),
                  const SizedBox(height: 18),
                  _buildTargetThisWeek(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Header 
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
                Text('Hi, Aruna Fajar!',
                    style: TextStyle(
                        color: Color(0xFF2D3238),
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        height: 1.1)),
                SizedBox(height: 4),
                Text('Welcome to TAssist',
                    style: TextStyle(
                        color: Color(0xFF5A6269),
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: _logout,
          child: Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
              image: const DecorationImage(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=300&q=80'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Schedule
  Widget _buildMeetingSchedule() {
    final meetings = [
      {'date': 'Monday, 1 Jan 2026 at 09.00', 'img': 'https://i.pravatar.cc/150?u=1'},
      {'date': 'Monday, 1 Jan 2026 at 09.00', 'img': 'https://i.pravatar.cc/150?u=2'},
      {'date': 'Monday, 8 Jan 2026 at 09.00', 'img': 'https://i.pravatar.cc/150?u=3'},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.alarm_on_rounded, color: Color(0xFF0D4AA3), size: 28),
              const SizedBox(width: 10),
              const Text("Next Meeting Schedule",
                  style: TextStyle(
                      color: Color(0xFF0D4AA3),
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 20),
          ...meetings.map((m) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF8BA5C9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                        radius: 18, backgroundImage: NetworkImage(m['img']!)),
                    const SizedBox(width: 14),
                    Text(m['date']!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // Chart
  Widget _buildGoalStatistics() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          const Text("Goal Percentage",
              style: TextStyle(
                  color: Color(0xFF111111),
                  fontSize: 20,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 30),
          // Arc Chart Custom
          SizedBox(
            height: 140,
            width: 240,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(240, 120),
                  painter: ArcPainter(percentage: 0.84),
                ),
                Positioned(
                  bottom: 10,
                  child: Text("84%",
                      style: TextStyle(
                          color: const Color(0xFF111111),
                          fontSize: 40,
                          fontWeight: FontWeight.w900)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Daftar Progress Bar
          _buildProgressBar("PLANNING", 1.0),
          const SizedBox(height: 12),
          _buildProgressBar("DESIGN", 0.75),
          const SizedBox(height: 12),
          _buildProgressBar("IMPLEMENTATION", 0.75),
          const SizedBox(height: 12),
          _buildProgressBar("TESTING", 0.50),
          const SizedBox(height: 12),
          _buildProgressBar("DEPLOY", 0.25),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String label, double progress) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 38,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2F6),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // Indikator Progress dengan Gradient
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: 38,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D4AA3), Color(0xFFB5C6E0)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            // Teks di atas progress bar
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800)),
                    Text("${(progress * 100).toInt()}%",
                        style: const TextStyle(
                            color: Color(0xFF0D4AA3),
                            fontSize: 13,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Target
  Widget _buildTargetThisWeek() {
    final targets = [
      "ERD Design",
      "UI/UX Design",
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.track_changes_rounded, color: Color(0xFF0D4AA3), size: 28),
              const SizedBox(width: 10),
              const Text("Target this Week",
                  style: TextStyle(
                      color: Color(0xFF0D4AA3),
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 20),
          ...targets.map((t) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFC8B683),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(t,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          color: Color(0xFFBC3433), shape: BoxShape.circle),
                      child: const Icon(Icons.priority_high_rounded,
                          color: Colors.white, size: 16),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// Painter chart
class ArcPainter extends CustomPainter {
  final double percentage;
  ArcPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2.2;
    const strokeWidth = 24.0;

    // Gambar Background Gray Arc
    final bgPaint = Paint()
      ..color = const Color(0xFF8BA5C9).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      bgPaint,
    );

    // Gambar Active Blue Arc
    final activePaint = Paint()
      ..color = const Color(0xFF0D4AA3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi * percentage,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}