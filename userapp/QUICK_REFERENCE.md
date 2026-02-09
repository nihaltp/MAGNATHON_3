# Quick Reference Guide

## 🚀 Quick Start Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Clean and rebuild
flutter clean && flutter pub get && flutter run

# Build release APK
flutter build apk --release

# View logs
flutter logs

# Check Flutter info
flutter doctor
```

## 📝 Firebase Configuration

### Step 1: Create Firebase Project
1. Go to https://console.firebase.google.com
2. Click "Create a new project"
3. Follow the setup wizard

### Step 2: Enable Authentication
1. In Firebase Console, go to Authentication
2. Click "Sign-in method"
3. Enable "Email/Password"

### Step 3: Create Firestore Database
1. In Firebase Console, go to Firestore Database
2. Click "Create database"
3. Choose "Start in test mode" for development
4. Select location and create

### Step 4: Configure App
```bash
flutterfire configure
```
This will automatically:
- Create `firebase_options.dart`
- Download `google-services.json`
- Configure everything needed

## 🔧 File Updates Needed

### 1. `lib/firebase_options.dart`
If using manual configuration, update:
```dart
// Replace with your credentials
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_API_KEY',
  appId: 'YOUR_APP_ID',
  messagingSenderId: 'YOUR_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  databaseURL: 'YOUR_DATABASE_URL',
  storageBucket: 'YOUR_STORAGE_BUCKET',
);
```

### 2. `android/app/google-services.json`
Download from Firebase Console and place here

### 3. Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    match /users/{userId} {
      allow read: if request.auth != null;
    }
  }
}
```

## 📱 How to Use the App

### Registration
1. Tap "Sign Up" button
2. Enter full name, email, password
3. Confirm password
4. Tap "Sign Up"

### Login
1. Enter email and password
2. Tap "Login"

### Navigation
- **Home**: See 5 restaurant cards
- **Dashboard**: Click any card to see stats
- **Profile**: View user info, QR code, stats

## 🎨 Customizing Colors

File: `lib/config/app_colors.dart`

```dart
class AppColors {
  static const Color primaryDark = Color(0xFF1A237E);    // Deep blue
  static const Color primaryLight = Color(0xFF3F51B5);   // Indigo
  static const Color accentColor = Color(0xFFFFD740);    // Yellow
  // Add more colors as needed
}
```

## 📊 Firestore Collections Structure

### Users Collection
```
/users/{uid}
  ├─ uid: "string"
  ├─ email: "user@example.com"
  ├─ name: "User Name"
  ├─ score: 0
  ├─ highScore: 0
  ├─ remainingPoints: 100
  ├─ profileImageUrl: null
  └─ createdAt: timestamp
```

## 🔑 Important Methods

### AuthService

```dart
// Sign up
await authService.signUp(
  email: 'user@example.com',
  password: 'password',
  name: 'User Name',
);

// Sign in
await authService.signIn(
  email: 'user@example.com',
  password: 'password',
);

// Get current user
UserModel? user = await authService.getCurrentUser();

// Sign out
await authService.signOut();

// Update profile
await authService.updateUserProfile(
  uid: userId,
  name: 'New Name',
);

// Update stats
await authService.updateUserStats(
  uid: userId,
  score: 100,
  highScore: 150,
  remainingPoints: 50,
);
```

### DatabaseService

```dart
// Get user data
UserModel? user = await databaseService.getUserData(uid);

// Stream user data
databaseService.getUserDataStream(uid).listen((user) {
  print('User: ${user?.name}');
});

// Get leaderboard
List<UserModel> leaders = await databaseService.getLeaderboard(limit: 10);

// Stream leaderboard
databaseService.getLeaderboardStream().listen((leaders) {
  print('Leaders updated');
});

// Get user rank
int rank = await databaseService.getUserRank(uid);
```

## 🎯 Page Navigation Flow

```
LoginPage / RegistrationPage
         ↓
    HomePage
    ├─ Home Tab
    │  ├─ Restaurant Card 1
    │  ├─ Restaurant Card 2
    │  ├─ Restaurant Card 3
    │  ├─ Restaurant Card 4
    │  └─ Restaurant Card 5
    │
    ├─ Dashboard Tab
    │  └─ DashboardPage
    │     ├─ Stat Cards
    │     └─ Leaderboard
    │
    └─ Profile Tab
       └─ ProfilePage
          ├─ User Info
          ├─ Stats Grid
          ├─ QR Code
          └─ Edit Profile
```

## 🐛 Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| "google-services.json not found" | Place it in `android/app/` |
| Sizer not working | Ensure wrapped in Sizer in main.dart |
| QR code blank | Check user UID is valid |
| Firebase auth fails | Verify Email/Password is enabled |
| Empty leaderboard | Create test users in Firestore |
| Logout not working | Check signOut() is called |

## 📦 Package Versions

Current versions used:
- `firebase_core: ^2.24.0`
- `firebase_auth: ^4.15.0`
- `cloud_firestore: ^4.14.0`
- `sizer: ^2.0.15`
- `qr_flutter: ^10.0.1`
- `google_fonts: ^6.1.0`
- `cached_network_image: ^3.3.0`

To update packages:
```bash
flutter pub upgrade
```

## 🎨 Widget Customization Examples

### Change Button Color
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.accentColor,
  ),
  child: Text('Button'),
)
```

### Change Text Style
```dart
Text(
  'Hello',
  style: TextStyle(
    fontSize: 5.w,        // Using Sizer
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDark,
  ),
)
```

### Change Container Style
```dart
Container(
  padding: EdgeInsets.all(4.w),
  decoration: BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(3.w),
    boxShadow: [
      BoxShadow(
        color: AppColors.primaryDark.withOpacity(0.2),
        blurRadius: 8,
      ),
    ],
  ),
)
```

## 🚀 Deployment Checklist

- [ ] Update app version in `pubspec.yaml`
- [ ] Update `firebase_options.dart` with production credentials
- [ ] Verify all Firebase rules are set correctly
- [ ] Test all features on physical device
- [ ] Test offline behavior
- [ ] Remove debug print statements
- [ ] Test release build: `flutter build apk --release`
- [ ] Generate signed APK for Play Store
- [ ] Test Play Store upload

## 📞 Useful Links

- Flutter Docs: https://flutter.dev/docs
- Firebase Flutter: https://firebase.flutter.dev
- Firestore Security: https://firebase.google.com/docs/firestore/security
- Dart Packages: https://pub.dev
- Flutter Community: https://flutter.dev/community

## 💡 Pro Tips

1. **Use Hot Reload** during development
   ```bash
   flutter run
   # Press 'r' in terminal for hot reload
   # Press 'R' for hot restart
   ```

2. **Debug Streams** with print statements
   ```dart
   stream: databaseService.getUserDataStream(uid)
     .map((user) {
       print('User updated: ${user?.name}');
       return user;
     })
   ```

3. **Test with Firebase Emulator** for faster development
   ```bash
   firebase emulators:start
   ```

4. **Create Test Users** directly in Firebase Console for testing

5. **Use Firestore Database Rules Testing** in console

---

**Version**: 1.0  
**Last Updated**: Feb 2026  
**Status**: Ready for Development ✅
