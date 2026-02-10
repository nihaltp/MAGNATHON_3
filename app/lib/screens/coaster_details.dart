import 'package:flutter/material.dart';
import 'package:magnathon/database/admin_database.dart';
import 'package:magnathon/state/state_manager.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CoasterDetailsScreen extends StatefulWidget {
  const CoasterDetailsScreen({super.key, required this.coasterIndex});

  final int coasterIndex;

  @override
  State<CoasterDetailsScreen> createState() => _CoasterDetailsScreenState();
}

class _CoasterDetailsScreenState extends State<CoasterDetailsScreen> {

  String currentUserName = "";
  String sessionStart = "";
  int currentScore = 0;
  bool isPhoneDocked = true;


  Future getActiveCoasterDetails() async {
    if(mounted) {
      List<Map<String, dynamic>> finalResult = await DatabaseMethods().getActiveCoasterDetails(Provider.of<StateManagement>(context, listen: false).activeCoasterIds![widget.coasterIndex]);
      if(finalResult.isNotEmpty) {
        setState(() {
          currentUserName = finalResult[1]["name"];
          DateTime startTime = finalResult[0]["startTime"].toDate();
          sessionStart = "${startTime.day}/${(startTime.month)}/${startTime.year} ${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}";
          currentScore = finalResult[0]["currScore"];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getActiveCoasterDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text("Coaster ${widget.coasterIndex + 1}"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.history)),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Status Hero Card
            Container(
              width: 100.w,
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isPhoneDocked 
                    ? [const Color(0xFF1B5E20), const Color(0xFF4CAF50)] // Green for Docked
                    : [const Color(0xFFB71C1C), const Color(0xFFF44336)], // Red for Away
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20.sp),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Column(
                children: [
                  Icon(
                    isPhoneDocked ? Icons.phonelink_lock_rounded : Icons.phonelink_erase_rounded,
                    color: Colors.white,
                    size: 40.sp,
                  ),
                  SizedBox(height: 1.5.h),
                  Text(
                    isPhoneDocked ? "PHONE DOCKED" : "PHONE REMOVED",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    isPhoneDocked ? "User is earning points" : "Session paused",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            SizedBox(height: 4.h),

            // 2. User & Session Info
            Text("Session Details", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 2.h),
            
            _buildDetailTile(Icons.person, "Active User", currentUserName),
            _buildDetailTile(Icons.timer, "Session Started", sessionStart),
            _buildDetailTile(Icons.stars, "Current Points", "$currentScore pts"),

            SizedBox(height: 1.h),

            Text("Management", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 2.h),
            
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: "Alert User",
                    icon: Icons.notifications_active,
                    color: Colors.orange,
                    onTap: () {},
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: _buildActionButton(
                    label: "End Session",
                    icon: Icons.exit_to_app,
                    color: Colors.red,
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Inline widget for details to keep the build method clean
  Widget _buildDetailTile(IconData icon, String title, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.5.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.sp),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1A237E), size: 20.sp),
          SizedBox(width: 4.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
              Text(value, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15.sp),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            SizedBox(height: 1.h),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}