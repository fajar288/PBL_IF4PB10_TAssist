// lib/screens/meeting_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_dialogs.dart';
import '../widgets/custom_request_card.dart';

class MeetingDetailScreen extends StatefulWidget {
  final MeetingRequest request;

  const MeetingDetailScreen({super.key, required this.request});

  @override
  State<MeetingDetailScreen> createState() => _MeetingDetailScreenState();
}

class _MeetingDetailScreenState extends State<MeetingDetailScreen> {
  RequestStatus? _localStatus;

  RequestStatus get currentStatus => _localStatus ?? widget.request.status;
  bool get isActionable => currentStatus == RequestStatus.pending;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Top Bar ────────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: const Color(0xFF312E81),
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
            title: Text(
              'Meeting Request',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF312E81), Color(0xFF4338CA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // ── Content ────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Student Profile Card
                  _buildProfileCard(),
                  const SizedBox(height: 16),

                  // Schedule Section
                  _buildScheduleCard(),
                  const SizedBox(height: 16),

                  // Description
                  _buildDescriptionCard(),
                  const SizedBox(height: 28),

                  // Actions
                  if (isActionable)
                    _buildActionButtons(context)
                  else
                    _buildStatusBanner(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      decoration: AppTheme.cardDecoration(),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Avatar with glow
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: AppTheme.avatarGlow,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Hero(
              tag: 'meeting-avatar-${widget.request.id}',
              child: ClipOval(
                child: Image.network(
                  widget.request.avatarUrl,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.primary, AppTheme.primaryLight],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.request.initials,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.request.studentName,
                  style: GoogleFonts.poppins(
                    color: AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 3),
                _pillTag(widget.request.major),
                const SizedBox(height: 5),
                Text(
                  'NIM: ${widget.request.nim}',
                  style: GoogleFonts.poppins(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          StatusBadge(status: currentStatus),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildScheduleCard() {
    return Container(
      decoration: AppTheme.cardDecoration(),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          // Colored header strip
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF312E81), Color(0xFF4338CA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.event_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Proposed Schedule',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Date and time detail
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Date block
                Expanded(
                  child: _ScheduleBlock(
                    icon: Icons.calendar_today_rounded,
                    topLabel: 'Date',
                    mainValue: widget.request.meetingDate.day.toString(),
                    subValue:
                        '${_monthName(widget.request.meetingDate.month)} ${widget.request.meetingDate.year}',
                    bottomLabel: widget.request.dayName,
                  ),
                ),
                Container(
                  width: 1,
                  height: 70,
                  color: const Color(0xFFE2E8F0),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
                // Time block
                Expanded(
                  child: _ScheduleBlock(
                    icon: Icons.access_time_rounded,
                    topLabel: 'Time',
                    mainValue: widget.request.meetingTime.split(' ')[0],
                    subValue: widget.request.meetingTime.contains('AM')
                        ? 'AM'
                        : 'PM',
                    bottomLabel: 'WIB (Local Time)',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildDescriptionCard() {
    return Container(
      decoration: AppTheme.cardDecoration(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGhost,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.description_rounded,
                  size: 16,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Reason / Description',
                style: GoogleFonts.poppins(
                  color: AppTheme.textPrimary,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.request.description,
              style: GoogleFonts.poppins(
                color: AppTheme.textSecondary,
                fontSize: 13,
                height: 1.75,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _handleAccept(context),
            icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
            label: const Text('Accept Meeting'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accepted,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
              textStyle: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _handleDecline(context),
            icon: const Icon(Icons.close_rounded, size: 20),
            label: const Text('Decline Meeting'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.declined,
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: AppTheme.declined, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ).animate().fadeIn(delay: 460.ms).slideY(begin: 0.1, end: 0),
      ],
    );
  }

  Widget _buildStatusBanner() {
    final isAccepted = currentStatus == RequestStatus.accepted;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        color: isAccepted ? AppTheme.acceptedBg : AppTheme.declinedBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAccepted ? AppTheme.acceptedBorder : AppTheme.declinedBorder,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isAccepted ? Icons.event_available_rounded : Icons.event_busy_rounded,
            color: isAccepted ? AppTheme.accepted : AppTheme.declined,
            size: 22,
          ),
          const SizedBox(width: 10),
          Text(
            isAccepted
                ? 'Meeting has been accepted.'
                : 'Meeting has been declined.',
            style: GoogleFonts.poppins(
              color: isAccepted ? AppTheme.accepted : AppTheme.declined,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pillTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.primaryGhost,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: AppTheme.primary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  Future<void> _handleAccept(BuildContext context) async {
    setState(() => _localStatus = RequestStatus.accepted);
    await showAcceptedDialog(context);
  }

  Future<void> _handleDecline(BuildContext context) async {
    final confirmed = await showDeclineConfirmDialog(context);
    if (!confirmed || !mounted) return;
    await showApologyDialog(context);
    if (mounted) setState(() => _localStatus = RequestStatus.declined);
  }
}

// ─── Schedule Block ───────────────────────────────────────────────────────────
class _ScheduleBlock extends StatelessWidget {
  final IconData icon;
  final String topLabel;
  final String mainValue;
  final String subValue;
  final String bottomLabel;

  const _ScheduleBlock({
    required this.icon,
    required this.topLabel,
    required this.mainValue,
    required this.subValue,
    required this.bottomLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppTheme.primary),
            const SizedBox(width: 5),
            Text(
              topLabel,
              style: GoogleFonts.poppins(
                color: AppTheme.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              mainValue,
              style: GoogleFonts.poppins(
                color: AppTheme.textPrimary,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              subValue,
              style: GoogleFonts.poppins(
                color: AppTheme.primary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          bottomLabel,
          style: GoogleFonts.poppins(
            color: AppTheme.textSecondary,
            fontSize: 11.5,
          ),
        ),
      ],
    );
  }
}