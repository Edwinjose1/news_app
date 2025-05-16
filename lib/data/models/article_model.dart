// lib/data/models/article_model.dart
// ignore_for_file: overridden_fields

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_reader/domain/entities/article.dart';

part 'article_model.g.dart';

@JsonSerializable(createFactory: false) // Disable the generated fromJson method
@HiveType(typeId: 0)
class ArticleModel extends Article {
  @override
  @HiveField(0)
  final String? id;
  
  @override
  @HiveField(1)
  final String? source;
  
  @override
  @HiveField(2)
  final String? author;
  
  @override
  @HiveField(3)
  final String title;
  
  @override
  @HiveField(4)
  final String description;
  
  @override
  @HiveField(5)
  final String url;
  
  @override
  @HiveField(6)
  final String? urlToImage;
  
  @override
  @HiveField(7)
  @JsonKey(name: 'publishedAt')
  final String publishedDate;
  
  @override
  @HiveField(8)
  final String? content;
  
  @override
  @HiveField(9)
  final bool isSynced;
  
  @HiveField(10)
  final DateTime? lastUpdated;

  ArticleModel({
    this.id,
    this.source,
    this.author,
    required this.title,
    required this.description,
    required this.url,
    this.urlToImage,
    required this.publishedDate,
    this.content,
    this.isSynced = true,
    this.lastUpdated,
  }) : super(
          id: id,
          source: source,
          author: author,
          title: title,
          description: description,
          url: url,
          urlToImage: urlToImage,
          publishedDate: publishedDate,
          content: content,
          isSynced: isSynced,
        );

  // Custom fromJson method to handle the nested 'source' field
  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] as String?,
      // Extract the 'name' from the source object
      source: json['source'] != null ? json['source']['name'] as String? : null,
      author: json['author'] as String?,
      title: json['title'] as String? ?? 'No Title', 
      description: json['description'] as String? ?? 'No Description',
      url: json['url'] as String? ?? 'https://example.com',
      urlToImage: json['urlToImage'] as String?,
      publishedDate: json['publishedAt'] as String? ?? DateTime.now().toIso8601String(),
      content: json['content'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);
  
  ArticleModel copyWith({
    String? id,
    String? source,
    String? author,
    String? title,
    String? description,
    String? url,
    String? urlToImage,
    String? publishedDate,
    String? content,
    bool? isSynced,
    DateTime? lastUpdated,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      source: source ?? this.source,
      author: author ?? this.author,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      urlToImage: urlToImage ?? this.urlToImage,
      publishedDate: publishedDate ?? this.publishedDate,
      content: content ?? this.content,
      isSynced: isSynced ?? this.isSynced,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}