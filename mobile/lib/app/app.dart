import 'package:flutter/material.dart';
import '../features/auth/view/login_page.dart';
import '../features/loglearning/view/learning_placeholder_page.dart';
import '../features/dosen/view/dashboard_dosen_page.dart';
import '../features/main_mahasiswa/main_mahasiswa_page.dart';

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
        dashboardRoute: (_) => const MainMahasiswaPage(),
        dashboardDosenRoute: (_) => const DashboardDosenPage(),
        learningRoute: (_) => const LearningPlaceholderPage(),
      },
    );
  }
}