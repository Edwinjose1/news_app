// lib/core/storage/hive_manager.dart
import 'package:hive/hive.dart';
import 'package:news_reader/data/models/article_model.dart';

class HiveManager {
  Future<Box<ArticleModel>> get articlesBox async {
    return await Hive.openBox<ArticleModel>('articles');
  }

  Future<Box> get settingsBox async {
    return await Hive.openBox('settings');
  }

  Future<List<ArticleModel>> getArticles() async {
    final box = await articlesBox;
    return box.values.toList();
  }

  Future<List<ArticleModel>> getCachedArticles() async {
    final box = await articlesBox;
    return box.values.where((article) => article.isSynced).toList();
  }

  Future<List<ArticleModel>> getUnsyncedArticles() async {
    final box = await articlesBox;
    return box.values.where((article) => !article.isSynced).toList();
  }

  Future<bool> saveArticle(ArticleModel article) async {
    try {
      final box = await articlesBox;
      await box.put(article.url, article);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveArticlesToCache(List<ArticleModel> articles) async {
    try {
      final box = await articlesBox;
      final Map<dynamic, ArticleModel> articlesMap = {
        for (var article in articles) article.url: article
      };
      await box.putAll(articlesMap);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeArticle(String url) async {
    try {
      final box = await articlesBox;
      await box.delete(url);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isArticleSaved(String url) async {
    final box = await articlesBox;
    return box.containsKey(url);
  }

  Future<bool> markArticleAsSynced(String url) async {
    try {
      final box = await articlesBox;
      final article = box.get(url);
      if (article != null) {
        await box.put(url, article.copyWith(isSynced: true));
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> clearCache() async {
    final box = await articlesBox;
    await box.clear();
  }
}