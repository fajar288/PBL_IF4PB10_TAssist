// lib/features/dosen/view/student_list_page.dart

import 'package:flutter/material.dart';
import 'package:produk/data/dummy_data.dart';
import 'package:produk/model/models.dart';
import 'package:produk/widgets/student_card.dart';
import 'student_detail_screen.dart';
import 'package:produk/widgets/custom_bottom_nav.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<StudentModel> _filteredStudents = DummyData.dummyStudents;
  String _selectedFilter = 'All';
  late AnimationController _headerAnimController;
  late Animation<double> _headerFadeAnim;

  final List<String> _filters = ['All', 'Active', 'Warning', 'Completed'];

  @override
  void initState() {
    super.initState();
    _headerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _headerFadeAnim = CurvedAnimation(
      parent: _headerAnimController,
      curve: Curves.easeOut,
    );
    _headerAnimController.forward();

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _headerAnimController.dispose();
    super.dispose();
  }

  void _onSearchChanged() => _applyFilters();

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStudents = DummyData.dummyStudents.where((s) {
        final matchesSearch = s.name.toLowerCase().contains(query) ||
            s.nim.contains(query) ||
            s.major.toLowerCase().contains(query);
        final matchesFilter = _selectedFilter == 'All' ||
            s.status == _selectedFilter.toLowerCase();
        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  void _onFilterChanged(String filter) {
    setState(() => _selectedFilter = filter);
    _applyFilters();
  }

  int _countByStatus(String status) {
    if (status == 'All') return DummyData.dummyStudents.length;
    return DummyData.dummyStudents.where((s) => s.status == status.toLowerCase()).length;
  }


  // Warna navbar aktif — dipakai konsisten di header
  static const Color _navBlue      = Color(0xFF0D4AA3);
  static const Color _navBlueDark  = Color(0xFF082E6B); // lebih gelap untuk start gradient
  static const Color _navBlueLight = Color(0xFF1A65C8);
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFF6F7FB),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header gradient (title + stats)
        FadeTransition(
          opacity: _headerFadeAnim,
          child: _buildHeader(context),
        ),

        // Search bar (di luar gradient)
        _buildSearchBar(context),

        // Filter chips
        const SizedBox(height: 12),
        _buildFilterRow(context),

        const SizedBox(height: 8),

        // List
        Expanded(
          child: _filteredStudents.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  padding: EdgeInsets.only(
                    top: 4,
                    bottom: CustomBottomNav.navBarHeight + CustomBottomNav.bottomPadding + 16,
                  ),
                  itemCount: _filteredStudents.length,
                  itemBuilder: (context, index) {
                    final student = _filteredStudents[index];
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(
                          milliseconds: 300 + (index * 60).clamp(0, 400)),
                      curve: Curves.easeOut,
                      builder: (context, value, child) => Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: child,
                        ),
                      ),
                      child: StudentCard(
                        student: student,
                        onTap: () => _navigateToDetail(context, student),
                      ),
                    );
                  },
                ),
        ),
      ],
    ),
  );
}

Widget _buildHeader(BuildContext context) {
  final active = _countByStatus('Active');
  final warning = _countByStatus('Warning');
  final completed = _countByStatus('Completed');

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
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Students Overview',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Manage your advisee students',
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.65),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.person_add_alt_1_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Stats row (seperti dashboard)
            Row(
              children: [
                _headerStatChip('$active Active', const Color(0xFF22C55E)),
                const SizedBox(width: 10),
                _headerStatChip('$warning Warning', const Color(0xFFF59E0B)),
                const SizedBox(width: 10),
                _headerStatChip('$completed Done', const Color(0xFF6366F1)),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _headerStatChip(String label, Color color) {
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
          label,
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

Widget _buildSearchBar(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search by name, NIM, or major...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          prefixIcon: Icon(Icons.search_rounded,
              color: Colors.grey.shade400, size: 20),
          suffixIcon: _searchController.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    _applyFilters();
                  },
                  child: Icon(Icons.close_rounded,
                      color: Colors.grey.shade400, size: 18),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    ),
  );
}

  Widget _buildFilterRow(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          final count = _countByStatus(filter);

          return GestureDetector(
            onTap: () => _onFilterChanged(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.3)
                        : Colors.black.withOpacity(0.04),
                    blurRadius: isSelected ? 8 : 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filter,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.25)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statChip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search_off_rounded,
                size: 36, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 16),
          Text(
            'No students found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try adjusting your search or filter',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () {
              _searchController.clear();
              _onFilterChanged('All');
            },
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Reset filters'),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(BuildContext context, StudentModel student) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            StudentDetailPage(student: student),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }
}