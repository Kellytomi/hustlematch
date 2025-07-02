import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../data/models/job.dart';

/// Represents the status of a job application.
/// 
/// Used to track the progress of applications through the hiring process.
enum ApplicationStatus {
  /// Application has been submitted and is pending review
  applied,
  
  /// Application is currently being reviewed by the employer
  reviewing,
  
  /// Candidate has been invited for an interview
  interview,
  
  /// Job offer has been extended to the candidate
  offered,
  
  /// Application has been rejected
  rejected,
}

/// Represents a job application with tracking information.
/// 
/// This model extends basic job information with application-specific
/// data such as status, dates, and progress tracking.
class JobApplication {
  /// Unique identifier for the application
  final String id;
  
  /// Title of the applied position
  final String jobTitle;
  
  /// Name of the hiring company
  final String company;
  
  /// Company logo or emoji representation
  final String companyLogo;
  
  /// Current status of the application
  final ApplicationStatus status;
  
  /// Date when the application was submitted
  final DateTime appliedDate;
  
  /// Job location
  final String location;
  
  /// Salary range for the position
  final String salary;
  
  /// Percentage match with user profile
  final double matchPercentage;
  
  /// Required skills for the position
  final List<String> skills;
  
  /// Color associated with the application status
  final Color statusColor;

  /// Creates a new [JobApplication] instance.
  const JobApplication({
    required this.id,
    required this.jobTitle,
    required this.company,
    required this.companyLogo,
    required this.status,
    required this.appliedDate,
    required this.location,
    required this.salary,
    required this.matchPercentage,
    required this.skills,
    required this.statusColor,
  });

  /// Returns a user-friendly status message.
  String get statusMessage {
    switch (status) {
      case ApplicationStatus.applied:
        return 'Application Submitted';
      case ApplicationStatus.reviewing:
        return 'Under Review';
      case ApplicationStatus.interview:
        return 'Interview Scheduled';
      case ApplicationStatus.offered:
        return 'Offer Received';
      case ApplicationStatus.rejected:
        return 'Application Rejected';
    }
  }

  /// Returns the number of days since application was submitted.
  int get daysSinceApplied {
    return DateTime.now().difference(appliedDate).inDays;
  }

  /// Returns a formatted time string for when the application was submitted.
  String get appliedTimeAgo {
    final days = daysSinceApplied;
    if (days == 0) return 'Today';
    if (days == 1) return '1 day ago';
    return '$days days ago';
  }
}

/// State management for application tracking.
/// 
/// Manages the list of job applications and provides methods for
/// filtering and sorting applications.
final applicationTrackerProvider = StateNotifierProvider<ApplicationTrackerNotifier, List<JobApplication>>((ref) {
  return ApplicationTrackerNotifier();
});

/// Notifier for managing application tracking state.
class ApplicationTrackerNotifier extends StateNotifier<List<JobApplication>> {
  ApplicationTrackerNotifier() : super([]) {
    _loadApplications();
  }

  /// Loads mock application data.
  /// 
  /// In a real app, this would fetch data from an API or local database.
  void _loadApplications() {
    final mockApplications = [
      JobApplication(
        id: '1',
        jobTitle: 'Senior Flutter Developer',
        company: 'TechCorp Nigeria',
        companyLogo: '🏢',
        status: ApplicationStatus.interview,
        appliedDate: DateTime.now().subtract(const Duration(days: 3)),
        location: 'Lagos, Nigeria',
        salary: '₦2.5M - ₦4M /year',
        matchPercentage: 92.0,
        skills: ['Flutter', 'Dart', 'Firebase'],
        statusColor: AppTheme.warningColor,
      ),
      JobApplication(
        id: '2',
        jobTitle: 'Product Manager',
        company: 'Fintech Solutions Ltd',
        companyLogo: '💳',
        status: ApplicationStatus.reviewing,
        appliedDate: DateTime.now().subtract(const Duration(days: 5)),
        location: 'Abuja, Nigeria',
        salary: '₦3M - ₦5M /year',
        matchPercentage: 88.0,
        skills: ['Product Strategy', 'Analytics'],
        statusColor: AppTheme.secondaryColor,
      ),
      JobApplication(
        id: '3',
        jobTitle: 'Backend Engineer',
        company: 'DataFlow Systems',
        companyLogo: '⚡',
        status: ApplicationStatus.offered,
        appliedDate: DateTime.now().subtract(const Duration(days: 7)),
        location: 'Lagos, Nigeria',
        salary: '₦2.8M - ₦4.5M /year',
        matchPercentage: 85.0,
        skills: ['Node.js', 'MongoDB', 'AWS'],
        statusColor: AppTheme.successColor,
      ),
      JobApplication(
        id: '4',
        jobTitle: 'UI/UX Designer',
        company: 'Creative Studio',
        companyLogo: '🎨',
        status: ApplicationStatus.applied,
        appliedDate: DateTime.now().subtract(const Duration(days: 1)),
        location: 'Port Harcourt, Nigeria',
        salary: '₦1.8M - ₦3.2M /year',
        matchPercentage: 90.0,
        skills: ['Figma', 'Design Systems'],
        statusColor: AppTheme.textSecondary,
      ),
      JobApplication(
        id: '5',
        jobTitle: 'Digital Marketing Manager',
        company: 'GrowthLab Africa',
        companyLogo: '📈',
        status: ApplicationStatus.rejected,
        appliedDate: DateTime.now().subtract(const Duration(days: 10)),
        location: 'Remote',
        salary: '₦2.2M - ₦3.8M /year',
        matchPercentage: 75.0,
        skills: ['SEO', 'Google Ads', 'Analytics'],
        statusColor: AppTheme.errorColor,
      ),
      JobApplication(
        id: '6',
        jobTitle: 'Data Scientist',
        company: 'Analytics Pro',
        companyLogo: '📊',
        status: ApplicationStatus.interview,
        appliedDate: DateTime.now().subtract(const Duration(days: 2)),
        location: 'Lagos, Nigeria',
        salary: '₦3.5M - ₦5.5M /year',
        matchPercentage: 87.0,
        skills: ['Python', 'Machine Learning', 'SQL'],
        statusColor: AppTheme.warningColor,
      ),
    ];

    state = mockApplications;
  }

  /// Refreshes the applications list.
  /// 
  /// In a real app, this would make an API call to fetch updated data.
  Future<void> refreshApplications() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    _loadApplications();
  }
}

/// Modern, clean tracker screen matching the app's design system.
/// 
/// This screen provides a comprehensive view of job applications with
/// filtering, search, and detailed statistics using the app's teal theme.
class TrackerScreen extends ConsumerStatefulWidget {
  const TrackerScreen({super.key});

  @override
  ConsumerState<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends ConsumerState<TrackerScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final applications = ref.watch(applicationTrackerProvider);
    final filteredApplications = _filterApplications(applications);
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Modern Header
              _buildModernHeader(),
              
              // Compact Stats Overview
              _buildCompactStatsOverview(applications),
              
              // Search and Tab Bar
              _buildSearchAndTabs(),
              
              // Applications List
              Expanded(
                child: _buildApplicationsList(filteredApplications),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the modern header section.
  Widget _buildModernHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        Responsive.value(context, mobile: 24, tablet: 32, desktop: 48),
        Responsive.value(context, mobile: 24, tablet: 32, desktop: 40),
        Responsive.value(context, mobile: 24, tablet: 32, desktop: 48),
        16,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Applications',
                  style: AppTheme.heading1.copyWith(
                    color: AppTheme.textPrimary,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Track your career journey',
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
              Icons.notifications_outlined,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: -0.3, duration: 500.ms, curve: Curves.easeOut);
  }

  /// Builds a compact stats overview section.
  Widget _buildCompactStatsOverview(List<JobApplication> applications) {
    final stats = _calculateStats(applications);
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Responsive.value(context, mobile: 16, tablet: 24, desktop: 32),
        vertical: 8,
      ),
      child: Row(
        children: [
          _buildStatCard('Total', stats['total'].toString(), Icons.work_outline, AppTheme.primaryColor),
          SizedBox(width: Responsive.spacing(context, mobile: 8, tablet: 12, desktop: 16)),
          _buildStatCard('Active', stats['active'].toString(), Icons.trending_up, AppTheme.successColor),
          SizedBox(width: Responsive.spacing(context, mobile: 8, tablet: 12, desktop: 16)),
          _buildStatCard('Interviews', stats['interviews'].toString(), Icons.people_outline, AppTheme.warningColor),
          SizedBox(width: Responsive.spacing(context, mobile: 8, tablet: 12, desktop: 16)),
          _buildStatCard('Offers', stats['offers'].toString(), Icons.star_outline, AppTheme.secondaryColor),
        ],
      ),
    ).animate().scale(begin: const Offset(0.9, 0.9), duration: 600.ms, curve: Curves.easeOut);
  }

  /// Returns shorter labels for small devices
  String _getShortLabel(String label) {
    if (!Responsive.isSmallMobile(context)) return label;
    
    switch (label) {
      case 'Interviews':
        return 'Intrvws';
      case 'Total':
        return 'Total';
      case 'Active':
        return 'Active';
      case 'Offers':
        return 'Offers';
      default:
        return label;
    }
  }

  /// Builds individual compact stat cards.
  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Responsive.value(context, mobile: 12, tablet: 16, desktop: 20),
          horizontal: Responsive.value(context, mobile: 6, tablet: 12, desktop: 16),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            Responsive.borderRadius(context, mobile: 12, tablet: 16, desktop: 20),
          ),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(
                Responsive.value(context, mobile: 6, tablet: 8, desktop: 10),
              ),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                  Responsive.value(context, mobile: 8, tablet: 10, desktop: 12),
                ),
              ),
              child: Icon(
                icon, 
                color: color, 
                size: Responsive.iconSize(context, mobile: 16, tablet: 20, desktop: 24),
              ),
            ),
            SizedBox(height: Responsive.value(context, mobile: 6, tablet: 8, desktop: 10)),
            Text(
              value,
              style: TextStyle(
                fontSize: Responsive.fontSize(context, mobile: 16, tablet: 18, desktop: 22),
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: Responsive.value(context, mobile: 2, tablet: 3, desktop: 4)),
            Text(
              _getShortLabel(label),
              style: TextStyle(
                fontSize: Responsive.fontSize(context, mobile: 9, tablet: 11, desktop: 13),
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the search bar and tab navigation.
  Widget _buildSearchAndTabs() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Responsive.value(context, mobile: 16, tablet: 24, desktop: 32),
        vertical: Responsive.value(context, mobile: 12, tablet: 16, desktop: 20),
      ),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppTheme.cardShadow,
            ),
            child: TextField(
              controller: _searchController,
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search applications...',
                hintStyle: AppTheme.bodyMedium.copyWith(color: AppTheme.textMuted),
                prefixIcon: Icon(
                  Icons.search,
                  color: _isSearching ? AppTheme.primaryColor : AppTheme.textMuted,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        color: AppTheme.textMuted,
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                            _isSearching = false;
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _isSearching = value.isNotEmpty;
                });
              },
              onTap: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Modern Tab Bar with Cross-Platform Consistency
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppTheme.cardShadow,
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.symmetric(
                horizontal: Responsive.value(context, mobile: 6, tablet: 8, desktop: 10),
                vertical: 4,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppTheme.textSecondary,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                letterSpacing: 0.3,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              dividerColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              isScrollable: false,
              tabAlignment: TabAlignment.fill,
              tabs: [
                SizedBox(
                  width: Responsive.tabWidth(context),
                  height: Responsive.value(context, mobile: 36, tablet: 42, desktop: 48),
                  child: const Tab(
                    child: Text(
                      'All',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                SizedBox(
                  width: Responsive.tabWidth(context),
                  height: Responsive.value(context, mobile: 36, tablet: 42, desktop: 48),
                  child: const Tab(
                    child: Text(
                      'Active',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                SizedBox(
                  width: Responsive.tabWidth(context),
                  height: Responsive.value(context, mobile: 36, tablet: 42, desktop: 48),
                  child: Tab(
                    child: Text(
                      Responsive.isSmallMobile(context) ? 'Archive' : 'Archived',
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().slideX(begin: -0.2, duration: 700.ms, curve: Curves.easeOut);
  }

  /// Builds the applications list.
  Widget _buildApplicationsList(List<JobApplication> applications) {
    if (applications.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Responsive.value(context, mobile: 16, tablet: 24, desktop: 32),
      ),
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildApplicationsGrid(applications),
          _buildApplicationsGrid(_getActiveApplications(applications)),
          _buildApplicationsGrid(_getArchivedApplications(applications)),
        ],
      ),
    );
  }

  /// Builds a list of modern application cards.
  Widget _buildApplicationsGrid(List<JobApplication> applications) {
    if (applications.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: applications.length,
      itemBuilder: (context, index) {
        final application = applications[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildApplicationCard(application),
        ).animate(delay: (index * 100).ms).slideY(
          begin: 0.2,
          duration: 500.ms,
          curve: Curves.easeOut,
        ).fadeIn();
      },
    );
  }

  /// Builds a modern application card.
  Widget _buildApplicationCard(JobApplication application) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Handle card tap
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with company info
                Row(
                  children: [
                    Container(
                      width: Responsive.value(context, mobile: 50, tablet: 60, desktop: 70),
                      height: Responsive.value(context, mobile: 50, tablet: 60, desktop: 70),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          Responsive.value(context, mobile: 16, tablet: 20, desktop: 24),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          application.companyLogo,
                          style: TextStyle(
                            fontSize: Responsive.value(context, mobile: 24, tablet: 28, desktop: 32),
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
                            application.jobTitle,
                            style: AppTheme.heading3.copyWith(
                              color: AppTheme.textPrimary,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            application.company,
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: application.statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: application.statusColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${application.matchPercentage.toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: application.statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Location and salary
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppTheme.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      application.location,
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.attach_money,
                      size: 16,
                      color: AppTheme.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        application.salary,
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Skills
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: application.skills.take(3).map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        skill,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 16),
                
                // Status and time
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: application.statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getStatusIcon(application.status),
                            size: 12,
                            color: application.statusColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            application.statusMessage,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: application.statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      application.appliedTimeAgo,
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.more_vert,
                        color: AppTheme.textMuted,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the empty state when no applications are found.
  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        margin: const EdgeInsets.symmetric(horizontal: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off,
                size: 48,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Applications Found',
              style: AppTheme.heading3.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Filters applications based on search query.
  List<JobApplication> _filterApplications(List<JobApplication> applications) {
    if (_searchQuery.isEmpty) return applications;
    
    return applications.where((app) {
      return app.jobTitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             app.company.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             app.location.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  /// Gets only active applications (not rejected).
  List<JobApplication> _getActiveApplications(List<JobApplication> applications) {
    return applications.where((app) => app.status != ApplicationStatus.rejected).toList();
  }

  /// Gets archived applications (rejected).
  List<JobApplication> _getArchivedApplications(List<JobApplication> applications) {
    return applications.where((app) => app.status == ApplicationStatus.rejected).toList();
  }

  /// Calculates statistics for the overview section.
  Map<String, int> _calculateStats(List<JobApplication> applications) {
    return {
      'total': applications.length,
      'active': _getActiveApplications(applications).length,
      'interviews': applications.where((app) => app.status == ApplicationStatus.interview).length,
      'offers': applications.where((app) => app.status == ApplicationStatus.offered).length,
    };
  }

  /// Returns the appropriate icon for each application status.
  IconData _getStatusIcon(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.applied:
        return Icons.send;
      case ApplicationStatus.reviewing:
        return Icons.visibility;
      case ApplicationStatus.interview:
        return Icons.people;
      case ApplicationStatus.offered:
        return Icons.star;
      case ApplicationStatus.rejected:
        return Icons.close;
    }
  }
} 
