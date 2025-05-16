// lib/domain/usecases/sync_articles_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:news_reader/core/api/api_exception.dart';
import 'package:news_reader/domain/repositories/news_repository.dart';

class SyncArticlesUseCase {
  final NewsRepository _repository;

  SyncArticlesUseCase(this._repository);

  Future<Either<ApiException, bool>> execute() async {
    return await _repository.syncArticles();
  }

  Future<bool> hasUnSyncedArticles() async {
    return await _repository.hasUnSyncedArticles();
  }
}