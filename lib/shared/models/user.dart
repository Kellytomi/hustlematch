import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final UserProfile profile;
  final UserSettings settings;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.profile,
    required this.settings,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [id, email, profile, settings, createdAt, updatedAt];

  User copyWith({
    String? id,
    String? email,
    UserProfile? profile,
    UserSettings? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      profile: profile ?? this.profile,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserProfile extends Equatable {
  final String firstName;
  final String lastName;
  final String? profilePhoto;
  final String? linkedinUrl;
  final String? resumeUrl;
  final List<String> skills;
  final List<Experience> experience;
  final List<Education> education;
  final JobPreferences preferences;
  final Location? location;

  const UserProfile({
    required this.firstName,
    required this.lastName,
    this.profilePhoto,
    this.linkedinUrl,
    this.resumeUrl,
    required this.skills,
    required this.experience,
    required this.education,
    required this.preferences,
    this.location,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        profilePhoto,
        linkedinUrl,
        resumeUrl,
        skills,
        experience,
        education,
        preferences,
        location
      ];
}

class Experience extends Equatable {
  final String id;
  final String company;
  final String position;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrentRole;
  final List<String> achievements;

  const Experience({
    required this.id,
    required this.company,
    required this.position,
    required this.description,
    required this.startDate,
    this.endDate,
    required this.isCurrentRole,
    required this.achievements,
  });

  @override
  List<Object?> get props => [
        id,
        company,
        position,
        description,
        startDate,
        endDate,
        isCurrentRole,
        achievements
      ];
}

class Education extends Equatable {
  final String id;
  final String institution;
  final String degree;
  final String field;
  final DateTime startDate;
  final DateTime? endDate;
  final double? gpa;

  const Education({
    required this.id,
    required this.institution,
    required this.degree,
    required this.field,
    required this.startDate,
    this.endDate,
    this.gpa,
  });

  @override
  List<Object?> get props => [id, institution, degree, field, startDate, endDate, gpa];
}

class JobPreferences extends Equatable {
  final List<String> preferredRoles;
  final List<String> preferredIndustries;
  final List<String> preferredCompanies;
  final SalaryRange salaryRange;
  final List<JobType> jobTypes;
  final List<JobLevel> jobLevels;
  final LocationPreference locationPreference;
  final List<String> dealBreakers;
  final List<String> mustHaves;
  final bool openToRemote;
  final bool openToRelocate;
  final int maxCommuteTime; // in minutes

  const JobPreferences({
    required this.preferredRoles,
    required this.preferredIndustries,
    required this.preferredCompanies,
    required this.salaryRange,
    required this.jobTypes,
    required this.jobLevels,
    required this.locationPreference,
    required this.dealBreakers,
    required this.mustHaves,
    required this.openToRemote,
    required this.openToRelocate,
    required this.maxCommuteTime,
  });

  @override
  List<Object> get props => [
        preferredRoles,
        preferredIndustries,
        preferredCompanies,
        salaryRange,
        jobTypes,
        jobLevels,
        locationPreference,
        dealBreakers,
        mustHaves,
        openToRemote,
        openToRelocate,
        maxCommuteTime
      ];
}

class LocationPreference extends Equatable {
  final List<Location> preferredLocations;
  final double maxDistance; // in kilometers
  final bool remoteOnly;
  final bool hybridAcceptable;

  const LocationPreference({
    required this.preferredLocations,
    required this.maxDistance,
    required this.remoteOnly,
    required this.hybridAcceptable,
  });

  @override
  List<Object> get props => [preferredLocations, maxDistance, remoteOnly, hybridAcceptable];
}

class Location extends Equatable {
  final String city;
  final String state;
  final String country;
  final String? zipCode;
  final double? latitude;
  final double? longitude;

  const Location({
    required this.city,
    required this.state,
    required this.country,
    this.zipCode,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [city, state, country, zipCode, latitude, longitude];
}

class SalaryRange extends Equatable {
  final double? min;
  final double? max;
  final SalaryCurrency currency;
  final SalaryPeriod period;

  const SalaryRange({
    this.min,
    this.max,
    required this.currency,
    required this.period,
  });

  @override
  List<Object?> get props => [min, max, currency, period];
}

enum JobType { fullTime, partTime, contract, freelance, internship, remote }

enum JobLevel { internship, entryLevel, midLevel, seniorLevel, executive }

enum SalaryCurrency { usd, eur, gbp, ngn, cad, aud }

enum SalaryPeriod { hourly, monthly, yearly }

class UserSettings extends Equatable {
  final bool darkMode;
  final bool pushNotifications;
  final bool emailNotifications;
  final NotificationSettings notifications;
  final PrivacySettings privacy;
  final String language;
  final String timezone;

  const UserSettings({
    required this.darkMode,
    required this.pushNotifications,
    required this.emailNotifications,
    required this.notifications,
    required this.privacy,
    required this.language,
    required this.timezone,
  });

  @override
  List<Object> get props => [
        darkMode,
        pushNotifications,
        emailNotifications,
        notifications,
        privacy,
        language,
        timezone
      ];
}

class NotificationSettings extends Equatable {
  final bool newMatches;
  final bool applicationUpdates;
  final bool interviews;
  final bool recommendations;
  final String quietHoursStart;
  final String quietHoursEnd;

  const NotificationSettings({
    required this.newMatches,
    required this.applicationUpdates,
    required this.interviews,
    required this.recommendations,
    required this.quietHoursStart,
    required this.quietHoursEnd,
  });

  @override
  List<Object> get props => [
        newMatches,
        applicationUpdates,
        interviews,
        recommendations,
        quietHoursStart,
        quietHoursEnd
      ];
}

class PrivacySettings extends Equatable {
  final bool profileVisible;
  final bool showSalaryExpectations;
  final bool allowRecruiterContact;
  final bool shareWithPartners;

  const PrivacySettings({
    required this.profileVisible,
    required this.showSalaryExpectations,
    required this.allowRecruiterContact,
    required this.shareWithPartners,
  });

  @override
  List<Object> get props => [
        profileVisible,
        showSalaryExpectations,
        allowRecruiterContact,
        shareWithPartners
      ];
} 