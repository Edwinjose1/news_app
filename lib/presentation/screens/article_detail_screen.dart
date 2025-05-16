// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_reader/domain/entities/article.dart';
import 'package:news_reader/domain/repositories/news_repository.dart';
import 'package:news_reader/core/di/locator.dart';
import 'package:news_reader/core/utils/date_formatter.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  late final NewsRepository _newsRepository;
  bool _isSaved = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _newsRepository = locator<NewsRepository>();
    _checkIfArticleSaved();
  }

  Future<void> _checkIfArticleSaved() async {
    final isSaved = await _newsRepository.isArticleSaved(widget.article.url);
    if (mounted) {
      setState(() {
        _isSaved = isSaved;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleSave() async {
    setState(() => _isLoading = true);

    bool success;
    if (_isSaved) {
      success = await _newsRepository.removeArticle(widget.article.url);
    } else {
      success = await _newsRepository.saveArticle(widget.article);
    }

    if (mounted) {
      setState(() {
        _isSaved = !_isSaved;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? (_isSaved ? 'Article saved' : 'Article removed')
                : 'Failed to update article',
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  _isLoading
                      ? Icons.hourglass_empty
                      : (_isSaved ? Icons.bookmark : Icons.bookmark_outline),
                  color: _isSaved ? Colors.amber : Colors.white,
                ),
                onPressed: _isLoading ? null : _toggleSave,
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                // Hero image
                widget.article.urlToImage != null
                    ? CachedNetworkImage(
                        imageUrl: widget.article.urlToImage!,
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: const Icon(Icons.error),
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        color: theme.colorScheme.primaryContainer,
                        child: Center(
                          child: Icon(
                            Icons.article,
                            size: 80,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                
                // Gradient overlay
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),
                
                // Title overlay
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Text(
                    widget.article.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Metadata row
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Author & date row
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                                      radius: 20,
                                      child: Icon(
                                        Icons.person,
                                        color: theme.colorScheme.primary,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.article.author ?? 'Unknown',
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            DateFormatter.format(widget.article.publishedDate),
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const Divider(height: 24),
                                
                                // Source row
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                                      radius: 20,
                                      child: Icon(
                                        Icons.public,
                                        color: theme.colorScheme.primary,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        widget.article.source ?? 'Unknown Source',
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                               
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Description
                          Text(
                            widget.article.description,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: 18,
                              height: 1.6,
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Content
                          if (widget.article.content != null)
                            Text(
                              widget.article.content!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.6,
                                color: theme.colorScheme.onBackground.withOpacity(0.8),
                              ),
                            ),
                            
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }
}