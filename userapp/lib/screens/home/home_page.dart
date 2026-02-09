import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:userapp/config/app_colors.dart';
import 'package:userapp/screens/home/dashboard_page.dart';
import 'package:userapp/screens/profile/profile_page.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:userapp/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String? _selectedRestaurant;

  final List<Map<String, String>> restaurants = [
    {
      'id': '1',
      'name': 'Restaurant 1',
      'description': 'Delicious Italian Cuisine',
      'icon': '🍝',
    },
    {
      'id': '2',
      'name': 'Restaurant 2',
      'description': 'Asian Fusion Experience',
      'icon': '🍜',
    },
    {
      'id': '3',
      'name': 'Restaurant 3',
      'description': 'Premium Steakhouse',
      'icon': '🥩',
    },
    {
      'id': '4',
      'name': 'Restaurant 4',
      'description': 'Mexican Street Food',
      'icon': '🌮',
    },
    {
      'id': '5',
      'name': 'Restaurant 5',
      'description': 'Mediterranean Delights',
      'icon': '🍆',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_selectedIndex),
      bottomNavigationBar: CrystalNavigationBar(
        currentIndex: _selectedIndex,
        height: 7.h,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        borderWidth: 1,
        outlineBorderColor: Colors.white.withOpacity(0.2),
        backgroundColor: Colors.black.withOpacity(0.35),
        paddingR: const EdgeInsets.all(0),
        borderRadius: 30,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          CrystalNavigationBarItem(
            icon: Icons.home,
            unselectedIcon: Icons.home_outlined,
            selectedColor: AppColors.white,
          ),
          CrystalNavigationBarItem(
            icon: Icons.dashboard_rounded,
            unselectedIcon: Icons.dashboard_outlined,
            selectedColor: AppColors.white,
          ),
          CrystalNavigationBarItem(
            icon: Icons.person_rounded,
            unselectedIcon: Icons.person_outline_rounded,
            selectedColor: AppColors.white,
          ),
        ],
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return _buildHomePage();
      case 1:
        return DashboardPage(restaurantName: _selectedRestaurant ?? 'Overall');
      case 2:
        return const ProfilePage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryLight,
            AppColors.primaryDark,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome!',
                        style: TextStyle(
                          fontSize: 6.w,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      Text(
                        'Explore Restaurants',
                        style: TextStyle(
                          fontSize: 3.5.w,
                          color: AppColors.accentColor,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      _showLogoutDialog();
                    },
                    child: Icon(
                      Icons.logout,
                      color: AppColors.accentColor,
                      size: 6.w,
                    ),
                  ),
                ],
              ),
            ),
            // Restaurant list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = restaurants[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 2.5.h),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedRestaurant = restaurant['name'];
                          _selectedIndex = 1;
                        });
                      },
                      child: Container(
                        height: 20.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.w),
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryDark.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Gradient background
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.w),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.primaryDark.withOpacity(0.1),
                                    AppColors.primaryLight.withOpacity(0.1),
                                  ],
                                ),
                              ),
                            ),
                            // Content
                            Padding(
                              padding: EdgeInsets.all(4.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            restaurant['name']!,
                                            style: TextStyle(
                                              fontSize: 5.5.w,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryDark,
                                            ),
                                          ),
                                          SizedBox(height: 1.h),
                                          Text(
                                            restaurant['description']!,
                                            style: TextStyle(
                                              fontSize: 3.5.w,
                                              color: AppColors.greyMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        restaurant['icon']!,
                                        style: TextStyle(fontSize: 8.w),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 3.w,
                                      vertical: 1.5.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.accentColor,
                                      borderRadius: BorderRadius.circular(2.w),
                                    ),
                                    child: Text(
                                      'View Dashboard',
                                      style: TextStyle(
                                        fontSize: 3.5.w,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              AuthService().signOut();
              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
