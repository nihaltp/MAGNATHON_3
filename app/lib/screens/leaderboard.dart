import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magnathon/state/state_manager.dart';
import 'package:magnathon/widgets/circular_lead_user.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({super.key});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {

  List<Map<String, dynamic>> userLeaderboard = [];
  List<Map<String, dynamic>> top3 = [];
  List<CircularLeaderboardUser> circularTop3 = [];
  List<CircularLeaderboardUser> circularTop3Final = [];

  List<Widget> getTopUsers() {
    top3 = userLeaderboard.length >= 3 ? userLeaderboard.sublist(0, 3) : userLeaderboard;

    for(var user in top3) {
      if(user["rank"] == 1) {
        user["color"] = Colors.amber;
        user["size"] = 100;
      }else if(user["rank"] == 2) {
        user["color"] = Colors.grey.shade400;
        user["size"] = 80;
      }else if(user["rank"] == 3) {
          user["color"] = Colors.brown.shade300;
          user["size"] = 80;
      }
      circularTop3.add(CircularLeaderboardUser(user["name"], user["points"].toString(), user["rank"], user["size"], user["color"]));
    }

    circularTop3Final = circularTop3.length == 3 ? [circularTop3[1], circularTop3[0], circularTop3[2]] : circularTop3;
    return circularTop3Final;
  }

  void _generateTopUsers() {

  }

  @override
  void initState() {
    super.initState();
    userLeaderboard = Provider.of<StateManagement>(context, listen: false).leaderboard!;
    log("$userLeaderboard");
    // getTopUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text("Top Focusers", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Provider.of<StateManagement>(context).leaderboard!.length > 1 ? CircularLeaderboardUser(Provider.of<StateManagement>(context).leaderboard![1]["name"], "${Provider.of<StateManagement>(context).leaderboard![1]["score"]} pts", 2, 80, Colors.grey.shade400) : Container(),
                Provider.of<StateManagement>(context).leaderboard!.length > 0 ? CircularLeaderboardUser(Provider.of<StateManagement>(context).leaderboard![0]["name"], "${Provider.of<StateManagement>(context).leaderboard![0]["score"]} pts", 1, 100, Colors.amber) : Container(),
                Provider.of<StateManagement>(context).leaderboard!.length > 2 ? CircularLeaderboardUser(Provider.of<StateManagement>(context).leaderboard![2]["name"], "${Provider.of<StateManagement>(context).leaderboard![2]["score"]} pts", 3, 80, Colors.brown.shade300) : Container(),
              ],
            ),
          ),
          Expanded(child: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Consumer<StateManagement>(
        builder: (context, value, child) {
         log(value.leaderboard!.length.toString());
         return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: value.leaderboard!.length - 3,
          separatorBuilder: (context, index) => Divider(height: 0.5.h),
          itemBuilder: (context, index) {
            int actualRank = index + 4;
            return ListTile(
              leading: SizedBox(
                width: 30,
                child: Text("#$actualRank", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              ),
              title: Text("${value.leaderboard![actualRank - 1]["name"]}", style: const TextStyle(fontWeight: FontWeight.w600)),
              trailing: Text("${value.leaderboard![actualRank - 1]["score"]} pts", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
            );
          },
        );
        }
      )
    )
    ),
        ],
      ),
    );
  }
}