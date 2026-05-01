// lib/screen/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              20, 20, 20, CustomBottomNav.totalHeight + 16,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildProfileCard(),
                const SizedBox(height: 16),
                _buildMenuSection(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 26),
          child: Text(
            'Profile',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ).animate().fadeIn(duration: 400.ms),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      decoration: AppTheme.cardDecoration(),
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: AppTheme.avatarGlow,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: ClipOval(
              child: Image.network(
                'https://i.pravatar.cc/300?img=47',
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primary, AppTheme.primaryLight],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'AF',
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
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aruna Fajar, M.Kom',
                  style: GoogleFonts.poppins(
                    color: AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Senior Academic Counselor',
                  style: GoogleFonts.poppins(
                    color: AppTheme.textSecondary,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGhost,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'NIP: 198501012010011001',
                    style: GoogleFonts.poppins(
                      color: AppTheme.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildMenuSection() {
    final items = [
      (Icons.person_outline_rounded, 'Edit Profile', 'Update your personal information'),
      (Icons.lock_outline_rounded, 'Change Password', 'Keep your account secure'),
      (Icons.notifications_outlined, 'Notifications', 'Manage your preferences'),
      (Icons.help_outline_rounded, 'Help & Support', 'Get help or report an issue'),
      (Icons.logout_rounded, 'Sign Out', 'Log out of your account'),
    ];

    return Container(
      decoration: AppTheme.cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: List.generate(items.length, (i) {
          final (icon, title, sub) = items[i];
          final isLast = i == items.length - 1;
          final isLogout = i == items.length - 1;

          return Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isLogout
                        ? AppTheme.declinedBg
                        : AppTheme.primaryGhost,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: isLogout ? AppTheme.declined : AppTheme.primary,
                  ),
                ),
                title: Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: isLogout
                        ? AppTheme.declined
                        : AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  sub,
                  style: GoogleFonts.poppins(
                    color: AppTheme.textMuted,
                    fontSize: 11.5,
                  ),
                ),
                trailing: isLogout
                    ? null
                    : const Icon(
                        Icons.chevron_right_rounded,
                        color: AppTheme.textMuted,
                        size: 20,
                      ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 4,
                ),
                onTap: () {},
              ),
              if (!isLast)
                const Divider(
                  height: 1,
                  indent: 60,
                  endIndent: 20,
                  color: Color(0xFFF1F5F9),
                ),
            ],
          );
        }),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.1, end: 0);
  }
}