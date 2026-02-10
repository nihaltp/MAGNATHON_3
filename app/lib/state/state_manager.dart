import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StateManagement with ChangeNotifier {
  String username = "";
  String email = "";
  //String profilePic = "";
  //String locality = "";
  //int id = 0;
  String owner = "";
  int coasters = 0;
  int users = 0;
  String docID = "";

  int activeCoasters = 0;
  List<String>? activeCoasterIds = [];

  List<Map<String, dynamic>>? leaderboard = [];

  void setProfile(String username, String email, String owner, int coasters, int users, String docID) {
    this.username = username;
    this.email = email;
    this.owner = owner;
    this.coasters = coasters;
    this.users = users;
    this.docID = docID;
    notifyListeners();
  }

  void setActiveCoasters(List<String> activeCoasterIds, int activeCoasters) {
    this.activeCoasters = activeCoasters;
    this.activeCoasterIds = activeCoasterIds;
    notifyListeners();
  }

  void setLeaderboard(List<Map<String, dynamic>> leaderboard) {
    this.leaderboard = leaderboard;
    notifyListeners();
  }
}