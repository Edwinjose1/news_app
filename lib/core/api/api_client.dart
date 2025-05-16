// lib/core/api/api_client.dart
import 'package:dio/dio.dart';
import 'package:news_reader/core/api/api_exception.dart';
import 'package:news_reader/core/api/endpoints.dart';

class ApiClient {
  final Dio _dio;
  
  ApiClient(this._dio) {
    _dio.options.baseUrl = Endpoints.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Api-Key': Endpoints.apiKey,
    };
    
    // Add interceptors for logging, etc.
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }
  
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Map<String, dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      
      return response.data;
    } on DioException catch (e) {
   
      throw _handleError(e);
    }
  }
  
  ApiException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(message: 'Request timed out');
      case DioExceptionType.badResponse:
        return ApiException(
          code: error.response?.statusCode,
          message: _getErrorMessage(error.response),
        );
      case DioExceptionType.cancel:
        return ApiException(message: 'Request cancelled');
      case DioExceptionType.connectionError:
        return ApiException(message: 'No internet connection');
      default:
        return ApiException(message: 'Something went wrong');
    }
  }
  
  String _getErrorMessage(Response? response) {
    if (response?.data != null && response?.data is Map) {
      final data = response?.data as Map;
      if (data.containsKey('message')) {
        return data['message'];
      }
    }
    
    switch (response?.statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 500:
        return 'Internal server error';
      default:
        return 'Something went wrong';
    }
  }
}