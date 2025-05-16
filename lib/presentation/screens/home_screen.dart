// lib/presentation/screens/home_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:news_reader/core/theme/theme_provider.dart';
import 'package:news_reader/presentation/providers/articles_provider.dart';
import 'package:news_reader/presentation/providers/sync_provider.dart';
import 'package:news_reader/presentation/screens/settings_screen.dart';
import 'package:news_reader/presentation/widgets/article_list.dart';
import 'package:news_reader/presentation/widgets/loading_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final _connectivity = Connectivity();
  final _searchController = TextEditingController();
  final _categories = [
    'General',
    'Business',
    'Technology',
    'Entertainment',
    'Health',
    'Science',
    'Sports',
  ];
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String? _selectedCategory;
  bool _isOnline = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  void initState() {
    super.initState();
    _setupConnectivityListener();
    _loadArticles();
    
    // Animation setup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn)
    );
    _animationController.forward();
  }
  
  void _setupConnectivityListener() {
    _connectivity.onConnectivityChanged.listen((result) {
      final isOnline = result != ConnectivityResult.none;
      if (isOnline != _isOnline) {
        setState(() => _isOnline = isOnline);
        
        if (isOnline) {
          _syncArticlesIfNeeded();
          _showSnackbar('You are back online. Syncing data...', Colors.green);
        } else {
          _showSnackbar('You are offline. Using cached data.', Colors.orange);
        }
      }
    });
    
    _checkConnectivity();
  }
  
  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(8),
      ),
    );
  }
  
  Future<void> _checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    setState(() => _isOnline = result != ConnectivityResult.none);
  }
  
  Future<void> _syncArticlesIfNeeded() async {
    final syncProvider = Provider.of<SyncProvider>(context, listen: false);
    if (await syncProvider.hasUnSyncedArticles()) {
      await syncProvider.syncArticles();
    }
  }
  
  void _loadArticles() {
    final articlesProvider = Provider.of<ArticlesProvider>(context, listen: false);
    articlesProvider.getArticles();
  }
  
  Future<void> _refreshArticles() async {
    final articlesProvider = Provider.of<ArticlesProvider>(context, listen: false);
    await articlesProvider.refreshArticles();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(theme),
      appBar: AppBar(
        title: const Text(
          'News Reader',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Connection status indicator
            if (!_isOnline)
              Container(
                color: theme.colorScheme.error.withOpacity(0.8),
                padding: const EdgeInsets.symmetric(vertical: 6),
                width: double.infinity,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Offline Mode - Using Cached Data',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            
            // Search bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search news...',
                  hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  prefixIcon: Icon(
                    Icons.search, 
                    color: theme.colorScheme.primary,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear, 
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    onPressed: () {
                      _searchController.clear();
                      Provider.of<ArticlesProvider>(context, listen: false).refreshArticles();
                    },
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    Provider.of<ArticlesProvider>(context, listen: false).searchArticles(value);
                    setState(() => _selectedCategory = null);
                  }
                },
              ),
            ),
            
            // Categories
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              height: 56,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category.toLowerCase();
                  
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCategory = isSelected ? null : category.toLowerCase();
                          _searchController.clear();
                        });
                        Provider.of<ArticlesProvider>(context, listen: false)
                          .filterByCategory(_selectedCategory ?? '');
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected 
                            ? theme.colorScheme.primary 
                            : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected 
                              ? theme.colorScheme.primary 
                              : theme.dividerColor,
                            width: 1.5,
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ] : null,
                        ),
                        child: Center(
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected 
                                ? Colors.white 
                                : theme.colorScheme.onSurface,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Sync status indicator
            Consumer<SyncProvider>(
              builder: (context, syncProvider, child) {
                if (syncProvider.status == SyncStatus.syncing) {
                  return Container(
                    color: theme.colorScheme.primaryContainer,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Syncing data...',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (syncProvider.status == SyncStatus.success) {
                  return Container(
                    color: Colors.green.withOpacity(0.15),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Data synced successfully!',
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (syncProvider.status == SyncStatus.error) {
                  return Container(
                    color: theme.colorScheme.errorContainer,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Sync error: ${syncProvider.errorMessage}',
                          style: TextStyle(
                            color: theme.colorScheme.onErrorContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            
            // Articles list with pull-to-refresh
            Expanded(
              child: Consumer<ArticlesProvider>(
                builder: (context, provider, child) {
                  if (provider.status == ArticlesStatus.initial) {
                    return const Center(child: LoadingIndicator());
                  } else if (provider.status == ArticlesStatus.loading && provider.articles.isEmpty) {
                    return const Center(child: LoadingIndicator());
                  } else if (provider.status == ArticlesStatus.error && provider.articles.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, 
                            size: 48, 
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${provider.errorMessage}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () => provider.refreshArticles(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Try Again'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (provider.articles.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 48,
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No articles found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try a different search or category',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return RefreshIndicator(
                    onRefresh: _refreshArticles,
                    color: theme.colorScheme.primary,
                    strokeWidth: 2.5,
                    displacement: 40,
                    child: ArticleList(
                      articles: provider.articles,
                      onLoadMore: provider.loadMore,
                      isLoading: provider.status == ArticlesStatus.loading,
                      hasMore: provider.hasMore,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(ThemeData theme) {
    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16, bottom: 16),
            color: theme.colorScheme.primary,
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.onPrimary.withOpacity(0.2),
                  ),
                  child: Icon(
                    Icons.newspaper,
                    size: 40,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'News Reader',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Stay informed, anytime, anywhere',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary.withOpacity(0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildDrawerItem(
            context,
            icon: Icons.home_outlined,
            title: 'Home',
            isActive: true,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
     
          _buildDrawerItem(
            context,
            icon: Icons.sync,
            title: 'Sync Now',
            onTap: () {
              Navigator.pop(context);
              final syncProvider = Provider.of<SyncProvider>(context, listen: false);
              syncProvider.syncArticles();
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: Icons.info_outline,
            title: 'About',
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'News Reader',
                applicationVersion: '1.0.0',
                applicationIcon: const FlutterLogo(),
                children: [
                  const Text(
                    'A modern news reader application built with Flutter that works seamlessly online and offline.',
                  ),
                ],
              );
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, _) {
                    final isDark = themeProvider.themeMode == ThemeMode.dark;
                    return Row(
                      children: [
                        Icon(
                          isDark ? Icons.dark_mode : Icons.light_mode,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isDark ? 'Dark Mode' : 'Light Mode',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Switch(
                          value: isDark,
                          activeColor: theme.colorScheme.primary,
                          onChanged: (value) {
                            Provider.of<ThemeProvider>(context, listen: false)
                                .setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    bool isActive = false,
    String? badge,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.8),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurface,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: badge != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      onTap: onTap,
      dense: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      tileColor: isActive ? theme.colorScheme.primary.withOpacity(0.1) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}