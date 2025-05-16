// lib/presentation/providers/articles_provider.dart
import 'package:flutter/foundation.dart';
import 'package:news_reader/domain/entities/article.dart';
import 'package:news_reader/domain/usecases/get_articles_usecase.dart';

enum ArticlesStatus { initial, loading, success, error }

class ArticlesProvider extends ChangeNotifier {
  final GetArticlesUseCase _getArticlesUseCase;
  
  ArticlesStatus _status = ArticlesStatus.initial;
  List<Article> _articles = [];
  String _errorMessage = '';
  bool _hasMore = true;
  int _currentPage = 1;
  String? _currentQuery;
  String? _currentCategory;
  
  ArticlesProvider(this._getArticlesUseCase);
  
  ArticlesStatus get status => _status;
  List<Article> get articles => _articles;
  String get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  
  Future<void> getArticles({
    String? query,
    String? category,
    bool refresh = false,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _articles = [];
    }
    
    if (_status == ArticlesStatus.loading || (!_hasMore && !refresh)) {
      return;
    }
    
    _currentQuery = query;
    _currentCategory = category;
    
    _status = ArticlesStatus.loading;
    if (_currentPage == 1) notifyListeners();
    
    final result = await _getArticlesUseCase.execute(
      query: _currentQuery,
      category: _currentCategory,
      page: _currentPage,
    );
    
    result.fold(
      (failure) {
        _status = ArticlesStatus.error;
        _errorMessage = failure.message;
      },
      (articles) {
        _status = ArticlesStatus.success;
        if (articles.isEmpty) {
          _hasMore = false;
        } else {
          if (_currentPage == 1) {
            _articles = articles;
          } else {
            _articles.addAll(articles);
          }
          _currentPage++;
        }
      },
    );
    
    notifyListeners();
  }
  
  Future<void> loadMore() async {
    if (_hasMore && _status != ArticlesStatus.loading) {
      await getArticles(
        query: _currentQuery,
        category: _currentCategory,
      );
    }
  }
  
  Future<void> refreshArticles() async {
    await getArticles(
      query: _currentQuery,
      category: _currentCategory,
      refresh: true,
    );
  }
  
  Future<void> searchArticles(String query) async {
    await getArticles(
      query: query,
      category: null,
      refresh: true,
    );
  }
  
  Future<void> filterByCategory(String category) async {
    await getArticles(
      query: null,
      category: category,
      refresh: true,
    );
  }
}