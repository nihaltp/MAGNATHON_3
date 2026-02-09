import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:userapp/config/app_colors.dart';
import 'package:userapp/services/auth_service.dart';
import 'package:userapp/models/user_model.dart';
import 'package:userapp/providers/user_provider.dart';
import 'package:userapp/screens/auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          UserModel? user = userProvider.user;
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'User data not found',
                    style: TextStyle(fontSize: 4.w, color: AppColors.white),
                  ),
                  SizedBox(height: 2.h),
                  ElevatedButton.icon(
                    onPressed: () {
                      userProvider.refreshUser();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

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
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Profile',
                          style: TextStyle(
                            fontSize: 6.w,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        Row(
                          children: [
                            // Refresh button
                            GestureDetector(
                              onTap: () {
                                context.read<UserProvider>().refreshUser();
                              },
                              child: Container(
                                padding: EdgeInsets.all(2.5.w),
                                decoration: BoxDecoration(
                                  color: AppColors.accentColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.refresh,
                                  color: AppColors.primaryDark,
                                  size: 5.w,
                                ),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            // Logout button
                            GestureDetector(
                              onTap: () {
                                _showLogoutDialog();
                              },
                              child: Container(
                                padding: EdgeInsets.all(2.5.w),
                                decoration: BoxDecoration(
                                  color: AppColors.accentColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.logout,
                                  color: AppColors.primaryDark,
                                  size: 5.w,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    // Profile Avatar
                    Container(
                      width: 25.w,
                      height: 25.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accentColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentColor.withOpacity(0.4),
                            spreadRadius: 4,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.person,
                        size: 12.w,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    SizedBox(height: 2.5.h),
                    // User Name
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 5.5.w,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    // User Email
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 3.5.w,
                        color: AppColors.accentColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // User Stats Grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 3.w,
                      mainAxisSpacing: 3.w,
                      childAspectRatio: 1.2,
                      children: [
                        _buildStatBox(
                          title: 'Current Score',
                          value: user.score.toString(),
                          icon: Icons.star,
                          color1: const Color(0xFF4CAF50),
                          color2: const Color(0xFF388E3C),
                        ),
                        _buildStatBox(
                          title: 'Highest Score',
                          value: user.highScore.toString(),
                          icon: Icons.trending_up,
                          color1: const Color(0xFF2196F3),
                          color2: const Color(0xFF1565C0),
                        ),
                        _buildStatBox(
                          title: 'Remaining Points',
                          value: user.remainingPoints.toString(),
                          icon: Icons.point_of_sale,
                          color1: const Color(0xFFE91E63),
                          color2: const Color(0xFFC2185B),
                        ),
                        _buildStatBox(
                          title: 'Member Since',
                          value: '${user.createdAt.month}/${user.createdAt.day}/${user.createdAt.year}',
                          icon: Icons.calendar_today,
                          color1: const Color(0xFFFF9800),
                          color2: const Color(0xFFF57C00),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    // QR Code Section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(3.w),
                        border: Border.all(color: AppColors.accentColor, width: 2),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'My QR Code',
                            style: TextStyle(
                              fontSize: 4.5.w,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentColor,
                            ),
                          ),
                          SizedBox(height: 2.5.h),
                          // QR Code Display
                          Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            child: _buildQrCodeDisplay(user.uid),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'User ID: ${user.uid}',
                            style: TextStyle(
                              fontSize: 2.5.w,
                              color: AppColors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                    // Edit Profile Button
                    SizedBox(
                      width: double.infinity,
                      height: 6.h,
                      child: ElevatedButton(
                        onPressed: () {
                          _showEditProfileDialog(user);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                        ),
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 4.5.w,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatBox({
    required String title,
    required String value,
    required IconData icon,
    required Color color1,
    required Color color2,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.5.w),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color1, color2],
        ),
        boxShadow: [
          BoxShadow(
            color: color1.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.white, size: 6.w),
          SizedBox(height: 0.8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 4.w,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 2.5.w,
              color: AppColors.white.withOpacity(0.8),
            ),
          ),
        ],
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
              _authService.signOut();
              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(UserModel user) {
    late TextEditingController nameController;
    nameController = TextEditingController(text: user.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: 'Full Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                _authService.updateUserProfile(
                  uid: user.uid,
                  name: nameController.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCodeDisplay(String userId) {
    return Column(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.primaryDark, width: 2),
            borderRadius: BorderRadius.circular(1.w),
          ),
          padding: EdgeInsets.all(1.w),
          child: PrettyQrView.data(
            data: userId,
            decoration: const PrettyQrDecoration(),
          ),
        ),
      ],
    );
  }
}
