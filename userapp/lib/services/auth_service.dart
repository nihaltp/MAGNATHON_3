import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:userapp/models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      print('AuthService: Creating user with email: $email');
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;
      print('AuthService: User created with uid: $uid');

      UserModel userModel = UserModel(
        uid: uid,
        email: email,
        name: name,
        score: 0,
        highScore: 0,
        remainingPoints: 100,
        createdAt: DateTime.now(),
      );

      print('AuthService: Saving user data to Firestore for uid: $uid');
      await _firestore
          .collection('users')
          .doc(uid)
          .set(userModel.toMap());
      print('AuthService: Successfully saved user data to Firestore');

      return userModel;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email.';
      } else {
        throw e.message ?? 'An error occurred';
      }
    } catch (e) {
      // Handle Pigeon serialization errors and other platform channel errors
      String errorMessage = e.toString();
      print('AuthService: Caught exception in signUp: $e');
      if (errorMessage.contains('PigeonUserDetails')) {
        print('AuthService: PigeonUserDetails error detected, attempting recovery');
        // User was likely created successfully despite the platform error
        // Try to get the current user
        await Future.delayed(const Duration(milliseconds: 500));
        User? user = _firebaseAuth.currentUser;
        if (user != null) {
          // Ensure user data is saved to Firestore
          UserModel userModel = UserModel(
            uid: user.uid,
            email: user.email ?? '',
            name: name,
            score: 0,
            highScore: 0,
            remainingPoints: 100,
            createdAt: DateTime.now(),
          );
          
          print('AuthService: Saving recovered user data to Firestore for uid: ${user.uid}');
          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(userModel.toMap());
          
          DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
          if (doc.exists) {
            print('AuthService: Successfully recovered and saved user data');
            return UserModel.fromMap(doc.data() as Map<String, dynamic>);
          }
        }
        throw 'Registration completed but verification error occurred. Please log in.';
      }
      rethrow;
    }
  }

  // Sign in
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userCredential.user!.uid).get();

      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An error occurred';
    } catch (e) {
      // Handle Pigeon serialization errors
      String errorMessage = e.toString();
      if (errorMessage.contains('PigeonUserDetails')) {
        // Authentication likely succeeded despite platform error
        await Future.delayed(const Duration(milliseconds: 500));
        User? user = _firebaseAuth.currentUser;
        if (user != null) {
          DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
          if (doc.exists) {
            return UserModel.fromMap(doc.data() as Map<String, dynamic>);
          }
        }
        throw 'Login successful but verification error. Please try again.';
      }
      rethrow;
    }
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          return UserModel.fromMap(doc.data() as Map<String, dynamic>);
        }
      }
      return null;
    } catch (e) {
      throw e.toString();
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String uid,
    required String name,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'name': name,
      });
    } catch (e) {
      throw e.toString();
    }
  }

  // Update user stats
  Future<void> updateUserStats({
    required String uid,
    required int score,
    required int highScore,
    required int remainingPoints,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'score': score,
        'highScore': highScore,
        'remainingPoints': remainingPoints,
      });
    } catch (e) {
      throw e.toString();
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Check if user is logged in
  bool isUserLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }

  // Get current user ID
  String? getCurrentUserId() {
    return _firebaseAuth.currentUser?.uid;
  }

  // Stream of current user
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
