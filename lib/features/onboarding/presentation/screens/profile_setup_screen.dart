import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

// Simple data classes for MVP
class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String location;
  final List<String> skills;
  final String? resumeFileName;
  final bool hasUploadedResume;

  const UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.location,
    required this.skills,
    this.resumeFileName,
    required this.hasUploadedResume,
  });

  UserProfile copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? location,
    List<String>? skills,
    String? resumeFileName,
    bool? hasUploadedResume,
  }) {
    return UserProfile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      skills: skills ?? this.skills,
      resumeFileName: resumeFileName ?? this.resumeFileName,
      hasUploadedResume: hasUploadedResume ?? this.hasUploadedResume,
    );
  }
}

// State management
final profileSetupProvider = StateNotifierProvider<ProfileSetupNotifier, UserProfile>((ref) {
  return ProfileSetupNotifier();
});

class ProfileSetupNotifier extends StateNotifier<UserProfile> {
  ProfileSetupNotifier() : super(const UserProfile(
    firstName: '',
    lastName: '',
    email: '',
    phone: '',
    location: '',
    skills: [],
    hasUploadedResume: false,
  ));

  void updateProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? location,
  }) {
    state = state.copyWith(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      location: location,
    );
  }

  void addSkill(String skill) {
    if (!state.skills.contains(skill) && skill.isNotEmpty) {
      state = state.copyWith(skills: [...state.skills, skill]);
    }
  }

  void removeSkill(String skill) {
    state = state.copyWith(
      skills: state.skills.where((s) => s != skill).toList(),
    );
  }

  void simulateResumeUpload(String fileName) {
    // Simulate AI extracting skills from CV
    final extractedSkills = [
      'Flutter',
      'Dart',
      'Mobile Development',
      'REST APIs',
      'Git',
      'Firebase',
      'State Management',
      'UI/UX Design',
    ];
    
    state = state.copyWith(
      resumeFileName: fileName,
      hasUploadedResume: true,
      skills: [...state.skills, ...extractedSkills].toSet().toList(),
    );
  }
}

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _skillController = TextEditingController();
  
  int _currentStep = 0;
  bool _isUploading = false;

  final List<String> _nigeriaCities = [
    'Lagos',
    'Abuja',
    'Port Harcourt',
    'Kano',
    'Ibadan',
    'Benin City',
    'Kaduna',
    'Enugu',
    'Jos',
    'Warri',
  ];

  @override
  void initState() {
    super.initState();
    // Add listeners to update validation in real-time
    _firstNameController.addListener(() => setState(() {}));
    _lastNameController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _phoneController.addListener(() => setState(() {}));
    _locationController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileSetupProvider);
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Setup Your Profile'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Progress indicator
              _buildProgressIndicator(),
              const SizedBox(height: 32),
              
              // Form content
              Expanded(
                child: Form(
                  key: _formKey,
                  child: _buildCurrentStep(profile),
                ),
              ),
              
              // Navigation buttons
              _buildNavigationButtons(profile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: List.generate(4, (index) {
        final isActive = index <= _currentStep;
        final isCompleted = index < _currentStep;
        
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? AppTheme.primaryColor : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(3),
            ),
            child: isCompleted
                ? Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  )
                : null,
          ),
        );
      }),
    );
  }

  Widget _buildCurrentStep(UserProfile profile) {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildContactInfoStep();
      case 2:
        return _buildResumeUploadStep(profile);
      case 3:
        return _buildSkillsStep(profile);
      default:
        return _buildPersonalInfoStep();
    }
  }

  Widget _buildPersonalInfoStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Let\'s get to know you',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tell us your basic information to get started',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 40),
          
          // First Name
          TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              labelText: 'First Name',
              hintText: 'Enter your first name',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          
          // Last Name
          TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              labelText: 'Last Name',
              hintText: 'Enter your last name',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'How can employers reach you?',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 40),
          
          // Email
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email Address',
              hintText: 'your.email@example.com',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          
          // Phone
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              hintText: '+234 xxx xxx xxxx',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          
          // Location
          DropdownButtonFormField<String>(
            value: _locationController.text.isNotEmpty ? _locationController.text : null,
            decoration: const InputDecoration(
              labelText: 'Location',
              hintText: 'Select your city',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
            items: _nigeriaCities.map((city) {
              return DropdownMenuItem<String>(
                value: city,
                child: Text(city),
              );
            }).toList(),
            onChanged: (value) {
              _locationController.text = value ?? '';
              setState(() {}); // Trigger validation update
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your location';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResumeUploadStep(UserProfile profile) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Your Resume',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll analyze your CV to extract skills and experience',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 40),
          
          // Upload area
          GestureDetector(
            onTap: _simulateFileUpload,
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: profile.hasUploadedResume 
                    ? AppTheme.successColor.withValues(alpha: 0.1)
                    : AppTheme.primaryColor.withValues(alpha: 0.05),
                border: Border.all(
                  color: profile.hasUploadedResume 
                      ? AppTheme.successColor
                      : AppTheme.primaryColor.withValues(alpha: 0.3),
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isUploading)
                    const CircularProgressIndicator()
                  else if (profile.hasUploadedResume)
                    const Icon(
                      Icons.check_circle,
                      size: 48,
                      color: AppTheme.successColor,
                    )
                  else
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 48,
                      color: AppTheme.primaryColor,
                    ),
                  
                  const SizedBox(height: 16),
                  
                  Text(
                    profile.hasUploadedResume 
                        ? 'Resume Uploaded Successfully!'
                        : 'Tap to upload your resume',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: profile.hasUploadedResume 
                          ? AppTheme.successColor
                          : AppTheme.primaryColor,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  if (profile.hasUploadedResume && profile.resumeFileName != null)
                    Text(
                      profile.resumeFileName!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    )
                  else
                    Text(
                      'PDF, DOC, or DOCX files accepted',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          if (profile.hasUploadedResume) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Great! We\'ve extracted ${profile.skills.length} skills from your resume. You can review and edit them in the next step.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSkillsStep(UserProfile profile) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Skills',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Review and add to your skills. These help us find the perfect job matches.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 40),
          
          // Add skill field
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _skillController,
                  decoration: const InputDecoration(
                    labelText: 'Add a skill',
                    hintText: 'e.g., Python, Project Management',
                    prefixIcon: Icon(Icons.add),
                  ),
                  onFieldSubmitted: (value) {
                    _addSkill(value);
                  },
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => _addSkill(_skillController.text),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: const CircleBorder(),
                ),
                child: const Icon(Icons.add),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Skills display
          if (profile.skills.isNotEmpty) ...[
            Text(
              'Your Skills (${profile.skills.length})',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile.skills.map((skill) => Chip(
                label: Text(skill),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => _removeSkill(skill),
                backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                side: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
              )).toList(),
            ),
          ] else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No skills added yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your skills to get better job matches',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _addSkill(String skill) {
    if (skill.isNotEmpty) {
      ref.read(profileSetupProvider.notifier).addSkill(skill.trim());
      _skillController.clear();
      // Trigger validation update for navigation buttons
      setState(() {});
    }
  }

  void _removeSkill(String skill) {
    ref.read(profileSetupProvider.notifier).removeSkill(skill);
    // Trigger validation update for navigation buttons
    setState(() {});
  }

  void _simulateFileUpload() async {
    if (_isUploading) return;
    
    setState(() {
      _isUploading = true;
    });
    
    // Simulate upload delay
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isUploading = false;
    });
    
    // Simulate successful upload
    ref.read(profileSetupProvider.notifier).simulateResumeUpload('John_Doe_Resume.pdf');
    
    // Trigger validation update for navigation buttons
    setState(() {});
  }

  Widget _buildNavigationButtons(UserProfile profile) {
    final canProceed = _canProceedToNextStep(profile);
    
    return Column(
      children: [
        // Skip button
        TextButton(
          onPressed: _skipOnboarding,
          child: Text(
            'Skip profile setup',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.underline,
              decorationColor: Colors.grey.shade600,
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Main navigation buttons
        Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _currentStep--;
                    });
                  },
                  child: const Text('Back'),
                ),
              ),
            
            if (_currentStep > 0) const SizedBox(width: 16),
            
            Expanded(
              flex: _currentStep > 0 ? 1 : 2,
              child: ElevatedButton(
                onPressed: canProceed ? _handleNext : null,
                child: Text(_currentStep == 3 ? 'Complete Setup' : 'Next'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool _canProceedToNextStep(UserProfile profile) {
    switch (_currentStep) {
      case 0:
        return _firstNameController.text.isNotEmpty && 
               _lastNameController.text.isNotEmpty;
      case 1:
        return _emailController.text.isNotEmpty && 
               _phoneController.text.isNotEmpty && 
               _locationController.text.isNotEmpty;
      case 2:
        return profile.hasUploadedResume;
      case 3:
        return profile.skills.isNotEmpty;
      default:
        return false;
    }
  }

  void _handleNext() {
    if (_currentStep < 3) {
      // Validate current step
      if (_formKey.currentState?.validate() ?? false) {
        // Update profile with current step data
        _updateProfileData();
        
        setState(() {
          _currentStep++;
        });
      }
    } else {
      // Complete setup
      _updateProfileData();
      _completeSetup();
    }
  }

  void _updateProfileData() {
    ref.read(profileSetupProvider.notifier).updateProfile(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      location: _locationController.text,
    );
  }

  void _completeSetup() {
    // Navigate to main app
    context.go('/discovery');
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Profile setup complete! Start discovering jobs now.'),
          ],
        ),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _skipOnboarding() {
    // Navigate directly to main app without completing profile
    context.go('/discovery');
    
    // Show skip message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.skip_next, color: Colors.white),
            SizedBox(width: 8),
            Text('Profile setup skipped. You can complete it later in settings.'),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
} 