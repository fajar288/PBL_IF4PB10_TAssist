import 'package:flutter/material.dart';
import 'package:produk/features/main_mahasiswa/dashboard_main_mahasiswa_page.dart';
import '../features/auth/view/login_page.dart';
import '../features/loglearning/view/learning_placeholder_page.dart';
import '../features/dosen/view/dashboard_dosen_page.dart';
import '../features/main_mahasiswa/main_mahasiswa_page.dart';
import '../features/lecturer_selection/view/lecturer_selection_dashboard_page.dart';
import '../features/lecturer_selection/view/mentoring_request_store.dart';

class TAssistApp extends StatelessWidget {
  const TAssistApp({super.key});

  static const String loginRoute = '/';
  static const String dashboardRoute = '/dashboard-mahasiswa';
  static const String dashboardDosenRoute = '/dashboard-dosen';
  static const String learningRoute = '/learning';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TAssist',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      initialRoute: loginRoute,
      routes: {
        loginRoute: (_) => const LoginPage(),
        dashboardRoute: (_) => const DashboardMahasiswaWrapper(),
        dashboardDosenRoute: (_) => const DashboardDosenPage(),
        learningRoute: (_) => const LearningPlaceholderPage(),
      },
    );
  }
}

// Wrapper untuk menentukan tampilan dashboard mahasiswa
class DashboardMahasiswaWrapper extends StatelessWidget {
  const DashboardMahasiswaWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: MentoringRequestStore.isApproved,
      builder: (context, approved, _) {
        // Jika sudah di-approve dosen, tampilkan dashboard progres baru
        if (approved) {
          return const DashboardMainMahasiswaPage();
        }
        // Jika belum, tampilkan dashboard pencarian dosen lama
        return const LecturerSelectionDashboardPage();
      },
    );
  }
}