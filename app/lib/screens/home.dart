import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:magnathon/screens/landing.dart';
import 'package:magnathon/screens/leaderboard.dart';
import 'package:magnathon/screens/profile.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _pageController = PageController();
  int selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Magnathon"
        ),
      ),
      bottomNavigationBar: CrystalNavigationBar(
        currentIndex: selectedIndex,
        height: 0.5.dp,
        // indicatorColor: Colors.blue,
        unselectedItemColor: Colors.white70,
        borderWidth: 2,
        outlineBorderColor: Colors.white,
        backgroundColor: Colors.black.withValues(alpha: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 1,
            spreadRadius: 1,
            offset: Offset(0, 5),
          ),
        ],
        onTap: (index) {
          _pageController.jumpToPage(index);
            setState(() {
            selectedIndex = index;
          });
        },
        items: [
          CrystalNavigationBarItem(
            icon: Icons.home,
            unselectedIcon: Icons.home_outlined,
            selectedColor: Colors.white,
          ),

          CrystalNavigationBarItem(
            icon: Icons.leaderboard_rounded,
            unselectedIcon: Icons.leaderboard_outlined,
            selectedColor: Colors.white,
          ),

          CrystalNavigationBarItem(
            icon: Icons.account_circle_rounded,
            unselectedIcon: Icons.account_circle_outlined,
            selectedColor: Colors.white,
          ),
        ],
      ),
      body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [LandingScreen(), LeaderBoardScreen(), ProfileScreen()],
        
        )
    );
  }
}