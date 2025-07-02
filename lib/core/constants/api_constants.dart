/// API configuration constants for the HustleMatch application.
/// 
/// This file contains all API-related constants including endpoints,
/// timeouts, and configuration values.
class ApiConstants {
  // Private constructor to prevent instantiation
  ApiConstants._();

  /// Base URL for the production API
  static const String baseUrl = 'https://api.hustlematch.com';
  
  /// Base URL for the development API
  static const String devBaseUrl = 'https://dev-api.hustlematch.com';
  
  /// Default request timeout duration
  static const Duration defaultTimeout = Duration(seconds: 30);
  
  /// Upload timeout duration (for file uploads)
  static const Duration uploadTimeout = Duration(minutes: 5);

  // API Endpoints
  /// Authentication endpoints
  static const String loginEndpoint = '/auth/login';
  static const String signupEndpoint = '/auth/signup';
  static const String logoutEndpoint = '/auth/logout';
  static const String refreshTokenEndpoint = '/auth/refresh';
  
  /// User profile endpoints
  static const String userProfileEndpoint = '/user/profile';
  static const String updateProfileEndpoint = '/user/profile';
  static const String uploadAvatarEndpoint = '/user/avatar';
  static const String uploadResumeEndpoint = '/user/resume';
  
  /// Job-related endpoints
  static const String jobsEndpoint = '/jobs';
  static const String jobDetailsEndpoint = '/jobs'; // + /{id}
  static const String searchJobsEndpoint = '/jobs/search';
  static const String bookmarkJobEndpoint = '/jobs'; // + /{id}/bookmark
  static const String applyJobEndpoint = '/jobs'; // + /{id}/apply
  static const String appliedJobsEndpoint = '/jobs/applied';
  static const String bookmarkedJobsEndpoint = '/jobs/bookmarked';
  
  /// Application tracking endpoints
  static const String applicationsEndpoint = '/applications';
  static const String applicationStatusEndpoint = '/applications'; // + /{id}/status

  // API Response Keys
  /// Standard response keys
  static const String dataKey = 'data';
  static const String messageKey = 'message';
  static const String statusKey = 'status';
  static const String errorKey = 'error';
  static const String errorsKey = 'errors';
  
  /// Pagination keys
  static const String pageKey = 'page';
  static const String limitKey = 'limit';
  static const String totalKey = 'total';
  static const String totalPagesKey = 'totalPages';
  static const String hasNextPageKey = 'hasNextPage';
  static const String hasPreviousPageKey = 'hasPreviousPage';

  // HTTP Headers
  /// Content type headers
  static const String contentTypeJson = 'application/json';
  static const String contentTypeFormData = 'multipart/form-data';
  
  /// Authorization header
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
  
  /// Custom headers
  static const String userAgentHeader = 'User-Agent';
  static const String appVersionHeader = 'X-App-Version';
  static const String platformHeader = 'X-Platform';

  // Pagination Defaults
  /// Default page size for API requests
  static const int defaultPageSize = 20;
  
  /// Maximum page size allowed
  static const int maxPageSize = 100;
  
  /// Default page number
  static const int defaultPage = 1;

  // Cache Settings
  /// Cache duration for job listings
  static const Duration jobsCacheDuration = Duration(minutes: 15);
  
  /// Cache duration for user profile
  static const Duration profileCacheDuration = Duration(hours: 1);
  
  /// Cache duration for job details
  static const Duration jobDetailsCacheDuration = Duration(minutes: 30);
} 