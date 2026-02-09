import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magnathon/widgets/circular_lead_user.dart';
import 'package:sizer/sizer.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({super.key});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {

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
                CircularLeaderboardUser("User 2", "840 pts", 2, 80, Colors.grey.shade400),
                CircularLeaderboardUser("User 1", "1.2k pts", 1, 100, Colors.amber),
                CircularLeaderboardUser("User 3", "790 pts", 3, 80, Colors.brown.shade300),
              ],
            ),
          ),
          Expanded(child: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: 10,
        separatorBuilder: (context, index) => Divider(height: 0.5.h),
        itemBuilder: (context, index) {
          int actualRank = index + 4;
          return ListTile(
            leading: SizedBox(
              width: 30,
              child: Text("#$actualRank", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
            title: Text("User Name $actualRank", style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text("Table 4 • 2hrs offline"),
            trailing: const Text("620 pts", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
          );
        },
      ),
    )
    ),
        ],
      ),
    );
  }
}