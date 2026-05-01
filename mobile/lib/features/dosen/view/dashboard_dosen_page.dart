// lib/features/dosen/view/dashboard_dosen_page.dart
import 'package:flutter/material.dart';
import 'package:produk/screen/home_screen.dart';
import 'package:produk/widgets/custom_bottom_nav.dart';
import 'package:produk/screen/meeting_detail_screen.dart';
import 'package:produk/screen/schedule_list_screen.dart';
import 'package:produk/screen/student_list_screen.dart';

class DashboardDosenPage extends StatefulWidget {
  const DashboardDosenPage({super.key});

  @override
  State<DashboardDosenPage> createState() => _DashboardDosenPageState();
}

class _DashboardDosenPageState extends State<DashboardDosenPage> {
  int _currentIndex = 0;

  // Keep pages alive when switching tabs
  static const _pages = [
    HomeScreen(),
    ScheduleListScreen(),
    StudentListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use extendBody so the floating nav overlaps the body
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}