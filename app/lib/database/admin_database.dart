// import 'dart:developer';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:magnathon/state/state_manager.dart';
import 'package:provider/provider.dart';
// import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
// import 'package:random_string/random_string.dart';

class DatabaseMethods {

  FirebaseFirestore database = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late UserCredential credential;

  Future signUp(String email, String password) async {
    try {
      credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      // await auth.currentUser?.sendEmailVerification();
      return true;
    } catch(e) {
      return false;
    }
  }

  Future signIn(String email, String password) async {
    List finalResult = [];
    try {
      QuerySnapshot result = await database.collection("admin").where("email", isEqualTo: email).where("password", isEqualTo: password).get();
      log("${result.docs[0]['password']}");
      if(result.docs.isNotEmpty) {
        finalResult.add(result.docs[0]);
        finalResult.add(result.docs[0].id);
      }
      return finalResult;
    } catch(e) {
      return finalResult;
    }
  }

  Future getUserInfo(String email, String password) async {
    try {
      credential = await auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch(e) {
      return false;
    }
  }

  Future getActiveCoasters(String id) async {
    List<String> finalResult = [];
    try {
      final adminRef = FirebaseFirestore.instance.collection('admin').doc(id);

      QuerySnapshot result = await FirebaseFirestore.instance.collection('coaster').where('admin', isEqualTo: adminRef).where('active', isEqualTo: true).get();

      if(result.docs.isNotEmpty) {
        for(var i in result.docs) {
          finalResult.add(i.id);
        }
      }
      return finalResult;
    } catch(e) {
      return finalResult;
    }
  }

  Future getLeaderboard() async {
    List<Map<String, dynamic>> finalResult = [];
    try {
      QuerySnapshot result = await database.collection("users").orderBy("score", descending: true).get();
      if(result.docs.isNotEmpty) {
        for(var i in result.docs) {
          finalResult.add(i.data() as Map<String, dynamic>);
        }
      }
      return finalResult;
    } catch(e) {
      return finalResult;
    }
  }

  Future startGame(int coasterID, String userID, String adminID) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
      final adminRef = FirebaseFirestore.instance.collection('admin').doc(adminID);
      await FirebaseFirestore.instance.collection('coaster').where("admin", isEqualTo: adminRef).where("number", isEqualTo: coasterID).get().then((value) {
        if(value.docs.isNotEmpty) {
          value.docs[0].reference.update({
            "active" : true,
            "currUser" : userRef,
            "startTime" : FieldValue.serverTimestamp(),
          });
        }
      });
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getActiveCoasterDetails(String coasterId) async {
    List<Map<String, dynamic>> finalResult = [];
    try {
      DocumentSnapshot result = await database.collection("coaster").doc(coasterId).get();
      final userData = result['currUser'] as DocumentReference;
      DocumentSnapshot<Object?> userResult = await userData.get();
      if(result.exists) {
        finalResult.add(result.data() as Map<String, dynamic>);
        finalResult.add(userResult.data() as Map<String, dynamic>);
      }
      return finalResult;
    } catch(e) {
      return finalResult;
    }
  }

  Future getUserDetails(String userID) async {
    Map<String, dynamic> finalResult = {};
    try {
      DocumentSnapshot result = await database.collection("users").doc(userID).get();
      if(result.exists) {
        finalResult = result.data() as Map<String, dynamic>;
      }
      return finalResult;
    } catch(e) {
      return finalResult;
    }
  }

  Future redeemPoints(String userID, int pointsToRedeem) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
      await userRef.update({
        "remainingPoints" : FieldValue.increment(-pointsToRedeem)
      });
      return true;
    } catch(e) {
      return false;
    }
  }

}