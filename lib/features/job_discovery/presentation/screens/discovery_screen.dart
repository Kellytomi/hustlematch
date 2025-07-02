import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';

// Simple data classes for MVP
class SimpleJob {
  final String id;
  final String title;
  final String company;
  final String description;
  final List<String> skills;
  final String location;
  final String salary;
  final String type;
  final String level;
  final String companyLogo;
  
  const SimpleJob({
    required this.id,
    required this.title,
    required this.company,
    required this.description,
    required this.skills,
    required this.location,
    required this.salary,
    required this.type,
    required this.level,
    required this.companyLogo,
  });
}

// State management for job discovery
final jobDiscoveryProvider = StateNotifierProvider<JobDiscoveryNotifier, JobDiscoveryState>((ref) {
  return JobDiscoveryNotifier();
});

class JobDiscoveryState {
  final List<SimpleJob> jobs;
  final int currentIndex;
  final bool isLoading;
  final String? error;

  const JobDiscoveryState({
    required this.jobs,
    required this.currentIndex,
    required this.isLoading,
    this.error,
  });

  JobDiscoveryState copyWith({
    List<SimpleJob>? jobs,
    int? currentIndex,
    bool? isLoading,
    String? error,
  }) {
    return JobDiscoveryState(
      jobs: jobs ?? this.jobs,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class JobDiscoveryNotifier extends StateNotifier<JobDiscoveryState> {
  JobDiscoveryNotifier() : super(const JobDiscoveryState(
    jobs: [],
    currentIndex: 0,
    isLoading: true,
  )) {
    _loadJobs();
  }

  void _loadJobs() {
    // Mock job data for MVP
    final mockJobs = [
      const SimpleJob(
        id: '1',
        title: 'Senior Flutter Developer',
        company: 'TechCorp Nigeria',
        description: 'Join our dynamic team building mobile apps that serve millions of users across Nigeria. We\'re looking for a passionate Flutter developer to help us scale our platform.\n\nWhat you\'ll do:\n• Build beautiful, performant mobile applications\n• Collaborate with designers and backend teams\n• Mentor junior developers\n• Contribute to technical architecture decisions',
        skills: ['Flutter', 'Dart', 'REST APIs', 'Git', 'Firebase'],
        location: 'Lagos, Nigeria',
        salary: '₦2.5M - ₦4M /year',
        type: 'Full-time',
        level: 'Senior Level',
        companyLogo: '🏢',
      ),
      const SimpleJob(
        id: '2',
        title: 'Product Manager',
        company: 'Fintech Solutions Ltd',
        description: 'Lead product strategy for our fintech platform serving the Nigerian market. Drive innovation in digital payments and financial inclusion.\n\nResponsibilities:\n• Define product roadmap and strategy\n• Work with engineering and design teams\n• Analyze user data and market trends\n• Manage stakeholder relationships',
        skills: ['Product Management', 'Fintech', 'Data Analysis', 'Leadership'],
        location: 'Abuja, Nigeria (Remote)',
        salary: '₦3M - ₦5M /year',
        type: 'Full-time',
        level: 'Mid Level',
        companyLogo: '💳',
      ),
      const SimpleJob(
        id: '3',
        title: 'UI/UX Designer',
        company: 'Creative Studio',
        description: 'Create beautiful and intuitive user experiences for web and mobile applications. Work with cutting-edge design tools and methodologies.\n\nWhat we offer:\n• Creative freedom and autonomy\n• Latest design tools and resources\n• Collaborative team environment\n• Professional development opportunities',
        skills: ['Figma', 'User Research', 'Prototyping', 'Design Systems'],
        location: 'Port Harcourt, Nigeria',
        salary: '₦1.8M - ₦3.2M /year',
        type: 'Full-time',
        level: 'Mid Level',
        companyLogo: '🎨',
      ),
      const SimpleJob(
        id: '4',
        title: 'Backend Engineer',
        company: 'DataFlow Systems',
        description: 'Build scalable backend systems that power our data analytics platform. Work with modern technologies and handle millions of API requests daily.\n\nTech Stack:\n• Node.js, Python, PostgreSQL\n• AWS, Docker, Kubernetes\n• Microservices architecture\n• Real-time data processing',
        skills: ['Node.js', 'Python', 'PostgreSQL', 'AWS', 'Docker'],
        location: 'Lagos, Nigeria',
        salary: '₦2.8M - ₦4.5M /year',
        type: 'Full-time',
        level: 'Senior Level',
        companyLogo: '⚡',
      ),
      const SimpleJob(
        id: '5',
        title: 'Digital Marketing Manager',
        company: 'GrowthLab Africa',
        description: 'Drive digital marketing campaigns for fast-growing startups across Africa. Lead performance marketing initiatives and build data-driven strategies.\n\nKey Areas:\n• Performance marketing (Google, Facebook, LinkedIn)\n• Marketing automation and analytics\n• Content strategy and SEO\n• Team leadership and mentoring',
        skills: ['Digital Marketing', 'Analytics', 'SEO', 'Social Media', 'Leadership'],
        location: 'Remote',
        salary: '₦2.2M - ₦3.8M /year',
        type: 'Full-time',
        level: 'Mid Level',
        companyLogo: '📈',
      ),
    ];

    state = state.copyWith(
      jobs: mockJobs,
      isLoading: false,
    );
  }

  void likeJob(String jobId) {
    // In a real app, this would save to backend and trigger auto-apply
    _nextJob();
  }

  void skipJob(String jobId) {
    _nextJob();
  }

  void _nextJob() {
    if (state.currentIndex < state.jobs.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    } else {
      // Reset to start for MVP demo
      state = state.copyWith(currentIndex: 0);
    }
  }
}

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen>
    with TickerProviderStateMixin {
  late AnimationController _cardController;
  late Animation<Offset> _cardOffsetAnimation;
  late Animation<double> _cardRotationAnimation;
  late Animation<double> _cardScaleAnimation;
  double _dragOffset = 0;

  @override
  void initState() {
    super.initState();
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _cardOffsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeInOut,
    ));
    
    _cardRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.2,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeInOut,
    ));
    
    _cardScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  void _handleSwipe(bool isLike, String jobId, String jobTitle) {
    _cardController.forward().then((_) {
      if (isLike) {
        ref.read(jobDiscoveryProvider.notifier).likeJob(jobId);
        _showAutoApplyMessage(jobTitle);
      } else {
        ref.read(jobDiscoveryProvider.notifier).skipJob(jobId);
      }
      _cardController.reset();
    });
  }

  void _handleSwipeAnimation(bool isLike, String jobId, String jobTitle) {
    // Update animations for directional swipe
    _cardOffsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: isLike ? const Offset(1.5, -0.2) : const Offset(-1.5, -0.2),
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeInOut,
    ));
    
    _cardRotationAnimation = Tween<double>(
      begin: _dragOffset * 0.0008,
      end: isLike ? 0.3 : -0.3,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeInOut,
    ));
    
    // Execute the swipe
    _cardController.forward().then((_) {
      setState(() {
        _dragOffset = 0;
      });
      
      if (isLike) {
        ref.read(jobDiscoveryProvider.notifier).likeJob(jobId);
        _showAutoApplyMessage(jobTitle);
      } else {
        ref.read(jobDiscoveryProvider.notifier).skipJob(jobId);
      }
      _cardController.reset();
      
      // Reset animations for next card
      _cardOffsetAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(1.5, 0.0),
      ).animate(CurvedAnimation(
        parent: _cardController,
        curve: Curves.easeInOut,
      ));
      
      _cardRotationAnimation = Tween<double>(
        begin: 0.0,
        end: 0.2,
      ).animate(CurvedAnimation(
        parent: _cardController,
        curve: Curves.easeInOut,
      ));
    });
  }

  void _showAutoApplyMessage(String jobTitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Auto-applying to $jobTitle...'),
            ),
          ],
        ),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Builds the header section matching the applications page style.
  Widget _buildHeader() {
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
                  'Discover Jobs',
                  style: AppTheme.heading1.copyWith(
                    color: AppTheme.textPrimary,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Find your perfect match',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.go('/profile'),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Icon(
                Icons.person,
                color: AppTheme.primaryColor,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: -0.3, duration: 500.ms, curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final discoveryState = ref.watch(jobDiscoveryProvider);
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom header matching applications page
            _buildHeader(),
            
            // Main content
            Expanded(
              child: discoveryState.isLoading
                  ? Center(
                      child: const CircularProgressIndicator()
                          .animate()
                          .scale(duration: 800.ms, curve: Curves.elasticOut)
                          .fadeIn(),
                    )
                  : discoveryState.jobs.isEmpty
                      ? _buildEmptyState()
                      : _buildJobCards(discoveryState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.work_outline,
              size: 64,
              color: AppTheme.primaryColor,
            ),
          ).animate().scale(duration: 800.ms, curve: Curves.elasticOut),
          
          const SizedBox(height: 24),
          
          Text(
            'No more jobs for now',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.3),
          
          const SizedBox(height: 12),
          
          Text(
            'Check back later for new opportunities',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3),
          
          const SizedBox(height: 32),
          
          ElevatedButton.icon(
            onPressed: () => ref.read(jobDiscoveryProvider.notifier)._loadJobs(),
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh Jobs'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ).animate(delay: 600.ms).scale(duration: 600.ms, curve: Curves.elasticOut),
        ],
      ),
    );
  }

  Widget _buildJobCards(JobDiscoveryState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          // Background cards for depth
          if (state.currentIndex + 1 < state.jobs.length)
            Transform.translate(
              offset: const Offset(0, 8),
              child: Transform.scale(
                scale: 0.95,
                child: _buildJobCard(state.jobs[state.currentIndex + 1], isBackground: true),
              ),
            ),
          
          // Current card with gesture detection
          if (state.currentIndex < state.jobs.length)
            GestureDetector(
              onPanStart: (details) {
                // Reset drag offset when starting new gesture
                setState(() {
                  _dragOffset = 0;
                });
              },
              onPanUpdate: (details) {
                // Handle real-time dragging
                setState(() {
                  _dragOffset += details.delta.dx;
                  // Clamp the drag offset to prevent excessive movement
                  _dragOffset = _dragOffset.clamp(-250.0, 250.0);
                });
              },
              onPanEnd: (details) {
                final velocity = details.velocity.pixelsPerSecond.dx;
                final screenWidth = MediaQuery.of(context).size.width;
                
                // Determine swipe direction and threshold
                if (_dragOffset < -80 || velocity < -500) {
                  // Swipe left - Skip job
                  _handleSwipeAnimation(false, state.jobs[state.currentIndex].id, state.jobs[state.currentIndex].title);
                } else if (_dragOffset > 80 || velocity > 500) {
                  // Swipe right - Apply to job
                  _handleSwipeAnimation(true, state.jobs[state.currentIndex].id, state.jobs[state.currentIndex].title);
                } else {
                  // Return to center
                  setState(() {
                    _dragOffset = 0;
                  });
                }
              },
              child: AnimatedBuilder(
                animation: _cardController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_dragOffset + (_cardOffsetAnimation.value.dx * MediaQuery.of(context).size.width), _cardOffsetAnimation.value.dy),
                    child: Transform.rotate(
                      angle: _cardRotationAnimation.value + (_dragOffset * 0.0008),
                      child: Transform.scale(
                        scale: _cardScaleAnimation.value,
                        child: Stack(
                          children: [
                            _buildJobCard(state.jobs[state.currentIndex])
                                .animate()
                                .scale(begin: const Offset(0.95, 0.95), duration: 400.ms, curve: Curves.easeOut)
                                .fadeIn(duration: 300.ms),
                            
                            // Stamp overlay on current card
                            if (_dragOffset != 0) ...[
                              // Left stamp (SKIP)
                              if (_dragOffset < 0)
                                Positioned(
                                  left: 60,
                                  top: 150,
                                  child: Transform.rotate(
                                    angle: -0.2,
                                    child: Opacity(
                                      opacity: (_dragOffset.abs() / 120).clamp(0.4, 0.95),
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.9),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppTheme.errorColor,
                                            width: 4,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.close,
                                                color: AppTheme.errorColor,
                                                size: 28,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'SKIP',
                                                style: TextStyle(
                                                  color: AppTheme.errorColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              
                              // Right stamp (APPLY) - Bold and prominent
                              if (_dragOffset > 0)
                                Positioned(
                                  right: 50,
                                  top: 140,
                                  child: Transform.rotate(
                                    angle: 0.2,
                                    child: Opacity(
                                      opacity: (_dragOffset.abs() / 100).clamp(0.6, 1.0),
                                      child: Container(
                                        width: Responsive.stampSize(context),
                                        height: Responsive.stampSize(context),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppTheme.successColor,
                                            width: 6,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppTheme.successColor.withValues(alpha: 0.4),
                                              blurRadius: 16,
                                              offset: const Offset(0, 6),
                                            ),
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.2),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.favorite,
                                                color: AppTheme.successColor,
                                                size: 36,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'APPLY',
                                                style: TextStyle(
                                                  color: AppTheme.successColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w900,
                                                  letterSpacing: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildJobCard(SimpleJob job, {bool isBackground = false}) {
    return Container(
      width: double.infinity,
      height: Responsive.jobCardHeight(context),
      decoration: BoxDecoration(
        color: isBackground ? Colors.grey.shade200 : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isBackground ? [] : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company header - Clean design
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor.withOpacity(0.15),
                        AppTheme.primaryColor.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      job.companyLogo,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.company,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          fontSize: 22,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Match percentage badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '95%',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Job details - Professional layout
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildDetailItem(Icons.location_on_outlined, 'Location', job.location)),
                      Expanded(child: _buildDetailItem(Icons.payments_outlined, 'Salary', job.salary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildDetailItem(Icons.access_time_outlined, 'Type', job.type)),
                      Expanded(child: _buildDetailItem(Icons.trending_up_outlined, 'Level', job.level)),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Skills section - Clean modern design
            if (job.skills.isNotEmpty) ...[
              Row(
                children: [
                  Icon(
                    Icons.star_border,
                    color: AppTheme.primaryColor,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Required Skills',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: job.skills.take(6).map((skill) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                        fontSize: 11,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
            ],
            
            // Description - Professional layout
            Row(
              children: [
                Icon(
                  Icons.description_outlined,
                  color: AppTheme.primaryColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'About this role',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Expanded scrollable description area
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    job.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.7,
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.primaryColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

}

 