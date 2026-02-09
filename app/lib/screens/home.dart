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
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Magnathon",
          style: TextStyle(
            fontSize: 25.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: const Color(0xFF1A237E),
          ),
        ),
      ),

      bottomNavigationBar: CrystalNavigationBar(
        currentIndex: _selectedIndex,
        height: 7.h,
        unselectedItemColor: Colors.white.withOpacity(0.5),
        borderWidth: 1,
        outlineBorderColor: Colors.white.withOpacity(0.2),
        backgroundColor: Colors.black.withOpacity(0.4),
        paddingR: const EdgeInsets.all(0),
        borderRadius: 30,
        onTap: _onTap,
        items: [
          CrystalNavigationBarItem(
            icon: Icons.grid_view_rounded,
            unselectedIcon: Icons.grid_view_outlined,
            selectedColor: Colors.white,
          ),
          CrystalNavigationBarItem(
            icon: Icons.emoji_events_rounded,
            unselectedIcon: Icons.emoji_events_outlined,
            selectedColor: Colors.white,
          ),
          CrystalNavigationBarItem(
            icon: Icons.person_rounded,
            unselectedIcon: Icons.person_outline_rounded,
            selectedColor: Colors.white,
          ),
        ],
      ),

      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
        children: const [
          LandingScreen(), 
          LeaderBoardScreen(), 
          ProfileScreen(),
        ],
      ),
    );
  }
}