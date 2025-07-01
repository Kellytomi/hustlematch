class AppConfig {
  static const String appName = 'HustleMatch';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'AI-powered job matching for Nigerian professionals';
  
  // API Configuration
  static const String baseUrl = 'https://api.hustlematch.ng';
  static const String openAiApiUrl = 'https://api.openai.com/v1';
  static const String linkedinApiUrl = 'https://api.linkedin.com/v2';
  
  // Feature Flags
  static const bool enableDebugMode = true;
  static const bool enableAnalytics = false;
  static const bool enableCrashlytics = false;
  
  // App Constants
  static const int maxJobCardsPerSession = 20;
  static const int autoApplyDelaySeconds = 2;
  static const int maxApplicationsPerDay = 10;
  
  // Nigerian Market Specific
  static const String defaultCurrency = 'NGN';
  static const String defaultCountry = 'Nigeria';
  static const List<String> supportedStates = [
    'Lagos',
    'Abuja',
    'Port Harcourt',
    'Kano',
    'Ibadan',
    'Enugu',
    'Kaduna',
  ];
} 