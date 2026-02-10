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
    print('LeaderboardProvider: Loading leaderboard from database');
    if (!forceRefresh &&
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) < _cacheDuration &&
        _leaderboard.isNotEmpty) {
      print('LeaderboardProvider: Using cached leaderboard data (${_leaderboard.length} users)');
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final leaderboardData = await _databaseService.getLeaderboard(); // Fetches top 100 users sorted by highScore
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
    print('LeaderboardProvider: Looking up rank for userId: $userId in ${_leaderboard.length} cached users');
    for (int i = 0; i < _leaderboard.length; i++) {
      if (_leaderboard[i].uid == userId) {
          int rank = i + 1;
          print('LeaderboardProvider: Found user rank: $rank (highScore: ${_leaderboard[i].highScore})');
          return rank;
      }
    }
    print('LeaderboardProvider: User not found in cached leaderboard (ranked beyond top ${_leaderboard.length})');
    return -1;
  }
  
  /// Fetch user's rank, falling back to a database query if not in cached list
  Future<int> fetchUserRank(String userId) async {
    final cachedRank = getUserRank(userId);
    if (cachedRank != -1) return cachedRank;

    try {
      print('LeaderboardProvider: Falling back to database for rank of $userId');
      final dbRank = await _databaseService.getUserRank(userId);
      print('LeaderboardProvider: Database returned rank $dbRank for $userId');
      return dbRank;
    } catch (e) {
      print('LeaderboardProvider: Error fetching rank from database: $e');
      return -1;
    }
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
