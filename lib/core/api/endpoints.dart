// lib/core/api/endpoints.dart
class Endpoints {
  // Base URL for News API
  static const String baseUrl = 'https://newsapi.org/v2';
  
  // Endpoints
  static const String topHeadlines = '/top-headlines';
  static const String everything = '/everything';
  
  // API Key - would be stored securely in a real app
  static const String apiKey = '06951bef4bf94988900b37f8247be72b ';
  
  // For testing purposes - not using a real API key
  static const String dummyApiKey = 'dummy_api_key';
}