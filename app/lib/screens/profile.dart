import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magnathon/screens/point_redeem.dart';
import 'package:magnathon/screens/redeemQRScan.dart';
import 'package:magnathon/state/state_manager.dart';
import 'package:magnathon/widgets/admin_tile.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isHappyHour = false;
  bool _isAutoReset = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 25.h,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF1A237E),
            title: Text(
              Provider.of<StateManagement>(context).username,
              style: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A237E), Color(0xFF303F9F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 3.h),
                    CircleAvatar(
                      radius: 6.h,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.business_center, size: 6.h, color: const Color(0xFF1A237E)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.sp),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(children: [Text("${Provider.of<StateManagement>(context).users}", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)), Text("Users", style: TextStyle(fontSize: 14.sp, color: Colors.grey))]),
                        Container(width: 1, height: 4.h, color: Colors.grey.shade200),
                        // Column(children: [Text("450h", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)), Text("Off-Time", style: TextStyle(fontSize: 14.sp, color: Colors.grey))]),
                        // Container(width: 1, height: 4.h, color: Colors.grey.shade200),
                        Column(children: [Text("${Provider.of<StateManagement>(context).coasters}", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)), Text("Coasters", style: TextStyle(fontSize: 14.sp, color: Colors.grey))]),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),
                  Text("Operational Controls", style: TextStyle(fontSize: 21.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 2.h),
                  AdminTile(
                    title: "Happy Hour Mode",
                    subtitle: "Double points enabled",
                    icon: Icons.bolt_rounded,
                    iconColor: Colors.amber,
                    trailing: Switch(
                      value: _isHappyHour,
                      activeColor: const Color(0xFF1A237E),
                      onChanged: (val) => setState(() => _isHappyHour = val),
                    ),
                  ),

                  AdminTile(
                    title: "Auto-Clear Session",
                    subtitle: "Reset after 10m idle",
                    icon: Icons.history_rounded,
                    iconColor: Colors.blue,
                    trailing: Switch(
                      value: _isAutoReset,
                      activeColor: const Color(0xFF1A237E),
                      onChanged: (val) => setState(() => _isAutoReset = val),
                    ),
                  ),

                  AdminTile(
                    title: "Redeem Points",
                    subtitle: "Redeem user points for rewards",
                    icon: Icons.celebration_outlined,
                    iconColor: Colors.orange,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => RedeemQRScannerScreen()));
                    },
                  ),
                  SizedBox(height: 4.h),
                  Text("Account", style: TextStyle(fontSize: 21.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 2.h),
                  AdminTile(
                    title: "Hardware Calibration",
                    subtitle: "Sync Arduino & Sensors",
                    icon: Icons.settings_remote_outlined,
                    iconColor: Colors.grey,
                    onTap: () {},
                  ),

                  AdminTile(
                    title: "Logout Admin",
                    subtitle: "Securely end session",
                    icon: Icons.logout_rounded,
                    iconColor: Colors.redAccent,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}