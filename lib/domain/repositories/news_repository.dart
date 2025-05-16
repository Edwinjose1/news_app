// lib/domain/repositories/news_repository.dart
import 'package:dartz/dartz.dart';
import 'package:news_reader/core/api/api_exception.dart';
import 'package:news_reader/domain/entities/article.dart';

abstract class NewsRepository {
  /// Get articles - from network if online, from local storage if offline
  Future<Either<ApiException, List<Article>>> getArticles({
    String? query,
    String? category,
    int page = 1,
    int pageSize = 20,
  });
  
  /// Get saved articles from local storage
  Future<List<Article>> getSavedArticles();
  
  /// Sync articles with remote server
  Future<Either<ApiException, bool>> syncArticles();
  
  /// Check if articles need syncing
  Future<bool> hasUnSyncedArticles();
  
  /// Save article to favorites
  Future<bool> saveArticle(Article article);
  
  /// Remove article from favorites
  Future<bool> removeArticle(String url);
  
  /// Check if article is saved
  Future<bool> isArticleSaved(String url);
}