import 'package:equatable/equatable.dart';
import 'user.dart'; // For Location, JobType, JobLevel, SalaryRange

class Job extends Equatable {
  final String id;
  final String title;
  final Company company;
  final String description;
  final List<String> requirements;
  final List<String> responsibilities;
  final Location location;
  final SalaryRange? salary;
  final JobType type;
  final JobLevel level;
  final DateTime postedDate;
  final DateTime? deadline;
  final String source;
  final String externalId;
  final String applyUrl;
  final bool isActive;
  final List<String> benefits;
  final List<String> tags;

  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.description,
    required this.requirements,
    required this.responsibilities,
    required this.location,
    this.salary,
    required this.type,
    required this.level,
    required this.postedDate,
    this.deadline,
    required this.source,
    required this.externalId,
    required this.applyUrl,
    required this.isActive,
    required this.benefits,
    required this.tags,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        company,
        description,
        requirements,
        responsibilities,
        location,
        salary,
        type,
        level,
        postedDate,
        deadline,
        source,
        externalId,
        applyUrl,
        isActive,
        benefits,
        tags
      ];
}

class Company extends Equatable {
  final String id;
  final String name;
  final String? logo;
  final String? website;
  final String? description;
  final String industry;
  final CompanySize size;
  final double? rating;
  final int? employeeCount;

  const Company({
    required this.id,
    required this.name,
    this.logo,
    this.website,
    this.description,
    required this.industry,
    required this.size,
    this.rating,
    this.employeeCount,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        logo,
        website,
        description,
        industry,
        size,
        rating,
        employeeCount
      ];
}

enum CompanySize { startup, small, medium, large, enterprise }

class JobMatch extends Equatable {
  final String id;
  final String userId;
  final String jobId;
  final Job job;
  final MatchScore score;
  final MatchAnalysis analysis;
  final DateTime createdAt;
  final MatchStatus status;

  const JobMatch({
    required this.id,
    required this.userId,
    required this.jobId,
    required this.job,
    required this.score,
    required this.analysis,
    required this.createdAt,
    required this.status,
  });

  @override
  List<Object> get props => [id, userId, jobId, job, score, analysis, createdAt, status];
}

class MatchScore extends Equatable {
  final double overall; // 0-100
  final double skillsMatch;
  final double experienceMatch;
  final double locationMatch;
  final double salaryMatch;
  final double cultureMatch;

  const MatchScore({
    required this.overall,
    required this.skillsMatch,
    required this.experienceMatch,
    required this.locationMatch,
    required this.salaryMatch,
    required this.cultureMatch,
  });

  @override
  List<Object> get props => [
        overall,
        skillsMatch,
        experienceMatch,
        locationMatch,
        salaryMatch,
        cultureMatch
      ];
}

class MatchAnalysis extends Equatable {
  final String reasoning;
  final List<String> strengths;
  final List<String> gaps;
  final List<String> recommendations;
  final Map<String, double> skillBreakdown;

  const MatchAnalysis({
    required this.reasoning,
    required this.strengths,
    required this.gaps,
    required this.recommendations,
    required this.skillBreakdown,
  });

  @override
  List<Object> get props => [reasoning, strengths, gaps, recommendations, skillBreakdown];
}

enum MatchStatus { pending, liked, skipped, applied, saved }

class JobApplication extends Equatable {
  final String id;
  final String userId;
  final String jobId;
  final Job job;
  final ApplicationStatus status;
  final DateTime appliedAt;
  final String? coverLetter;
  final String? customResume;
  final List<ApplicationEvent> timeline;
  final String? rejectionReason;
  final DateTime? lastUpdated;

  const JobApplication({
    required this.id,
    required this.userId,
    required this.jobId,
    required this.job,
    required this.status,
    required this.appliedAt,
    this.coverLetter,
    this.customResume,
    required this.timeline,
    this.rejectionReason,
    this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        jobId,
        job,
        status,
        appliedAt,
        coverLetter,
        customResume,
        timeline,
        rejectionReason,
        lastUpdated
      ];
}

class ApplicationEvent extends Equatable {
  final String id;
  final ApplicationEventType type;
  final String title;
  final String? description;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  const ApplicationEvent({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    required this.timestamp,
    this.metadata,
  });

  @override
  List<Object?> get props => [id, type, title, description, timestamp, metadata];
}

enum ApplicationStatus {
  pending,
  submitted,
  reviewing,
  phoneScreen,
  technicalInterview,
  finalInterview,
  offered,
  accepted,
  rejected,
  withdrawn
}

enum ApplicationEventType {
  applied,
  viewed,
  phoneScreen,
  interview,
  offer,
  rejection,
  acceptance,
  withdrawal
} 