// lib/app.dart  (or wherever TAssistApp lives)
import 'package:flutter/material.dart';
import 'package:produk/features/main_mahasiswa/dashboard_main_mahasiswa_page.dart';
import '../features/auth/view/login_page.dart';
import '../features/loglearning/view/learning_placeholder_page.dart';
import '../features/dosen/view/dashboard_dosen_page.dart';
import '../features/main_mahasiswa/main_mahasiswa_page.dart';
// ── NEW: import the TAssist theme so Material uses Poppins + our colors ──────
import '../theme/app_theme.dart';

class TAssistApp extends StatelessWidget {
  const TAssistApp({super.key});

  // ── Named Routes ────────────────────────────────────────────────────────────
  static const String loginRoute          = '/';
  static const String dashboardRoute      = '/dashboard-mahasiswa';
  static const String dashboardDosenRoute = '/dashboard-dosen';   // ← counselor home
  static const String learningRoute       = '/learning';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TAssist',

      // ── Use the full premium theme instead of bare ThemeData ───────────────
      theme: AppTheme.lightTheme,

      initialRoute: loginRoute,
      routes: {
        loginRoute:          (_) => const LoginPage(),
        dashboardRoute:      (_) => const DashboardMahasiswaWrapper(),
        dashboardDosenRoute: (_) => const DashboardDosenPage(),   
        learningRoute:       (_) => const LearningPlaceholderPage(),
      },
    );
  }
}

// ── Keeps the student-side wrapper exactly as before ──────────────────────────
class DashboardMahasiswaWrapper extends StatelessWidget {
  const DashboardMahasiswaWrapper({super.key});

  @override
  Widget build(BuildContext context) => const MainMahasiswaPage();
}