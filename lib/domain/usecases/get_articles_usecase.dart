// lib/domain/usecases/get_articles_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:news_reader/core/api/api_exception.dart';
import 'package:news_reader/domain/entities/article.dart';
import 'package:news_reader/domain/repositories/news_repository.dart';

class GetArticlesUseCase {
  final NewsRepository _repository;

  GetArticlesUseCase(this._repository);

  Future<Either<ApiException, List<Article>>> execute({
    String? query,
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    return await _repository.getArticles(
      query: query,
      category: category,
      page: page,
      pageSize: pageSize,
    );
  }
}