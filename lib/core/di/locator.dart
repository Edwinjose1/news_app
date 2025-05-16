// lib/core/di/locator.dart
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:news_reader/core/api/api_client.dart';
import 'package:news_reader/core/network/network_info.dart';
import 'package:news_reader/core/storage/hive_manager.dart';
import 'package:news_reader/core/theme/theme_provider.dart';
import 'package:news_reader/data/repositories/news_repository_impl.dart';
import 'package:news_reader/data/sources/local/news_local_source.dart';
import 'package:news_reader/data/sources/remote/news_remote_source.dart';
import 'package:news_reader/domain/repositories/news_repository.dart';
import 'package:news_reader/domain/usecases/get_articles_usecase.dart';
import 'package:news_reader/domain/usecases/sync_articles_usecase.dart';
import 'package:news_reader/presentation/providers/articles_provider.dart';
import 'package:news_reader/presentation/providers/sync_provider.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Core
  locator.registerLazySingleton(() => Dio());
  locator.registerLazySingleton(() => ApiClient(locator<Dio>()));
  locator.registerLazySingleton(() => NetworkInfoImpl());
  locator.registerLazySingleton(() => HiveManager());
  locator.registerLazySingleton(() => ThemeProvider());
  
  // Data Sources
  locator.registerLazySingleton(() => NewsRemoteSource(locator<ApiClient>()));
  locator.registerLazySingleton(() => NewsLocalSource(locator<HiveManager>()));
  
  // Repositories
  locator.registerLazySingleton<NewsRepository>(() => NewsRepositoryImpl(
        remoteSource: locator<NewsRemoteSource>(),
        localSource: locator<NewsLocalSource>(),
        networkInfo: locator<NetworkInfoImpl>(),
      ));
  
  // Use Cases
  locator.registerLazySingleton(() => GetArticlesUseCase(locator<NewsRepository>()));
  locator.registerLazySingleton(() => SyncArticlesUseCase(locator<NewsRepository>()));
  
  // Providers
  locator.registerFactory(() => ArticlesProvider(locator<GetArticlesUseCase>()));
  locator.registerFactory(() => SyncProvider(locator<SyncArticlesUseCase>()));
}