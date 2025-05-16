// lib/data/repositories/news_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:news_reader/core/api/api_exception.dart';
import 'package:news_reader/core/network/network_info.dart';
import 'package:news_reader/data/models/article_model.dart';
import 'package:news_reader/data/sources/local/news_local_source.dart';
import 'package:news_reader/data/sources/remote/news_remote_source.dart';
import 'package:news_reader/domain/entities/article.dart';
import 'package:news_reader/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteSource remoteSource;
  final NewsLocalSource localSource;
  final NetworkInfo networkInfo;

  NewsRepositoryImpl({
    required this.remoteSource,
    required this.localSource,
    required this.networkInfo,
  });

  @override
  Future<Either<ApiException, List<Article>>> getArticles({
    String? query,
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final articles = await remoteSource.getArticles(
          query: query,
          category: category,
          page: page,
          pageSize: pageSize,
        );
        
        // Cache articles to local storage
        await localSource.saveArticlesToCache(articles);
        
        return Right(articles);
      } on ApiException catch (e) {
        return Left(e);
      }
    } else {
      // Get from cache if offline
      final cachedArticles = await localSource.getCachedArticles();
      if (cachedArticles.isNotEmpty) {
        return Right(cachedArticles);
      } else {
        return Left(ApiException(message: 'No internet connection'));
      }
    }
  }

  @override
  Future<List<Article>> getSavedArticles() async {
    return await localSource.getSavedArticles();
  }

  @override
  Future<Either<ApiException, bool>> syncArticles() async {
    if (await networkInfo.isConnected) {
      try {
        final unsyncedArticles = await localSource.getUnsyncedArticles();
        if (unsyncedArticles.isEmpty) {
          return const Right(true);
        }
        
        final success = await remoteSource.syncArticles(unsyncedArticles);
        if (success) {
          // Mark articles as synced
          for (var article in unsyncedArticles) {
            await localSource.markArticleAsSynced(article.url);
          }
          return const Right(true);
        } else {
          return Left(ApiException(message: 'Failed to sync articles'));
        }
      } on ApiException catch (e) {
        return Left(e);
      }
    } else {
      return Left(ApiException(message: 'No internet connection'));
    }
  }

  @override
  Future<bool> hasUnSyncedArticles() async {
    final unsyncedArticles = await localSource.getUnsyncedArticles();
    return unsyncedArticles.isNotEmpty;
  }

  @override
  Future<bool> saveArticle(Article article) async {
    if (article is ArticleModel) {
      return await localSource.saveArticle(article);
    } else {
      final articleModel = ArticleModel(
        id: article.id,
        source: article.source,
        author: article.author,
        title: article.title,
        description: article.description,
        url: article.url,
        urlToImage: article.urlToImage,
        publishedDate: article.publishedDate,
        content: article.content,
        isSynced: false,
        lastUpdated: DateTime.now(),
      );
      return await localSource.saveArticle(articleModel);
    }
  }

  @override
  Future<bool> removeArticle(String url) async {
    return await localSource.removeArticle(url);
  }

  @override
  Future<bool> isArticleSaved(String url) async {
    return await localSource.isArticleSaved(url);
  }
}