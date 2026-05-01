// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:produk/data/dummy_data.dart';
import '../model/models.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/custom_request_card.dart';
import 'counseling_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedFilter = 'All';
  final _filters = ['All', 'Pending', 'Accepted', 'Declined'];

  List<CounselingRequest> get _filteredRequests {
    if (_selectedFilter == 'All') return DummyData.counselingRequests;
    final status = RequestStatus.values.firstWhere(
      (s) => s.label == _selectedFilter,
    );
    return DummyData.counselingRequests
        .where((r) => r.status == status)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header ─────────────────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildHeader(context)),

          // ── Filter Tabs ─────────────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildFilterRow()),

          // ── Request List ────────────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              20, 8, 20, CustomBottomNav.totalHeight + 16,
            ),
            sliver: _filteredRequests.isEmpty
                ? const SliverToBoxAdapter(child: _EmptyState())
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) {
                        final request = _filteredRequests[i];
                        return CounselingRequestCard(
                          request: request,
                          animationIndex: i,
                          onTap: () => _openDetail(ctx, request),
                        );
                      },
                      childCount: _filteredRequests.length,
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
          colors: [Color(0xFF312E81), Color(0xFF4338CA), Color(0xFF6366F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: greeting + avatar
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                        )
                            .animate()
                            .fadeIn(duration: 500.ms)
                            .slideX(begin: -0.1, end: 0),
                        const SizedBox(height: 2),
                        Text(
                          'Rio Putraa!',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 500.ms, delay: 100.ms)
                            .slideX(begin: -0.1, end: 0),
                        const SizedBox(height: 4),
                        Text(
                          'Senior Academic Counselor',
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // User Avatar
                  Container(
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
                        'https://i.pravatar.cc/300?img=47',
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF818CF8), Color(0xFFA5B4FC)],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'AF',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 200.ms)
                      .scale(begin: const Offset(0.8, 0.8)),
                ],
              ),

              const SizedBox(height: 22),

              // Stats Row
              Row(
                children: [
                  _StatChip(
                    label: 'Pending',
                    count: DummyData.counselingRequests
                        .where((r) => r.status == RequestStatus.pending)
                        .length,
                    color: AppTheme.pending,
                  ),
                  const SizedBox(width: 10),
                  _StatChip(
                    label: 'Accepted',
                    count: DummyData.counselingRequests
                        .where((r) => r.status == RequestStatus.accepted)
                        .length,
                    color: AppTheme.accepted,
                  ),
                  const SizedBox(width: 10),
                  _StatChip(
                    label: 'Declined',
                    count: DummyData.counselingRequests
                        .where((r) => r.status == RequestStatus.declined)
                        .length,
                    color: AppTheme.declined,
                  ),
                ],
              ).animate().fadeIn(duration: 500.ms, delay: 300.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Counseling Requests',
              style: GoogleFonts.poppins(
                color: AppTheme.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ...(_filters.skip(1).map(
                (f) => _FilterChip(
                  label: f,
                  selected: _selectedFilter == f,
                  onTap: () => setState(() {
                    _selectedFilter = _selectedFilter == f ? 'All' : f;
                  }),
                ),
              )),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, CounselingRequest request) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CounselingDetailScreen(request: request),
      ),
    );
  }
}

// ─── Small Stat Chip ──────────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatChip({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            '$count $label',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Filter Chip ──────────────────────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(left: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppTheme.primary : const Color(0xFFCBD5E1),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: selected ? Colors.white : AppTheme.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primaryGhost,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.inbox_rounded,
              size: 48,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No requests found',
            style: GoogleFonts.poppins(
              color: AppTheme.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'There are no requests matching\nthis filter right now.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppTheme.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}