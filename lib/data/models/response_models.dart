// lib/data/models/response_models.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:news_reader/data/models/article_model.dart';

part 'response_models.g.dart';

@JsonSerializable(createFactory: false) // Disable the generated fromJson method
class NewsResponse {
  final String status;
  final int totalResults;
  final List<ArticleModel> articles;

  NewsResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  // Custom fromJson method to manually construct the ArticleModel objects
  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    return NewsResponse(
      status: json['status'] as String,
      totalResults: json['totalResults'] as int,
      articles: (json['articles'] as List)
        .map((articleJson) => ArticleModel.fromJson(articleJson as Map<String, dynamic>))
        .toList(),
    );
  }
  
  Map<String, dynamic> toJson() => _$NewsResponseToJson(this);
}