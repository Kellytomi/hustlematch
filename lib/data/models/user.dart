/// Represents a user in the HustleMatch application.
/// 
/// This model contains all user information including profile details,
/// preferences, and application tracking data.
/// 
/// Example usage:
/// ```dart
/// final user = User(
///   id: '123',
///   email: 'john@example.com',
///   firstName: 'John',
///   lastName: 'Doe',
/// );
/// ```
class User {
  /// Unique identifier for the user
  final String id;
  
  /// User's email address (used for authentication)
  final String email;
  
  /// User's first name
  final String firstName;
  
  /// User's last name
  final String lastName;
  
  /// User's phone number (optional)
  final String? phoneNumber;
  
  /// User's current location or preferred work location
  final String? location;
  
  /// User's professional title or desired role
  final String? jobTitle;
  
  /// User's professional bio or summary
  final String? bio;
  
  /// List of user's skills
  final List<String> skills;
  
  /// List of user's work experiences
  final List<String> experience;
  
  /// User's education background
  final List<String> education;
  
  /// User's professional portfolio or website URL
  final String? portfolioUrl;
  
  /// User's LinkedIn profile URL
  final String? linkedInUrl;
  
  /// User's resume/CV file URL or path
  final String? resumeUrl;
  
  /// User's profile image URL
  final String? profileImageUrl;
  
  /// Whether the user has completed profile setup
  final bool isProfileComplete;
  
  /// User's preferred job types (full-time, part-time, contract, etc.)
  final List<String> preferredJobTypes;
  
  /// User's preferred salary range
  final String? preferredSalaryRange;
  
  /// Whether the user is currently looking for opportunities
  final bool isActivelyLooking;
  
  /// Date when the user account was created
  final DateTime createdAt;
  
  /// Date when the user profile was last updated
  final DateTime? updatedAt;

  /// Creates a new [User] instance.
  /// 
  /// Required parameters are [id], [email], [firstName], and [lastName].
  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    this.phoneNumber,
    this.location,
    this.jobTitle,
    this.bio,
    this.skills = const [],
    this.experience = const [],
    this.education = const [],
    this.portfolioUrl,
    this.linkedInUrl,
    this.resumeUrl,
    this.profileImageUrl,
    this.isProfileComplete = false,
    this.preferredJobTypes = const [],
    this.preferredSalaryRange,
    this.isActivelyLooking = true,
    this.updatedAt,
  });

  /// Returns the user's full name.
  String get fullName => '$firstName $lastName';

  /// Returns the user's initials for avatars.
  String get initials {
    final firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }

  /// Creates a copy of this user with updated fields.
  /// 
  /// Only non-null parameters will be updated in the copy.
  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? location,
    String? jobTitle,
    String? bio,
    List<String>? skills,
    List<String>? experience,
    List<String>? education,
    String? portfolioUrl,
    String? linkedInUrl,
    String? resumeUrl,
    String? profileImageUrl,
    bool? isProfileComplete,
    List<String>? preferredJobTypes,
    String? preferredSalaryRange,
    bool? isActivelyLooking,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      jobTitle: jobTitle ?? this.jobTitle,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      portfolioUrl: portfolioUrl ?? this.portfolioUrl,
      linkedInUrl: linkedInUrl ?? this.linkedInUrl,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      preferredJobTypes: preferredJobTypes ?? this.preferredJobTypes,
      preferredSalaryRange: preferredSalaryRange ?? this.preferredSalaryRange,
      isActivelyLooking: isActivelyLooking ?? this.isActivelyLooking,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Creates a [User] instance from a JSON map.
  /// 
  /// Throws [FormatException] if required fields are missing or invalid.
  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        id: json['id'] as String,
        email: json['email'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        phoneNumber: json['phoneNumber'] as String?,
        location: json['location'] as String?,
        jobTitle: json['jobTitle'] as String?,
        bio: json['bio'] as String?,
        skills: List<String>.from(json['skills'] as List? ?? []),
        experience: List<String>.from(json['experience'] as List? ?? []),
        education: List<String>.from(json['education'] as List? ?? []),
        portfolioUrl: json['portfolioUrl'] as String?,
        linkedInUrl: json['linkedInUrl'] as String?,
        resumeUrl: json['resumeUrl'] as String?,
        profileImageUrl: json['profileImageUrl'] as String?,
        isProfileComplete: json['isProfileComplete'] as bool? ?? false,
        preferredJobTypes: List<String>.from(json['preferredJobTypes'] as List? ?? []),
        preferredSalaryRange: json['preferredSalaryRange'] as String?,
        isActivelyLooking: json['isActivelyLooking'] as bool? ?? true,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : null,
      );
    } catch (e) {
      throw FormatException('Invalid User JSON: $e');
    }
  }

  /// Converts this [User] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'location': location,
      'jobTitle': jobTitle,
      'bio': bio,
      'skills': skills,
      'experience': experience,
      'education': education,
      'portfolioUrl': portfolioUrl,
      'linkedInUrl': linkedInUrl,
      'resumeUrl': resumeUrl,
      'profileImageUrl': profileImageUrl,
      'isProfileComplete': isProfileComplete,
      'preferredJobTypes': preferredJobTypes,
      'preferredSalaryRange': preferredSalaryRange,
      'isActivelyLooking': isActivelyLooking,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.phoneNumber == phoneNumber &&
        other.location == location &&
        other.jobTitle == jobTitle &&
        other.bio == bio &&
        other.skills.length == skills.length &&
        other.skills.every((skill) => skills.contains(skill)) &&
        other.experience.length == experience.length &&
        other.experience.every((exp) => experience.contains(exp)) &&
        other.education.length == education.length &&
        other.education.every((edu) => education.contains(edu)) &&
        other.portfolioUrl == portfolioUrl &&
        other.linkedInUrl == linkedInUrl &&
        other.resumeUrl == resumeUrl &&
        other.profileImageUrl == profileImageUrl &&
        other.isProfileComplete == isProfileComplete &&
        other.preferredJobTypes.length == preferredJobTypes.length &&
        other.preferredJobTypes.every((type) => preferredJobTypes.contains(type)) &&
        other.preferredSalaryRange == preferredSalaryRange &&
        other.isActivelyLooking == isActivelyLooking &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      email,
      firstName,
      lastName,
      phoneNumber,
      location,
      jobTitle,
      bio,
      Object.hashAll(skills),
      Object.hashAll(experience),
      Object.hashAll(education),
      portfolioUrl,
      linkedInUrl,
      resumeUrl,
      profileImageUrl,
      isProfileComplete,
      Object.hashAll(preferredJobTypes),
      preferredSalaryRange,
      isActivelyLooking,
      Object.hash(createdAt, updatedAt),
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, fullName: $fullName)';
  }
} 