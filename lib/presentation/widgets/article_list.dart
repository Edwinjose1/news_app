// lib/presentation/widgets/article_list.dart
import 'package:flutter/material.dart';
import 'package:news_reader/domain/entities/article.dart';
import 'package:news_reader/presentation/widgets/article_card.dart';
import 'package:news_reader/presentation/widgets/loading_indicator.dart';

class ArticleList extends StatefulWidget {
  final List<Article> articles;
  final Function() onLoadMore;
  final bool isLoading;
  final bool hasMore;

  const ArticleList({
    super.key,
    required this.articles,
    required this.onLoadMore,
    required this.isLoading,
    required this.hasMore,
  });

  @override
  State<ArticleList> createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        if (widget.hasMore && !widget.isLoading) {
          widget.onLoadMore();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        widget.onLoadMore();
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: widget.articles.length + (widget.isLoading ? 1 : 0),
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        itemBuilder: (context, index) {
          if (index < widget.articles.length) {
            return ArticleCard(article: widget.articles[index]);
          } else {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: LoadingIndicator()),
            );
          }
        },
      ),
    );
  }
}