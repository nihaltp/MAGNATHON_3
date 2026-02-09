import 'package:flutter/foundation.dart';
import 'package:userapp/models/user_model.dart';
import 'package:userapp/services/auth_service.dart';
import 'package:userapp/services/database_service.dart';

class UserProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();

  UserModel? _user;
  String? _userId;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load user data from Firebase
  Future<void> loadUser(String userId) async {
    // Skip if same user is already loaded
    if (_userId == userId && _user != null) {
      return;
    }

    _userId = userId;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userData = await _databaseService.getUserData(userId);
      _user = userData;
      _error = null;
      print('UserProvider: Successfully loaded user data for $userId');
    } catch (e) {
      _error = e.toString();
      _user = null;
      print('UserProvider: Error loading user data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh user data from database
  Future<void> refreshUser() async {
    // Use stored userId, even if _user is null
    final userIdToRefresh = _userId;
    if (userIdToRefresh == null) {
      print('UserProvider: No userId stored, cannot refresh');
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userData = await _databaseService.getUserData(userIdToRefresh);
      _user = userData;
      _error = null;
      print('UserProvider: Successfully refreshed user data for $userIdToRefresh');
    } catch (e) {
      _error = e.toString();
      _user = null;
      print('UserProvider: Error refreshing user data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update user data locally and in Firebase
  Future<void> updateUser(UserModel updatedUser) async {
    _user = updatedUser;
    notifyListeners();

    try {
      await _databaseService.updateUserData(updatedUser);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Update specific user stats
  Future<void> updateUserStats({
    required int score,
    required int highScore,
    required int remainingPoints,
  }) async {
    if (_user == null) return;

    _user = _user!.copyWith(
      score: score,
      highScore: highScore,
      remainingPoints: remainingPoints,
    );
    notifyListeners();

    try {
      await _databaseService.updateUserStats(
        uid: _user!.uid,
        score: score,
        highScore: highScore,
        remainingPoints: remainingPoints,
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Clear user data on logout
  void clearUser() {
    _user = null;
    _userId = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
