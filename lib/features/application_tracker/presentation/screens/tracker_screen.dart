import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

// Application status enum
enum ApplicationStatus {
  applied,
  reviewing,
  interview,
  offered,
  rejected,
}

// Simple application model for MVP
class JobApplication {
  final String id;
  final String jobTitle;
  final String company;
  final String companyLogo;
  final ApplicationStatus status;
  final DateTime appliedDate;
  final String location;
  final String salary;
  final double matchPercentage;
  final List<String> skills;

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
  });
}

// State management
final applicationTrackerProvider = StateNotifierProvider<ApplicationTrackerNotifier, List<JobApplication>>((ref) {
  return ApplicationTrackerNotifier();
});

class ApplicationTrackerNotifier extends StateNotifier<List<JobApplication>> {
  ApplicationTrackerNotifier() : super([]) {
    _loadApplications();
  }

  void _loadApplications() {
    // Mock application data for MVP
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
      ),
    ];

    state = mockApplications;
  }
}

class TrackerScreen extends ConsumerStatefulWidget {
  const TrackerScreen({super.key});

  @override
  ConsumerState<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends ConsumerState<TrackerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final applications = ref.watch(applicationTrackerProvider);
    final filteredApplications = _filterApplications(applications);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Modern Header with gradient
            _buildModernHeader(),
            
            // Search Bar with enhanced design
            _buildSearchBar(),
            
            // Enhanced Stats Overview
            _buildStatsOverview(applications),
            
            // Modern Tab Bar
            _buildCustomTabBar(),
            
            // Content with animation
            Expanded(
              child: filteredApplications.isEmpty
                  ? _buildEmptyState()
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildApplicationsList(filteredApplications),
                        _buildApplicationsList(_getActiveApplications(filteredApplications)),
                        _buildApplicationsList(_getArchivedApplications(filteredApplications)),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withValues(alpha: 0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Applications',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Track your career journey',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search applications...',
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.search,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildStatsOverview(List<JobApplication> applications) {
    final totalApps = applications.length;
    final activeApps = _getActiveApplications(applications).length;
    final interviews = applications.where((app) => app.status == ApplicationStatus.interview).length;
    final offers = applications.where((app) => app.status == ApplicationStatus.offered).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withValues(alpha: 0.2),
                      AppTheme.primaryColor.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.analytics_outlined,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Application Overview',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'Your progress this month',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildStatItem('Total', totalApps.toString(), Icons.work_outline, AppTheme.primaryColor),
              _buildStatDivider(),
              _buildStatItem('Active', activeApps.toString(), Icons.trending_up, Colors.blue),
              _buildStatDivider(),
              _buildStatItem('Interviews', interviews.toString(), Icons.people_outline, Colors.orange),
              _buildStatDivider(),
              _buildStatItem('Offers', offers.toString(), Icons.star_outline, AppTheme.successColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.grey.shade300,
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.white,
        unselectedLabelColor: AppTheme.textSecondary,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primaryColor, AppTheme.primaryColor.withValues(alpha: 0.8)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'All Applications'),
          Tab(text: 'Active'),
          Tab(text: 'Archived'),
        ],
      ),
    );
  }

  Widget _buildApplicationsList(List<JobApplication> applications) {
    if (applications.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: applications.length,
      itemBuilder: (context, index) {
        final application = applications[index];
        return AnimatedContainer(
          duration: Duration(milliseconds: 200 + (index * 50)),
          curve: Curves.easeOutCubic,
          child: _buildApplicationCard(application),
        );
      },
    );
  }

  Widget _buildApplicationCard(JobApplication application) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with company and match percentage
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor.withValues(alpha: 0.2),
                        AppTheme.primaryColor.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      application.companyLogo,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        application.company,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        application.jobTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.successColor.withValues(alpha: 0.2),
                        AppTheme.successColor.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.successColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 14,
                        color: AppTheme.successColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${application.matchPercentage.toInt()}%',
                        style: TextStyle(
                          color: AppTheme.successColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Job details section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          Icons.location_on_outlined,
                          application.location,
                          AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoItem(
                          Icons.schedule_outlined,
                          _formatDate(application.appliedDate),
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoItem(
                    Icons.payments_outlined,
                    application.salary,
                    Colors.green,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Skills and status row
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: application.skills.take(3).map((skill) => 
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.primaryColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          skill,
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ).toList(),
                  ),
                ),
                const SizedBox(width: 12),
                _buildStatusBadge(application.status),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(application.status),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_vert,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(ApplicationStatus status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case ApplicationStatus.applied:
        color = Colors.blue;
        text = 'Applied';
        icon = Icons.send_outlined;
        break;
      case ApplicationStatus.reviewing:
        color = Colors.orange;
        text = 'Under Review';
        icon = Icons.visibility_outlined;
        break;
      case ApplicationStatus.interview:
        color = AppTheme.primaryColor;
        text = 'Interview';
        icon = Icons.people_outline;
        break;
      case ApplicationStatus.offered:
        color = AppTheme.successColor;
        text = 'Offered';
        icon = Icons.star_outline;
        break;
      case ApplicationStatus.rejected:
        color = AppTheme.errorColor;
        text = 'Not Selected';
        icon = Icons.close_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.2),
            color.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(ApplicationStatus status) {
    String text;
    IconData icon;
    Color? backgroundColor;
    Color? textColor;

    switch (status) {
      case ApplicationStatus.interview:
        text = 'Schedule Interview';
        icon = Icons.event_outlined;
        backgroundColor = AppTheme.primaryColor;
        textColor = Colors.white;
        break;
      case ApplicationStatus.offered:
        text = 'Accept Offer';
        icon = Icons.handshake_outlined;
        backgroundColor = AppTheme.successColor;
        textColor = Colors.white;
        break;
      case ApplicationStatus.reviewing:
        text = 'Follow Up';
        icon = Icons.message_outlined;
        backgroundColor = null;
        textColor = AppTheme.primaryColor;
        break;
      default:
        text = 'View Details';
        icon = Icons.visibility_outlined;
        backgroundColor = null;
        textColor = AppTheme.primaryColor;
    }

    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18),
      label: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.transparent,
        foregroundColor: textColor,
        elevation: backgroundColor != null ? 2 : 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: backgroundColor == null 
            ? BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.3), width: 1.5)
            : BorderSide.none,
        ),
        shadowColor: backgroundColor?.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.shade100,
                    Colors.grey.shade50,
                  ],
                ),
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.work_outline,
                size: 60,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No applications yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start exploring jobs and track your applications here.\nYour career journey begins with a single swipe!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.go('/discovery'),
              icon: const Icon(Icons.explore),
              label: const Text('Start Exploring Jobs'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 2,
                shadowColor: AppTheme.primaryColor.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<JobApplication> _filterApplications(List<JobApplication> applications) {
    if (_searchQuery.isEmpty) return applications;
    
    return applications.where((app) =>
      app.jobTitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      app.company.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  List<JobApplication> _getActiveApplications(List<JobApplication> applications) {
    return applications.where((app) => app.status != ApplicationStatus.rejected).toList();
  }

  List<JobApplication> _getArchivedApplications(List<JobApplication> applications) {
    return applications.where((app) => app.status == ApplicationStatus.rejected).toList();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${(difference.inDays / 7).floor()} weeks ago';
    }
  }
} 