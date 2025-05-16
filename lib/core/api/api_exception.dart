// lib/core/api/api_exception.dart
class ApiException implements Exception {
  final int? code;
  final String message;

  ApiException({this.code, required this.message});

  @override
  String toString() => 'ApiException: $message (code: $code)';
}