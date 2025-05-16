// lib/presentation/providers/sync_provider.dart
import 'package:flutter/foundation.dart';
import 'package:news_reader/domain/usecases/sync_articles_usecase.dart';

enum SyncStatus { idle, syncing, success, error }

class SyncProvider extends ChangeNotifier {
  final SyncArticlesUseCase _syncArticlesUseCase;
  
  SyncStatus _status = SyncStatus.idle;
  String _errorMessage = '';
  
  SyncProvider(this._syncArticlesUseCase);
  
  SyncStatus get status => _status;
  String get errorMessage => _errorMessage;
  
  Future<void> syncArticles() async {
    if (_status == SyncStatus.syncing) return;
    
    _status = SyncStatus.syncing;
    notifyListeners();
    
    final result = await _syncArticlesUseCase.execute();
    
    result.fold(
      (failure) {
        _status = SyncStatus.error;
        _errorMessage = failure.message;
      },
      (success) {
        _status = SyncStatus.success;
      },
    );
    
    notifyListeners();
    
    // Reset to idle after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (_status != SyncStatus.syncing) {
        _status = SyncStatus.idle;
        notifyListeners();
      }
    });
  }
  
  Future<bool> hasUnSyncedArticles() async {
    return await _syncArticlesUseCase.hasUnSyncedArticles();
  }
}