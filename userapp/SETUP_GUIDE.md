# Restaurant Rewards App

A beautiful Flutter application for Android with Firebase integration featuring user authentication, profile management, dashboard with leaderboards, and QR code generation.

## Features

✨ **Authentication**
- User registration and login with Firebase Authentication
- Secure password handling with visibility toggle
- Email validation
- Session management

🏠 **Home Page**
- Beautiful restaurant card carousel (5 restaurants)
- Tap cards to view individual restaurant dashboards
- Smooth navigation with attractive UI

📊 **Dashboard**
- Current leaderboard rank
- Current score display
- Highest score tracking
- Remaining points display
- Top 5 performers leaderboard
- Real-time data from Firebase

👤 **Profile Page**
- User information display (name, email)
- Profile stats grid (Score, High Score, Points, Member Since)
- QR code generation linking to user ID
- Edit profile functionality
- Logout option

🎨 **Design**
- Gradient backgrounds with primary/light colors
- Accent color highlights (#FFD740)
- Responsive design using Sizer package
- Material Design 3 components
- Smooth animations and transitions

## Project Structure

```
lib/
├── config/
│   └── app_colors.dart          # Color configuration
├── models/
│   ├── user_model.dart          # User data model
│   └── restaurant_model.dart    # Restaurant data model
├── services/
│   ├── auth_service.dart        # Firebase Authentication
│   └── database_service.dart    # Firestore Database operations
├── screens/
│   ├── auth/
│   │   ├── login_page.dart
│   │   └── registration_page.dart
│   ├── home/
│   │   ├── home_page.dart
│   │   └── dashboard_page.dart
│   └── profile/
│       └── profile_page.dart
├── main.dart                    # App entry point
└── firebase_options.dart        # Firebase configuration
```

## Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Android SDK
- Firebase project setup

### Installation

1. **Clone the repository**
   ```bash
   cd userapp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup Firebase**

   **Option A: Using FlutterFire CLI**
   ```bash
   flutterfire configure
   ```
   This will automatically generate the `firebase_options.dart` file.

   **Option B: Manual Setup**

   a. Add your Firebase credentials to `lib/firebase_options.dart`
   
   b. For Android, download `google-services.json` from Firebase Console and place it in `android/app/`
   
   c. For iOS, download `GoogleService-Info.plist` and add it to `ios/Runner/`

4. **Run the app**
   ```bash
   flutter run
   ```

## Firebase Setup

### Create Firestore Collections

1. **users** collection with the following structure:
   ```
   {
     "uid": "user_id",
     "email": "user@example.com",
     "name": "User Name",
     "score": 0,
     "highScore": 0,
     "remainingPoints": 100,
     "profileImageUrl": null,
     "createdAt": timestamp
   }
   ```

### Firebase Rules (Firestore)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read: if request.auth.uid == userId;
      allow update: if request.auth.uid == userId;
      allow create: if request.auth.uid == userId;
    }
    // All authenticated users can read all user data for leaderboard
    match /users/{anyUser} {
      allow read: if request.auth != null;
    }
  }
}
```

### Firebase Authentication Rules

Enable these providers in Firebase Console:
- Email/Password authentication

## Color Scheme

- **Primary Dark**: `#1A237E`
- **Primary Light**: `#3F51B5`
- **Accent Color**: `#FFD740`

## Dependencies

- **firebase_core**: ^2.24.0
- **firebase_auth**: ^4.15.0
- **cloud_firestore**: ^4.14.0
- **firebase_storage**: ^11.5.0
- **sizer**: ^2.0.15 (Responsive sizing)
- **qr_flutter**: ^10.0.1 (QR code generation)
- **google_fonts**: ^6.1.0
- **cached_network_image**: ^3.3.0

## Usage

### User Registration
1. Tap "Sign Up" on the login screen
2. Enter full name, email, and password
3. Confirm password and submit
4. User is automatically redirected to home page

### Login
1. Enter email and password
2. Tap "Login"
3. Redirected to home page on success

### Navigate to Dashboard
1. On home page, tap any restaurant card
2. View the specific restaurant's dashboard
3. See leaderboard, scores, and stats

### View Profile
1. Tap the profile icon in the bottom navigation
2. View user information and stats
3. See your QR code (shares your user ID)
4. Tap "Edit Profile" to update name

## Important Notes

1. **Firebase Options**: Replace placeholder values in `lib/firebase_options.dart` with your actual Firebase credentials
2. **Google Services**: Ensure `android/app/google-services.json` is properly configured
3. **Firestore Rules**: Configure proper security rules in Firebase Console
4. **User Points**: Initial points are set to 100. Modify in `auth_service.dart` if needed

## Building for Release

```bash
flutter build apk --release
```

or

```bash
flutter build appbundle --release
```

## Troubleshooting

### Firebase Connection Issues
- Verify `google-services.json` is in `android/app/`
- Check Firebase Console for enabled services
- Ensure app package name matches Firebase project

### Sizer Not Responsive
- Run `flutter clean` and `flutter pub get`
- Ensure Sizer is properly initialized in main.dart

### QR Code Not Displaying
- Verify `qr_flutter` package is installed
- Check that user data is properly fetched from Firebase

## Future Enhancements

- Points system implementation
- Restaurant-specific scoring
- Social features
- Push notifications
- Offline data sync
- Image upload for profiles
- Advanced analytics

## License

This project is private and confidential.

## Support

For issues or questions, contact the development team.
