import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

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

  @override
  Widget build(BuildContext context) {
    final discoveryState = ref.watch(jobDiscoveryProvider);
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Discover Jobs'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.go('/profile'),
          ),
        ],
      ),
      body: SafeArea(
        child: discoveryState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : discoveryState.jobs.isEmpty
                ? _buildEmptyState()
                : _buildJobCards(discoveryState),
      ),

    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work_outline,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No more jobs for now',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new opportunities',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => ref.read(jobDiscoveryProvider.notifier)._loadJobs(),
            child: const Text('Refresh'),
          ),
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
                            _buildJobCard(state.jobs[state.currentIndex]),
                            
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
                              
                              // Right stamp (APPLY)
                              if (_dragOffset > 0)
                                Positioned(
                                  right: 60,
                                  top: 150,
                                  child: Transform.rotate(
                                    angle: 0.2,
                                    child: Opacity(
                                      opacity: (_dragOffset.abs() / 120).clamp(0.4, 0.95),
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.9),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppTheme.successColor,
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
                                                Icons.favorite,
                                                color: AppTheme.successColor,
                                                size: 28,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'APPLY',
                                                style: TextStyle(
                                                  color: AppTheme.successColor,
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
      height: MediaQuery.of(context).size.height * 0.75,
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
            // Company header - Compact design
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      job.companyLogo,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.company,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        job.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Job details - More compact
            Row(
              children: [
                Expanded(child: _buildCompactDetail(Icons.location_on_outlined, job.location)),
                Expanded(child: _buildCompactDetail(Icons.payments_outlined, job.salary)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildCompactDetail(Icons.access_time_outlined, job.type)),
                Expanded(child: _buildCompactDetail(Icons.trending_up_outlined, job.level)),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Skills tags - Moved above description and made smaller
            if (job.skills.isNotEmpty) ...[
              Text(
                'Skills Required',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: job.skills.take(6).map((skill) => Container(
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
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 16),
            ],
            
            // Description - Now takes up remaining space
            Text(
              'About this role',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            
            // Expanded scrollable description area - Now gets more space
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    job.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Swipe hint at bottom - Smaller
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.swipe_left,
                    color: AppTheme.textSecondary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Swipe to skip or apply',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.swipe_right,
                    color: AppTheme.textSecondary,
                    size: 18,
                  ),
                ],
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


}

 