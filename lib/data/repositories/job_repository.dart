import '../models/job.dart';

/// Repository interface for job-related data operations.
/// 
/// This abstract class defines the contract for job data operations,
/// allowing for different implementations (e.g., API, local database, mock).
/// 
/// Example usage:
/// ```dart
/// final repository = ApiJobRepository();
/// final jobs = await repository.getJobs();
/// ```
abstract class JobRepository {
  /// Fetches a list of available job opportunities.
  /// 
  /// Returns a list of [Job] objects representing current job openings.
  /// Throws [Exception] if the operation fails.
  /// 
  /// [page] - Optional page number for pagination (default: 1)
  /// [limit] - Optional number of jobs per page (default: 20)
  /// [searchQuery] - Optional search query to filter jobs
  /// [location] - Optional location filter
  /// [jobType] - Optional employment type filter
  Future<List<Job>> getJobs({
    int page = 1,
    int limit = 20,
    String? searchQuery,
    String? location,
    String? jobType,
  });

  /// Fetches a specific job by its ID.
  /// 
  /// Returns a [Job] object if found, null otherwise.
  /// Throws [Exception] if the operation fails.
  Future<Job?> getJobById(String id);

  /// Searches for jobs based on the provided criteria.
  /// 
  /// Returns a list of [Job] objects matching the search criteria.
  /// Throws [Exception] if the operation fails.
  Future<List<Job>> searchJobs({
    required String query,
    String? location,
    String? jobType,
    String? salaryRange,
    List<String>? skills,
  });

  /// Bookmarks a job for the user.
  /// 
  /// Returns true if successful, false otherwise.
  /// Throws [Exception] if the operation fails.
  Future<bool> bookmarkJob(String jobId);

  /// Removes a job from user's bookmarks.
  /// 
  /// Returns true if successful, false otherwise.
  /// Throws [Exception] if the operation fails.
  Future<bool> unbookmarkJob(String jobId);

  /// Gets all bookmarked jobs for the user.
  /// 
  /// Returns a list of bookmarked [Job] objects.
  /// Throws [Exception] if the operation fails.
  Future<List<Job>> getBookmarkedJobs();

  /// Applies to a specific job.
  /// 
  /// Returns true if application was successful, false otherwise.
  /// Throws [Exception] if the operation fails.
  Future<bool> applyToJob(String jobId, {String? coverLetter});

  /// Gets jobs the user has applied to.
  /// 
  /// Returns a list of [Job] objects the user has applied to.
  /// Throws [Exception] if the operation fails.
  Future<List<Job>> getAppliedJobs();
} 