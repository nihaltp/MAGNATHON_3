# 🍽️ Restaurant Rewards Flutter App

A beautiful, production-ready Flutter application for Android with complete Firebase integration, featuring user authentication, dynamic dashboards, leaderboards, and user profiles with QR code generation.

## 🌟 Features

### 🔐 Authentication System
- **User Registration** with email validation and password confirmation
- **User Login** with secure credential handling
- **Session Management** with Firebase Auth
- **Automatic Logout** option from profile page
- Password visibility toggle for better UX

### 🏠 Home Page
- **Welcome Header** with user greeting and logout button
- **5 Interactive Restaurant Cards** featuring:
  - Restaurant name and description
  - Emoji icons for visual appeal
  - "View Dashboard" call-to-action button
  - Smooth tap animations
- **Vertical Scrollable List** of restaurants
- **Responsive Design** that adapts to all screen sizes

### 📊 Dynamic Dashboard
- **Leaderboard Rank** - User's current position
- **Current Score** - Active score display
- **Highest Score** - Personal best tracking
- **Remaining Points** - Available points display
- **Top 5 Leaderboard** showing:
  - Rank position with badge
  - User name
  - High score
  - Real-time updates from Firebase

### 👤 User Profile
- **User Information Display**
  - Profile avatar with icon
  - Full name
  - Email address
- **Statistics Grid** (2x2)
  - Current Score with star icon
  - Highest Score with trending icon
  - Remaining Points with points icon
  - Member Since date with calendar icon
- **QR Code Section**
  - Generates QR code from user UID
  - Scannable user ID representation
  - Perfect for user identification
- **Profile Management**
  - Edit profile button
  - Update user name functionality
  - Logout option with confirmation dialog

### 🧭 Navigation
- **Floating Bottom Navigation Bar**
  - Home, Dashboard, and Profile tabs
  - Active/inactive state indicators
  - Persistent across all screens
  - Shadow effects for depth

### 🎨 Beautiful UI
- **Color Scheme**
  - Primary Dark: #1A237E (Deep Blue)
  - Primary Light: #3F51B5 (Indigo)
  - Accent: #FFD740 (Yellow-Gold)
- **Gradient Backgrounds** for modern aesthetic
- **Responsive Components** using Sizer package
- **Material Design 3** components
- **Smooth Animations** and transitions
- **Box Shadows** for depth and hierarchy

## 📱 Technical Architecture

### Technology Stack
- **Framework**: Flutter 3.8.1+
- **Backend**: Firebase (Auth + Firestore)
- **Database**: Cloud Firestore
- **Authentication**: Firebase Authentication
- **UI Package**: Sizer (responsive design)
- **QR Code**: qr_flutter

### Project Structure
```
lib/
├── config/
│   └── app_colors.dart              # Color configuration
├── models/
│   ├── user_model.dart              # User data model with serialization
│   └── restaurant_model.dart        # Restaurant data model
├── data/
│   └── restaurant_data.dart         # Static restaurant list
├── services/
│   ├── auth_service.dart            # Firebase Auth & user management
│   └── database_service.dart        # Firestore operations
├── screens/
│   ├── auth/
│   │   ├── login_page.dart          # Login UI
│   │   └── registration_page.dart   # Registration UI
│   ├── home/
│   │   ├── home_page.dart           # Home with restaurant cards
│   │   └── dashboard_page.dart      # Stats dashboard
│   └── profile/
│       └── profile_page.dart        # User profile with QR code
├── main.dart                        # App entry point
└── firebase_options.dart            # Firebase configuration (template)
```

### Data Flow Architecture
```
AuthWrapper (StreamBuilder)
    ├─ Monitors Firebase Auth State
    ├─ If Not Logged In → LoginPage
    └─ If Logged In → HomePage
        ├─ Home Page (Streams User Data)
        ├─ Dashboard (Real-time Leaderboard)
        └─ Profile (User Info + QR Code)
            └─ Firestore Collections
                └─ /users/{uid}
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Android SDK
- Firebase account and project
- Dart 3.0+

### Installation Steps

1. **Navigate to project**
   ```bash
   cd c:\Hackathon\Magnathon\userapp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   
   **Recommended - Using FlutterFire CLI:**
   ```bash
   flutterfire configure
   ```
   This automatically generates `firebase_options.dart` and downloads `google-services.json`
   
   **Alternative - Manual Setup:**
   - Update `lib/firebase_options.dart` with your Firebase credentials
   - Download `google-services.json` from Firebase Console
   - Place it in `android/app/` directory

4. **Run the app**
   ```bash
   flutter run
   ```

## 🔥 Firebase Setup Guide

### 1. Create Firebase Project
1. Visit https://console.firebase.google.com
2. Click "Create Project"
3. Enter project name and follow wizard
4. Wait for project initialization

### 2. Enable Authentication
1. Go to **Authentication** section
2. Click **Sign-in method**
3. Enable **Email/Password** provider
4. Save changes

### 3. Create Firestore Database
1. Go to **Firestore Database** section
2. Click **Create database**
3. Choose **Start in test mode** (for development)
4. Select region and create
5. Navigate to **Rules** tab
6. Update rules (see section below)

### 4. Update Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own profile
    match /users/{userId} {
      allow read: if request.auth.uid == userId;
      allow create: if request.auth.uid == userId;
      allow update: if request.auth.uid == userId;
    }
    
    // All authenticated users can read user data (for leaderboard)
    match /users/{anyUserId} {
      allow read: if request.auth != null;
    }
  }
}
```

### 5. Configure App
```bash
# Using FlutterFire CLI (Recommended)
flutterfire configure

# Select Android platform
# Follow the prompts
```

## 🎮 How to Use

### User Workflow

**1. Registration**
```
LoginPage → "Sign Up" Button
         → RegistrationPage
         → Enter: Name, Email, Password
         → Confirm Password
         → Tap "Sign Up"
         → Automatic redirect to HomePage
```

**2. Login**
```
LoginPage → Enter Email & Password
        → Tap "Login"
        → Navigate to HomePage
```

**3. Explore Restaurants**
```
HomePage → See 5 restaurant cards
       → Tap any card
       → View restaurant-specific dashboard
```

**4. Check Dashboard**
```
Dashboard → View Leaderboard Rank
        → See Current Score
        → View Highest Score
        → Check Remaining Points
        → Explore Top Performers
```

**5. Manage Profile**
```
ProfilePage → View user info
           → See stats grid
           → Scan QR code
           → Edit profile (change name)
           → Logout
```

## 🎨 Customization

### Change Color Scheme
Edit `lib/config/app_colors.dart`:
```dart
class AppColors {
  static const Color primaryDark = Color(0xFF1A237E);    // Your color here
  static const Color primaryLight = Color(0xFF3F51B5);   // Your color here
  static const Color accentColor = Color(0xFFFFD740);    // Your color here
}
```

### Add More Restaurants
Edit `lib/data/restaurant_data.dart`:
```dart
{
  'id': '6',
  'name': 'Restaurant 6',
  'description': 'Your description',
  'icon': '🍔',  // Use any emoji
}
```

### Modify Initial User Points
Edit `lib/services/auth_service.dart`, find `signUp` method:
```dart
remainingPoints: 100,  // Change this value
```

### Update Restaurant Count
In `lib/screens/home/home_page.dart`, modify:
```dart
final List<Map<String, String>> restaurants = [
  // Add or remove restaurant entries here
];
```

## 📊 Firestore Database Structure

### Users Collection
```
Collection: users
  └─ Document: {uid}
     ├─ uid (string): User ID from Firebase Auth
     ├─ email (string): User email
     ├─ name (string): User's full name
     ├─ score (number): Current score
     ├─ highScore (number): Highest score achieved
     ├─ remainingPoints (number): Available points
     ├─ profileImageUrl (string): Optional profile image URL
     └─ createdAt (timestamp): Account creation date
```

### Example Document
```json
{
  "uid": "abc123xyz",
  "email": "user@example.com",
  "name": "John Doe",
  "score": 150,
  "highScore": 500,
  "remainingPoints": 75,
  "profileImageUrl": null,
  "createdAt": "2024-02-09T10:30:00Z"
}
```

## 🔑 Key Features Explained

### Real-time Updates
- Dashboard and profile use Firestore streams
- Changes appear instantly across all screens
- Automatic refresh without manual reload

### Leaderboard System
- Top 5 performers displayed on dashboard
- Sorted by highest score
- Real-time rank calculation
- User's rank shown prominently

### QR Code Generation
- Encodes user's Firebase UID
- Scannable with any QR code app
- Allows user identification
- Static - doesn't change per user

### Responsive Design
- Uses Sizer for all measurements
- Works on phones and tablets
- Adapts to landscape/portrait orientation
- Pixel-perfect on all screen sizes

## 🧪 Testing Guide

### Test Registration
1. Launch app → See LoginPage
2. Tap "Sign Up"
3. Enter: Name, Email, Password
4. Confirm password
5. Tap "Sign Up"
6. Check Firestore for new user document

### Test Login
1. Enter registered email
2. Enter password
3. Tap "Login"
4. Should navigate to HomePage

### Test Navigation
1. Tap restaurant cards
2. Verify dashboard shows correct restaurant name
3. Switch between Home/Dashboard/Profile tabs

### Test Stats
1. View Dashboard
2. Verify all 4 stats load correctly
3. Scroll to see leaderboard

### Test Profile
1. Open Profile tab
2. Verify user info displays
3. View QR code
4. Try scanning QR code with phone
5. Test "Edit Profile" button

## 🐛 Troubleshooting

| Problem | Solution |
|---------|----------|
| App crashes on startup | Check firebase_options.dart has correct credentials |
| Google Services not found | Ensure android/app/google-services.json exists |
| Firestore connection fails | Verify Firestore database is created and rules are set |
| QR code is blank | Ensure user UID is fetched from Firebase |
| Sizer not working | Run `flutter clean && flutter pub get` |
| Stats show 0 | Add test data directly to Firestore |
| Leaderboard is empty | Create multiple test users in Firebase |

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.0           # Firebase initialization
  firebase_auth: ^4.15.0           # Authentication
  cloud_firestore: ^4.14.0         # Database
  firebase_storage: ^11.5.0        # File storage
  sizer: ^2.0.15                   # Responsive sizing
  qr_flutter: ^10.0.1              # QR code generation
  google_fonts: ^6.1.0             # Font library
  cached_network_image: ^3.3.0     # Image caching
  cupertino_icons: ^1.0.8          # iOS style icons
```

## 🚢 Building for Release

### Build APK
```bash
flutter build apk --release
```

### Build App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

### Signed APK
1. Create keystore file
2. Update `android/key.properties`
3. Build: `flutter build apk --release`

## 📋 Deployment Checklist

- [ ] Update app version in `pubspec.yaml`
- [ ] Use production Firebase credentials
- [ ] Update Firestore security rules
- [ ] Test all features on real device
- [ ] Verify offline behavior
- [ ] Remove debug print statements
- [ ] Test release build locally
- [ ] Prepare app signing certificate
- [ ] Create app listing on Play Store
- [ ] Upload APK/Bundle
- [ ] Test on Play Store staging environment

## 💡 Best Practices Implemented

✅ **State Management**: StreamBuilder for real-time data  
✅ **Error Handling**: Try-catch blocks with user feedback  
✅ **Code Organization**: Modular structure with separation of concerns  
✅ **Responsive Design**: Sizer package for all dimensions  
✅ **Security**: Firebase security rules and auth validation  
✅ **User Experience**: Loading indicators and error messages  
✅ **Code Quality**: Type safety and null safety throughout  
✅ **Performance**: Efficient database queries and caching  

## 📚 Documentation Files

- **SETUP_GUIDE.md** - Detailed setup instructions
- **IMPLEMENTATION_GUIDE.md** - In-depth implementation details
- **QUICK_REFERENCE.md** - Quick command and code reference
- **README.md** - This file (project overview)

## 🤝 Contributing

When adding new features:
1. Follow existing code structure
2. Use Sizer for all dimensions
3. Add error handling
4. Update documentation
5. Test on multiple screen sizes

## 📞 Support

For issues, refer to:
- Flutter Documentation: https://flutter.dev
- Firebase Documentation: https://firebase.flutter.dev
- Package Documentation: https://pub.dev

## 📄 License

This project is private and confidential.

## 🎯 Project Status

✅ **Version**: 1.0.0  
✅ **Status**: Production Ready  
✅ **Last Updated**: February 2026  
✅ **Flutter Version**: 3.8.1+  
✅ **All Features**: Implemented and Tested  

---

**Ready to build something amazing!** 🚀
