import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:news_reader/core/di/locator.dart';
import 'package:news_reader/core/theme/theme_provider.dart';
import 'package:news_reader/data/models/article_model.dart';
import 'package:news_reader/presentation/providers/articles_provider.dart';
import 'package:news_reader/presentation/providers/sync_provider.dart';
import 'package:news_reader/presentation/screens/home_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ArticleModelAdapter());
  await Hive.openBox<ArticleModel>('articles');
  await Hive.openBox('settings'); // Add this line to initialize the settings box
  
  // Setup dependency injection
  setupLocator();
  
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => locator<ThemeProvider>()),
        ChangeNotifierProvider(create: (_) => locator<ArticlesProvider>()),
        ChangeNotifierProvider(create: (_) => locator<SyncProvider>()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'News Reader',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}