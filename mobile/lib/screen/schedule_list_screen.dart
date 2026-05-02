// lib/screens/schedule_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:produk/data/dummy_data.dart';
import '../model/models.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/custom_meeting_card.dart';
import 'meeting_detail_screen.dart';

class ScheduleListScreen extends StatelessWidget {
  const ScheduleListScreen({super.key});


  // Warna navbar aktif — dipakai konsisten di header
  static const Color _navBlue      = Color(0xFF0D4AA3);
  static const Color _navBlueDark  = Color(0xFF082E6B); // lebih gelap untuk start gradient
  static const Color _navBlueLight = Color(0xFF1A65C8);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header ─────────────────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildHeader(context)),

          // ── Upcoming Highlight ─────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildUpcomingBanner(context)),

          // ── Section title ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                'All Meeting Requests',
                style: GoogleFonts.poppins(
                  color: AppTheme.textPrimary,  
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
            ),
          ),

          // ── List ───────────────────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              20, 8, 20, CustomBottomNav.navBarHeight + CustomBottomNav.bottomPadding + 16,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) {
                  final req = DummyData.meetingRequests[i];
                  return MeetingRequestCard(
                    request: req,
                    animationIndex: i,
                    onTap: () => Navigator.push(
                      ctx,
                      MaterialPageRoute(
                        builder: (_) => MeetingDetailScreen(request: req),
                      ),
                    ),
                  );
                },
                childCount: DummyData.meetingRequests.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_navBlueDark, _navBlue, _navBlueLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 26),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Schedule',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage student meeting requests',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.05, end: 0),
        ),
      ),
    );
  }

  Widget _buildUpcomingBanner(BuildContext context) {
    final next = DummyData.meetingRequests
        .where((r) => r.status == RequestStatus.pending)
        .firstOrNull;

    if (next == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF082E6B), // _navBlueDark
              Color(0xFF1A65C8), // _navBlueLight
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D4AA3).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.notifications_active_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Next Pending Meeting',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    next.studentName,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${next.dayName}  •  ${next.meetingTime}',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white70,
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms, delay: 150.ms).slideY(begin: 0.1, end: 0),
    );
  }
}