// lib/screens/counseling_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_dialogs.dart';
import '../widgets/custom_request_card.dart';

class CounselingDetailScreen extends StatefulWidget {
  final CounselingRequest request;

  const CounselingDetailScreen({super.key, required this.request});

  @override
  State<CounselingDetailScreen> createState() => _CounselingDetailScreenState();
}

class _CounselingDetailScreenState extends State<CounselingDetailScreen> {
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
          // ── Hero Image Section ─────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.primary,
            leading: _BackButton(),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeroSection(),
            ),
          ),

          // ── Content ────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }

  Widget _BackButton() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.25),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF312E81), Color(0xFF4338CA), Color(0xFF6366F1)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // Decorative circles
        Positioned(
          top: -60,
          right: -60,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.06),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: -40,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.04),
            ),
          ),
        ),

        // Network image (if it loads)
        Image.network(
          widget.request.avatarUrl,
          fit: BoxFit.cover,
          color: Colors.indigo.withOpacity(0.6),
          colorBlendMode: BlendMode.multiply,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),

        // Bottom gradient for readability
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  const Color(0xFF1E1B4B).withOpacity(0.85),
                ],
              ),
            ),
          ),
        ),

        // Avatar + name overlay
        Positioned(
          bottom: 24,
          left: 24,
          right: 24,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Large avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Hero(
                  tag: 'counseling-avatar-${widget.request.id}',
                  child: ClipOval(
                    child: Image.network(
                      widget.request.avatarUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.primaryLight, Color(0xFFA5B4FC)],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            widget.request.initials,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.request.studentName,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.request.major,
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status + Info Card
          Container(
            decoration: AppTheme.cardDecoration(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel('Student Information'),
                const SizedBox(height: 14),
                _InfoRow(
                  icon: Icons.badge_rounded,
                  label: 'Student ID (NIM)',
                  value: widget.request.nim,
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.school_rounded,
                  label: 'Department / Major',
                  value: widget.request.major,
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.info_outline_rounded,
                  label: 'Request Status',
                  value: '',
                  trailing: StatusBadge(status: currentStatus),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 100.ms)
              .slideY(begin: 0.1, end: 0),

          const SizedBox(height: 16),

          // Message Card
          if (widget.request.message.isNotEmpty)
            Container(
              decoration: AppTheme.cardDecoration(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel('Student\'s Message'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGhost,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primary.withOpacity(0.15),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.format_quote_rounded,
                          color: AppTheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.request.message,
                            style: GoogleFonts.poppins(
                              color: AppTheme.textSecondary,
                              fontSize: 13,
                              height: 1.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 200.ms)
                .slideY(begin: 0.1, end: 0),

          const SizedBox(height: 28),

          // Action Buttons
          if (isActionable) ...[
            _buildActionButtons(context),
          ] else ...[
            _buildStatusFeedback(),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Accept
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _handleAccept(context),
            icon: const Icon(Icons.check_circle_rounded, size: 20),
            label: const Text('Accept Request'),
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
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),

        const SizedBox(height: 12),

        // Decline
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _handleDecline(context),
            icon: const Icon(Icons.close_rounded, size: 20),
            label: const Text('Decline Request'),
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
        ).animate().fadeIn(delay: 380.ms).slideY(begin: 0.1, end: 0),
      ],
    );
  }

  Widget _buildStatusFeedback() {
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
            isAccepted ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: isAccepted ? AppTheme.accepted : AppTheme.declined,
            size: 22,
          ),
          const SizedBox(width: 10),
          Text(
            isAccepted
                ? 'This request has been accepted.'
                : 'This request has been declined.',
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

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: AppTheme.textMuted,
        fontSize: 11.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    );
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

// ─── Info Row Helper ──────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryGhost,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: AppTheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: AppTheme.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (value.isNotEmpty)
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}