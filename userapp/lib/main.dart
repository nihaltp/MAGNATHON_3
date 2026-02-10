import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:userapp/config/app_colors.dart';
import 'package:userapp/services/auth_service.dart';
import 'package:userapp/providers/user_provider.dart';
import 'package:userapp/providers/leaderboard_provider.dart';
import 'package:userapp/screens/auth/login_page.dart';
import 'package:userapp/screens/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LeaderboardProvider()),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            title: 'Restaurant Rewards',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryDark),
              useMaterial3: true,
            ),
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  String? _lastUserId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            // User is logged out - clear providers
            _lastUserId = null;
            context.read<UserProvider>().clearUser();
            context.read<LeaderboardProvider>().clear();
            return const LoginPage();
          } else {
            // User is logged in
            final userId = snapshot.data!.uid;
            
            // Only load if user ID changed
            if (_lastUserId != userId) {
              _lastUserId = userId;
              print('AuthWrapper: User logged in with uid: $userId, triggering load');
              
              // Ensure providers are loaded before Consumer renders
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final userProvider = context.read<UserProvider>();
                final leaderboardProvider = context.read<LeaderboardProvider>();
                
                if (userProvider.user == null) {
                  print('AuthWrapper: Loading user and leaderboard data');
                  userProvider.loadUser(userId);
                  leaderboardProvider.loadLeaderboard();
                }
              });
            }
            
            // Show home page with loading state
            return Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                print('AuthWrapper: Rendering Consumer - isLoading=${userProvider.isLoading}, user=${userProvider.user?.name}');
                
                // Show loading while fetching
                if (userProvider.isLoading) {
                  print('AuthWrapper: Data is loading...');
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                
                // If we have user data, show home page
                if (userProvider.user != null) {
                  print('AuthWrapper: User data loaded, showing HomePage');
                  return const HomePage();
                }
                
                // If not loading and no user, show home page (it will display error UI)
                print('AuthWrapper: No user data available, showing HomePage for error handling');
                return const HomePage();
              },
            );
          }
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
