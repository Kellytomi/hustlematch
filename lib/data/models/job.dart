/// Represents a job opportunity in the HustleMatch application.
/// 
/// This model contains all the essential information about a job posting
/// including company details, requirements, and application tracking data.
/// 
/// Example usage:
/// ```dart
/// final job = Job(
///   id: '123',
///   title: 'Flutter Developer',
///   company: 'Tech Corp',
///   // ... other properties
/// );
/// ```
class Job {
  /// Unique identifier for the job posting
  final String id;
  
  /// Job title or position name
  final String title;
  
  /// Company or organization offering the job
  final String company;
  
  /// Brief description of the job role and responsibilities
  final String description;
  
  /// List of required skills or qualifications
  final List<String> requirements;
  
  /// Job location (can be remote, city name, etc.)
  final String location;
  
  /// Salary range or compensation details
  final String? salary;
  
  /// Employment type (full-time, part-time, contract, etc.)
  final String employmentType;
  
  /// Date when the job was posted
  final DateTime postedDate;
  
  /// Application deadline (null if no deadline)
  final DateTime? applicationDeadline;
  
  /// URL to the original job posting or company website
  final String? jobUrl;
  
  /// Whether the user has applied to this job
  final bool hasApplied;
  
  /// Whether the job is bookmarked by the user
  final bool isBookmarked;

  /// Creates a new [Job] instance.
  /// 
  /// All parameters except [salary], [applicationDeadline], and [jobUrl] are required.
  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.description,
    required this.requirements,
    required this.location,
    required this.employmentType,
    required this.postedDate,
    this.salary,
    this.applicationDeadline,
    this.jobUrl,
    this.hasApplied = false,
    this.isBookmarked = false,
  });

  /// Creates a copy of this job with updated fields.
  /// 
  /// Only non-null parameters will be updated in the copy.
  Job copyWith({
    String? id,
    String? title,
    String? company,
    String? description,
    List<String>? requirements,
    String? location,
    String? salary,
    String? employmentType,
    DateTime? postedDate,
    DateTime? applicationDeadline,
    String? jobUrl,
    bool? hasApplied,
    bool? isBookmarked,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      location: location ?? this.location,
      salary: salary ?? this.salary,
      employmentType: employmentType ?? this.employmentType,
      postedDate: postedDate ?? this.postedDate,
      applicationDeadline: applicationDeadline ?? this.applicationDeadline,
      jobUrl: jobUrl ?? this.jobUrl,
      hasApplied: hasApplied ?? this.hasApplied,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  /// Creates a [Job] instance from a JSON map.
  /// 
  /// Throws [FormatException] if required fields are missing or invalid.
  factory Job.fromJson(Map<String, dynamic> json) {
    try {
      return Job(
        id: json['id'] as String,
        title: json['title'] as String,
        company: json['company'] as String,
        description: json['description'] as String,
        requirements: List<String>.from(json['requirements'] as List),
        location: json['location'] as String,
        employmentType: json['employmentType'] as String,
        postedDate: DateTime.parse(json['postedDate'] as String),
        salary: json['salary'] as String?,
        applicationDeadline: json['applicationDeadline'] != null
            ? DateTime.parse(json['applicationDeadline'] as String)
            : null,
        jobUrl: json['jobUrl'] as String?,
        hasApplied: json['hasApplied'] as bool? ?? false,
        isBookmarked: json['isBookmarked'] as bool? ?? false,
      );
    } catch (e) {
      throw FormatException('Invalid Job JSON: $e');
    }
  }

  /// Converts this [Job] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'description': description,
      'requirements': requirements,
      'location': location,
      'salary': salary,
      'employmentType': employmentType,
      'postedDate': postedDate.toIso8601String(),
      'applicationDeadline': applicationDeadline?.toIso8601String(),
      'jobUrl': jobUrl,
      'hasApplied': hasApplied,
      'isBookmarked': isBookmarked,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Job &&
        other.id == id &&
        other.title == title &&
        other.company == company &&
        other.description == description &&
        other.requirements.length == requirements.length &&
        other.requirements.every((req) => requirements.contains(req)) &&
        other.location == location &&
        other.salary == salary &&
        other.employmentType == employmentType &&
        other.postedDate == postedDate &&
        other.applicationDeadline == applicationDeadline &&
        other.jobUrl == jobUrl &&
        other.hasApplied == hasApplied &&
        other.isBookmarked == isBookmarked;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      company,
      description,
      requirements,
      location,
      salary,
      employmentType,
      postedDate,
      applicationDeadline,
      jobUrl,
      hasApplied,
      isBookmarked,
    );
  }

  @override
  String toString() {
    return 'Job(id: $id, title: $title, company: $company, location: $location)';
  }
} 