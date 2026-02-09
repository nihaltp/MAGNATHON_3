import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:userapp/models/user_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user data
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw e.toString();
    }
  }

  // Stream of user data
  Stream<UserModel?> getUserDataStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  // Get leaderboard data
  Future<List<UserModel>> getLeaderboard({int limit = 10}) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .orderBy('highScore', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw e.toString();
    }
  }

  // Get user rank
  Future<int> getUserRank(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      UserModel user = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('highScore', isGreaterThan: user.highScore)
          .get();

      return snapshot.size + 1;
    } catch (e) {
      throw e.toString();
    }
  }

  // Stream of leaderboard
  Stream<List<UserModel>> getLeaderboardStream({int limit = 10}) {
    return _firestore
        .collection('users')
        .orderBy('highScore', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
