import 'package:flutter/foundation.dart';
import 'package:userapp/models/user_model.dart';
import 'package:userapp/services/auth_service.dart';
import 'package:userapp/services/database_service.dart';

class UserProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load user data from Firebase
  Future<void> loadUser(String userId) async {
    if (_user?.uid == userId) {
      // User already loaded, don't reload
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userData = await _databaseService.getUserData(userId);
      _user = userData;
      _error = null;
    } catch (e) {
      _error = e.toString();
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh user data from database
  Future<void> refreshUser() async {
    if (_user == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userData = await _databaseService.getUserData(_user!.uid);
      _user = userData;
      _error = null;
    } catch (e) {
      _error = e.toString();
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
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
