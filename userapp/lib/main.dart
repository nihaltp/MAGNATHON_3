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
              // Load immediately (context.read is safe for one-time operations)
              context.read<UserProvider>().loadUser(userId);
              context.read<LeaderboardProvider>().loadLeaderboard();
            }
            
            // Show home page only after user data is loaded
            return Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                // Always show loading while data is being fetched OR if user is null
                if (userProvider.isLoading || (userProvider.user == null)) {
                  // If we have an error and show the error UI, don't show loading
                  if (userProvider.user == null && !userProvider.isLoading && userProvider.error != null) {
                    // Show error UI - HomePage will handle this
                    return const HomePage();
                  }
                  // Show loading
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                
                // User data is loaded, show home page
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
