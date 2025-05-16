// lib/data/sources/remote/news_remote_source.dart
import 'package:news_reader/core/api/api_client.dart';
import 'package:news_reader/core/api/api_exception.dart';
import 'package:news_reader/core/api/endpoints.dart';
import 'package:news_reader/data/models/article_model.dart';
import 'package:news_reader/data/models/response_models.dart';

class NewsRemoteSource {
  final ApiClient _apiClient;

  NewsRemoteSource(this._apiClient);

  Future<List<ArticleModel>> getArticles({
    String? query,
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page,
        'pageSize': pageSize,
      };

      String endpoint;
      
      if (query != null && query.isNotEmpty) {
        endpoint = Endpoints.everything;
        queryParams['q'] = query;
      } else {
        endpoint = Endpoints.topHeadlines;
        queryParams['country'] = 'us';
        
        if (category != null && category.isNotEmpty) {
          queryParams['category'] = category;
        }
      }

      final response = await _apiClient.get(endpoint, queryParameters: queryParams);
      final articlesResponse = NewsResponse.fromJson(response);
      
      return articlesResponse.articles;
    } catch (e) {
      throw ApiException(message: 'Failed to fetch articles: ${e.toString()}');
    }
  }

  // In a real app, this would actually sync with a backend
  Future<bool> syncArticles(List<ArticleModel> articles) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}