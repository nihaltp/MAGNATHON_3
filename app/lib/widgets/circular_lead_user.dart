import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CircularLeaderboardUser extends StatelessWidget {
  final int size;
  final Color color;
  final int rank;
  final String name;
  final String pts;
  
  const CircularLeaderboardUser(this.name, this.pts, this.rank, this.size, this.color, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 3),
              ),
              child: CircleAvatar(
                radius: size / 2,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(Icons.person, size: 40),
              ),
            ),
            CircleAvatar(
              radius: 12,
              backgroundColor: color,
              child: Text(rank.toString(), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        Text(name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        Text(pts, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
      ],
    );
  }


}