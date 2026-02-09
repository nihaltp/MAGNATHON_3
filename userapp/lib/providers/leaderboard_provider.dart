import 'package:flutter/foundation.dart';
import 'package:userapp/models/user_model.dart';
import 'package:userapp/services/database_service.dart';

class LeaderboardProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  List<UserModel> _leaderboard = [];
  bool _isLoading = false;
  String? _error;
  DateTime? _lastFetchTime;

  static const Duration _cacheDuration = Duration(minutes: 5);

  List<UserModel> get leaderboard => _leaderboard;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  /// Load leaderboard data (only if cache expired or forced refresh)
  Future<void> loadLeaderboard({bool forceRefresh = false}) async {
    // Return if cache is still valid and not forcing refresh
    print('Is this working??');
    if (!forceRefresh &&
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) < _cacheDuration &&
        _leaderboard.isNotEmpty) {
      print('LeaderboardProvider: Using cached leaderboard data');
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final leaderboardData = await _databaseService.getLeaderboard();
      _leaderboard = leaderboardData;
      _lastFetchTime = DateTime.now();
      _error = null;
      print('LeaderboardProvider: Successfully loaded leaderboard with ${leaderboardData.length} entries');
    } catch (e) {
      _error = e.toString();
      print('LeaderboardProvider: Error loading leaderboard: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh leaderboard data
  Future<void> refreshLeaderboard() async {
    print('LeaderboardProvider: Refreshing leaderboard');
    await loadLeaderboard(forceRefresh: true);
  }

  /// Get user's rank in leaderboard
  int getUserRank(String userId) {
    for (int i = 0; i < _leaderboard.length; i++) {
      if (_leaderboard[i].uid == userId) {
        return i + 1;
      }
    }
    return -1;
  }

  /// Clear leaderboard data
  void clear() {
    _leaderboard = [];
    _lastFetchTime = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
