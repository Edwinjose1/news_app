// lib/data/sources/local/news_local_source.dart
import 'package:news_reader/core/storage/hive_manager.dart';
import 'package:news_reader/data/models/article_model.dart';

class NewsLocalSource {
  final HiveManager _hiveManager;

  NewsLocalSource(this._hiveManager);

  Future<List<ArticleModel>> getCachedArticles() async {
    return await _hiveManager.getCachedArticles();
  }

  Future<List<ArticleModel>> getSavedArticles() async {
    return await _hiveManager.getArticles();
  }

  Future<List<ArticleModel>> getUnsyncedArticles() async {
    return await _hiveManager.getUnsyncedArticles();
  }

  Future<bool> saveArticle(ArticleModel article) async {
    return await _hiveManager.saveArticle(article);
  }

  Future<bool> saveArticlesToCache(List<ArticleModel> articles) async {
    return await _hiveManager.saveArticlesToCache(articles);
  }

  Future<bool> removeArticle(String url) async {
    return await _hiveManager.removeArticle(url);
  }

  Future<bool> isArticleSaved(String url) async {
    return await _hiveManager.isArticleSaved(url);
  }

  Future<bool> markArticleAsSynced(String url) async {
    return await _hiveManager.markArticleAsSynced(url);
  }

  Future<void> clearCache() async {
    await _hiveManager.clearCache();
  }
}