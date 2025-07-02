import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

/// Profile data model for MVP
class UserProfileData {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String location;
  final List<String> skills;
  final String? resumeFileName;
  final bool hasUploadedResume;
  final int applicationsCount;
  final int interviewsCount;
  final double profileCompletion;
  final String jobTitle;
  final int connectionsCount;

  const UserProfileData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.location,
    required this.skills,
    this.resumeFileName,
    required this.hasUploadedResume,
    required this.applicationsCount,
    required this.interviewsCount,
    required this.profileCompletion,
    required this.jobTitle,
    required this.connectionsCount,
  });

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'.toUpperCase();
}

/// State management for user profile data
final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfileData>((ref) {
  return ProfileNotifier();
});

/// Notifier for managing profile state
class ProfileNotifier extends StateNotifier<UserProfileData> {
  ProfileNotifier() : super(const UserProfileData(
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@example.com',
    phone: '+234 803 123 4567',
    location: 'Lagos, Nigeria',
    jobTitle: 'Senior Flutter Developer',
    skills: [
      'Flutter',
      'Dart',
      'Mobile Development',
      'REST APIs',
      'Git',
      'Firebase',
      'State Management',
      'UI/UX Design',
      'JavaScript',
      'React Native',
    ],
    resumeFileName: 'John_Doe_Resume.pdf',
    hasUploadedResume: true,
    applicationsCount: 12,
    interviewsCount: 4,
    profileCompletion: 92.0,
    connectionsCount: 156,
  ));

  void updateResume(String fileName) {
    state = UserProfileData(
      firstName: state.firstName,
      lastName: state.lastName,
      email: state.email,
      phone: state.phone,
      location: state.location,
      jobTitle: state.jobTitle,
      skills: state.skills,
      resumeFileName: fileName,
      hasUploadedResume: true,
      applicationsCount: state.applicationsCount,
      interviewsCount: state.interviewsCount,
      profileCompletion: state.profileCompletion,
      connectionsCount: state.connectionsCount,
    );
  }
}

/// Profile screen widget with modern clean design
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Clean header matching applications page
              _buildHeader(),
              
              // Profile info card
              _buildProfileCard(profile),
              
              // Quick stats cards
              _buildStatsCards(profile),
              
              // Quick actions
              _buildQuickActions(),
              
              // Skills section
              _buildSkillsCard(profile),
              
              // Settings and options
              _buildSettingsCard(),
              
              const SizedBox(height: 100), // Bottom padding for nav bar
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the header section matching the applications page style
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Profile',
                  style: AppTheme.heading1.copyWith(
                    color: AppTheme.textPrimary,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your career profile',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Icon(
              Icons.edit_outlined,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: -0.3, duration: 500.ms, curve: Curves.easeOut);
  }

  /// Builds the main profile information card
  Widget _buildProfileCard(UserProfileData profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          // Profile avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                profile.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Name and title
          Text(
            profile.fullName,
            style: AppTheme.heading2.copyWith(
              color: AppTheme.textPrimary,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            profile.jobTitle,
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Contact info
          _buildContactInfo(profile),
          
          const SizedBox(height: 20),
          
          // Profile completion
          _buildProfileCompletion(profile.profileCompletion),
        ],
      ),
    ).animate().scale(begin: const Offset(0.95, 0.95), duration: 400.ms, curve: Curves.easeOut);
  }

  /// Builds contact information section
  Widget _buildContactInfo(UserProfileData profile) {
    return Column(
      children: [
        _buildContactItem(Icons.email_outlined, profile.email),
        const SizedBox(height: 12),
        _buildContactItem(Icons.phone_outlined, profile.phone),
        const SizedBox(height: 12),
        _buildContactItem(Icons.location_on_outlined, profile.location),
      ],
    );
  }

  /// Builds individual contact item
  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds profile completion indicator
  Widget _buildProfileCompletion(double completion) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Profile Completion',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${completion.toInt()}%',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: completion / 100,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds stats cards section
  Widget _buildStatsCards(UserProfileData profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          _buildStatCard('Applications', profile.applicationsCount.toString(), Icons.work_outline, AppTheme.primaryColor),
          const SizedBox(width: 12),
          _buildStatCard('Interviews', profile.interviewsCount.toString(), Icons.people_outline, AppTheme.warningColor),
          const SizedBox(width: 12),
          _buildStatCard('Connections', profile.connectionsCount.toString(), Icons.group_outlined, AppTheme.successColor),
        ],
      ),
    ).animate().scale(begin: const Offset(0.9, 0.9), duration: 600.ms, curve: Curves.easeOut);
  }

  /// Builds individual stat card
  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds quick actions section
  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTheme.heading3.copyWith(
              color: AppTheme.textPrimary,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildActionButton(
                'Update Resume',
                Icons.upload_file_outlined,
                AppTheme.primaryColor,
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                'View Applications',
                Icons.list_alt_outlined,
                AppTheme.successColor,
              ),
            ],
          ),
        ],
      ),
    ).animate().slideX(begin: -0.2, duration: 700.ms, curve: Curves.easeOut);
  }

  /// Builds individual action button
  Widget _buildActionButton(String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds skills card section
  Widget _buildSkillsCard(UserProfileData profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Skills',
                style: AppTheme.heading3.copyWith(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                ),
              ),
              Text(
                '${profile.skills.length} skills',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: profile.skills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.1),
                      AppTheme.primaryColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  skill,
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.2, duration: 800.ms, curve: Curves.easeOut);
  }

  /// Builds settings card section
  Widget _buildSettingsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: AppTheme.heading3.copyWith(
              color: AppTheme.textPrimary,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsItem(Icons.notifications_outlined, 'Notifications', 'Manage your alerts'),
          _buildSettingsItem(Icons.security_outlined, 'Privacy & Security', 'Control your data'),
          _buildSettingsItem(Icons.help_outline, 'Help & Support', 'Get assistance'),
          _buildSettingsItem(Icons.logout_outlined, 'Sign Out', 'Log out of your account', isDestructive: true),
        ],
      ),
    ).animate().slideY(begin: 0.3, duration: 900.ms, curve: Curves.easeOut);
  }

  /// Builds individual settings item
  Widget _buildSettingsItem(IconData icon, String title, String subtitle, {bool isDestructive = false}) {
    final color = isDestructive ? AppTheme.errorColor : AppTheme.textPrimary;
    final iconColor = isDestructive ? AppTheme.errorColor : AppTheme.primaryColor;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.bodyMedium.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: AppTheme.textMuted,
            size: 16,
          ),
        ],
      ),
    );
  }
} 