// lib/domain/entities/article.dart
class Article {
  final String? id;
  final String? source;
  final String? author;
  final String title;
  final String description;
  final String url;
  final String? urlToImage;
  final String publishedDate;
  final String? content;
  final bool isSynced;

  Article({
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
  });
}