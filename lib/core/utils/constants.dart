// lib/core/utils/constants.dart
class Constants {
  // General
  static const String appName = 'News Reader';
  
  // News API
  static const int pageSize = 20;
  static const List<String> categories = [
    'general',
    'business',
    'technology',
    'entertainment',
    'health',
    'science',
    'sports',
  ];
  
  // Sync
  static const int syncIntervalMinutes = 15;
}