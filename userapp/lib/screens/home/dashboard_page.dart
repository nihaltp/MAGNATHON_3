import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:userapp/config/app_colors.dart';
import 'package:userapp/services/auth_service.dart';
import 'package:userapp/models/user_model.dart';
import 'package:userapp/providers/user_provider.dart';
import 'package:userapp/providers/leaderboard_provider.dart';

class DashboardPage extends StatefulWidget {
  final String restaurantName;

  const DashboardPage({Key? key, required this.restaurantName}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<UserProvider, LeaderboardProvider>(
        builder: (context, userProvider, leaderboardProvider, child) {
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
                      leaderboardProvider.refreshLeaderboard();
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with restaurant name
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(3.w),
                        border: Border.all(color: AppColors.accentColor, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dashboard',
                            style: TextStyle(
                              fontSize: 5.w,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentColor,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            widget.restaurantName,
                            style: TextStyle(
                              fontSize: 4.5.w,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                    // Leaderboard Rank (supports fallback lookup)
                    _buildRankCard(user, leaderboardProvider),
                    SizedBox(height: 2.5.h),
                    // Current Score
                    _buildStatCard(
                      title: 'Current Score',
                      value: user.score.toString(),
                      icon: Icons.star,
                      color1: const Color(0xFF4CAF50),
                      color2: const Color(0xFF388E3C),
                    ),
                    SizedBox(height: 2.5.h),
                    // Highest Score
                    _buildStatCard(
                      title: 'Highest Score',
                      value: user.highScore.toString(),
                      icon: Icons.trending_up,
                      color1: const Color(0xFF2196F3),
                      color2: const Color(0xFF1565C0),
                    ),
                    SizedBox(height: 2.5.h),
                    // Remaining Points
                    _buildStatCard(
                      title: 'Remaining Points',
                      value: user.remainingPoints.toString(),
                      icon: Icons.point_of_sale,
                      color1: const Color(0xFFE91E63),
                      color2: const Color(0xFFC2185B),
                    ),
                    SizedBox(height: 3.h),
                    // Top Performers
                    Text(
                      'Top Performers',
                      style: TextStyle(
                        fontSize: 4.5.w,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    _buildLeaderboard(leaderboardProvider),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color1,
    required Color color2,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.w),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color1, color2],
        ),
        boxShadow: [
          BoxShadow(
            color: color1.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 3.5.w,
                  color: AppColors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 6.w,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          Icon(
            icon,
            size: 10.w,
            color: AppColors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboard(LeaderboardProvider leaderboardProvider) {
    if (leaderboardProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    List<UserModel> leaderboard = leaderboardProvider.leaderboard;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: leaderboard.length,
      itemBuilder: (context, index) {
        UserModel user = leaderboard[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 1.5.h),
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(2.5.w),
              border: Border.all(color: AppColors.accentColor, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accentColor,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 4.w,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
                          fontSize: 4.w,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      Text(
                        'Score: ${user.highScore}',
                        style: TextStyle(
                          fontSize: 3.w,
                          color: AppColors.accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.star,
                  color: AppColors.accentColor,
                  size: 5.w,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds the leaderboard rank card; uses cached leaderboard first
  /// and falls back to a database lookup when necessary.
  Widget _buildRankCard(UserModel user, LeaderboardProvider leaderboardProvider) {
    return FutureBuilder<int>(
      future: leaderboardProvider.fetchUserRank(user.uid),
      builder: (context, snapshot) {
        String display;
        if (snapshot.connectionState == ConnectionState.waiting) {
          display = 'Loading...';
        } else if (snapshot.hasError) {
          display = 'N/A';
        } else {
          final rank = snapshot.data ?? -1;
          display = _getRankDisplay(rank);
        }

        return _buildStatCard(
          title: 'Leaderboard Rank',
          value: display,
          icon: Icons.leaderboard,
          color1: const Color(0xFFFFD740),
          color2: const Color(0xFFFBC02D),
        );
      },
    );
  }

  /// Helper method to display rank with appropriate formatting
  String _getRankDisplay(int rank) {
    if (rank == -1) {
      return 'Outside Top 100';
    }
    return '#$rank';
  }
}
