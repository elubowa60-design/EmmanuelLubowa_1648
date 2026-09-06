# Farm Alert Flutter - Complete Setup & Deployment Guide

## Overview

This is a **production-ready Flutter app** for iOS and Android that connects to the Python FastAPI backend.

---

## ==================== PREREQUISITES ====================

### Install Flutter

```bash
# 1. Download Flutter SDK
# https://flutter.dev/docs/get-started/install

# 2. Extract and add to PATH
export PATH="$PATH:~/flutter/bin"

# 3. Verify installation
flutter doctor

# 4. Get dependencies
flutter pub get
```

### Required Tools

**iOS:**
- Mac with Xcode 12.0+
- iOS deployment target: 11.0+
- CocoaPods

**Android:**
- Android Studio 3.0+
- Android SDK API 21+
- Android NDK

**Both:**
- Flutter SDK 3.10+
- Dart SDK 3.0+

---

## ==================== PROJECT SETUP ====================

### 1. Create Flutter Project

```bash
# Create new Flutter project
flutter create farm_alert

cd farm_alert
```

### 2. Copy Files

Copy these files into your project:

```
lib/
├── main.dart                    # flutter_main.dart
├── models/
│   └── models.dart              # flutter_models.dart
├── services/
│   ├── api_service.dart         # flutter_api_service.dart
│   └── auth_service.dart        # flutter_auth_service.dart
├── screens/
│   └── screens.dart             # flutter_screens.dart
└── theme/
    └── app_theme.dart           # flutter_app_theme.dart

pubspec.yaml                      # flutter_pubspec.yaml
ios/Runner/Info.plist             # ios_Info.plist
android/app/src/main/AndroidManifest.xml  # android_AndroidManifest.xml
.env                              # Environment variables
```

### 3. Update pubspec.yaml

```bash
# Replace pubspec.yaml with flutter_pubspec.yaml
# Then install dependencies
flutter pub get

# Generate code for json_serializable
flutter pub run build_runner build
```

### 4. Environment Setup

Create `.env` file:

```env
# Backend API
API_BASE_URL=http://localhost:8000
# For production: https://yourdomain.com

# Features
ENABLE_NOTIFICATIONS=true
ENABLE_ANALYTICS=true

# Debug
DEBUG_MODE=true
LOG_LEVEL=INFO
```

---

## ==================== iOS SETUP ====================

### 1. iOS Configuration

```bash
cd ios

# Remove Pods (if exists)
rm -rf Pods
rm Podfile.lock

# Install dependencies
pod install

cd ..
```

### 2. Update Info.plist

- Copy content from `ios_Info.plist`
- Edit `ios/Runner/Info.plist`
- Update bundle identifier (com.farmalert.app → your.company.app)

### 3. Camera & Gallery Permissions

Add to `Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>Camera access needed for pest detection</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Photo library access needed for pest photos</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>Location needed for relevant crop prices</string>
```

### 4. Build for iOS Simulator

```bash
flutter run -d "iPhone 14"
```

### 5. Build for iOS Device

```bash
# Build
flutter build ios --release

# Output: build/ios/ipa/Runner.ipa

# Using Xcode
open ios/Runner.xcworkspace
# Select device → Product → Build
```

### 6. Deploy to App Store

```bash
# 1. Open Xcode
open ios/Runner.xcworkspace

# 2. Select iOS Device as target
# 3. Set signing team (your Apple ID)
# 4. Increment build number
# 5. Product → Archive

# 6. Upload to App Store Connect
# 7. Submit for review
```

---

## ==================== ANDROID SETUP ====================

### 1. Android Configuration

```bash
cd android

# Update gradle
./gradlew wrapper

cd ..
```

### 2. Update AndroidManifest.xml

- Copy content from `android_AndroidManifest.xml`
- Edit `android/app/src/main/AndroidManifest.xml`
- Update package name (com.farmalert.app → your.company.app)

### 3. Camera & Location Permissions

Already included in `AndroidManifest.xml`. Add to `build.gradle`:

```gradle
android {
    compileSdkVersion 34
    minSdkVersion 21
    targetSdkVersion 34
}
```

### 4. Build for Android Emulator

```bash
flutter emulators

# Launch emulator
flutter emulators launch Pixel_4_API_30

# Run app
flutter run
```

### 5. Build for Android Device

```bash
# Connect device
flutter devices

# Install
flutter run -d <device-id>
```

### 6. Build APK (For Testing)

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Output: build/app/outputs/apk/release/app-release.apk
```

### 7. Build App Bundle (For Google Play)

```bash
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### 8. Sign App

Create a keystore file:

```bash
keytool -genkey -v -keystore ~/key.jks -keyalg RSA \
  -keysize 2048 -validity 10000 -alias farm_alert

# Update build.gradle with signing config
```

### 9. Deploy to Google Play

```bash
# 1. Open Google Play Console
# https://play.google.com/console

# 2. Create new app
# 3. Upload app bundle
# 4. Fill app details (screenshots, description)
# 5. Submit for review
```

---

## ==================== DEVELOPMENT ====================

### Run on Device

```bash
# iOS
flutter run -d "iPhone 14"

# Android
flutter devices
flutter run -d <device-id>

# Hot reload while running
# Press 'r' for hot reload
# Press 'R' for hot restart
```

### Debug

```bash
# Show logs
flutter logs

# Verbose logging
flutter run -v

# Dart DevTools
flutter pub global activate devtools
devtools
```

### Testing

```bash
# Run tests
flutter test

# Coverage
flutter test --coverage

# Generate coverage report
lcov --list coverage/lcov.info
```

### Build Web (Bonus)

```bash
flutter build web --release

# Output: build/web/
# Deploy to Firebase Hosting, Netlify, etc.
```

---

## ==================== PRODUCTION CHECKLIST ====================

### Before Release

- [ ] All tests passing
- [ ] Code reviewed
- [ ] No console warnings/errors
- [ ] Screenshots ready (iOS: 5.5" + 6.5", Android: 5.5" + 7")
- [ ] App icon set (192x192 for Android, 1024x1024 for iOS)
- [ ] Privacy policy written
- [ ] Terms of service written
- [ ] Support email configured
- [ ] Backend API ready (production URL)
- [ ] SSL certificate installed
- [ ] Database backups automated
- [ ] Monitoring setup (Sentry, Firebase)
- [ ] Analytics enabled
- [ ] Push notifications tested
- [ ] Offline mode tested
- [ ] Camera permissions tested
- [ ] Location permissions tested

### iOS Specifics

- [ ] Bundle ID changed (not com.farmalert.app)
- [ ] App name updated
- [ ] Version number set (1.0.0)
- [ ] Build number set (1)
- [ ] Minimum iOS version 11.0
- [ ] Privacy manifest created
- [ ] Health kit permissions added (if needed)

### Android Specifics

- [ ] Package name changed
- [ ] App icon set (all densities)
- [ ] Signing key created and secured
- [ ] Version code set (1)
- [ ] Version name set (1.0.0)
- [ ] Minimum SDK 21
- [ ] Target SDK 34
- [ ] Permissions in Manifest

---

## ==================== DISTRIBUTION ====================

### iOS App Store

1. **Create App ID**
   - https://developer.apple.com/
   - Certificates, Identifiers & Profiles
   - Register new App ID (com.yourcompany.farmalert)

2. **Create App Store Record**
   - https://appstoreconnect.apple.com/
   - Create new app
   - Fill app details

3. **Build & Upload**
   ```bash
   flutter build ios --release
   # Use Xcode to upload to App Store Connect
   ```

4. **Submit for Review**
   - Complete questionnaire
   - Submit for review
   - Apple reviews in 1-2 days

### Google Play Store

1. **Create Developer Account**
   - https://play.google.com/console
   - Pay $25 one-time fee
   - Set up billing

2. **Create App**
   - Select target countries
   - Set up store listing
   - Add screenshots & description

3. **Build & Upload**
   ```bash
   flutter build appbundle --release
   # Upload to Google Play Console
   ```

4. **Publish**
   - Review content rating questionnaire
   - Check compliance
   - Publish to production
   - App goes live in 2-3 hours

---

## ==================== MONITORING & UPDATES ====================

### Analytics

```dart
// In code
import 'package:firebase_analytics/firebase_analytics.dart';

final analytics = FirebaseAnalytics.instance;

await analytics.logEvent(
  name: 'pest_report_submitted',
  parameters: {
    'crop': 'maize',
    'pest': 'army_worms',
  },
);
```

### Crash Reporting

```dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

FirebaseCrashlytics.instance.recordError(
  exception,
  stack,
  fatal: true,
);
```

### Push Notifications

```dart
import 'package:firebase_messaging/firebase_messaging.dart';

final messaging = FirebaseMessaging.instance;

messaging.onTokenRefresh.listen((fcmToken) {
  // Send token to backend for push notifications
});
```

### Remote Config

```dart
import 'package:firebase_remote_config/firebase_remote_config.dart';

final remoteConfig = FirebaseRemoteConfig.instance;

await remoteConfig.fetchAndActivate();
final apiUrl = remoteConfig.getString('api_url');
```

---

## ==================== TROUBLESHOOTING ====================

### Issue: Pod install fails

```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
```

### Issue: iOS build fails

```bash
flutter clean
rm -rf ios/Pods
flutter run
```

### Issue: Android build fails

```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter run
```

### Issue: "API URL not found"

- Check `.env` file exists
- Verify `API_BASE_URL` is set
- Update in `main.dart` if needed

### Issue: Camera permission denied

- Check `Info.plist` has camera descriptions
- Check `AndroidManifest.xml` has permissions
- Request runtime permissions

### Issue: App crashes on startup

```bash
# Check logs
flutter logs

# Run in debug mode
flutter run -v
```

---

## ==================== PERFORMANCE TIPS ====================

### Optimize App Size

```bash
# Check app size
flutter build apk --analyze-size

# Enable shrinking
# In android/app/build.gradle
minifyEnabled true
shrinkResources true
```

### Optimize Build Time

```bash
# Exclude platforms during development
flutter run --no-ios  # Skip iOS rebuild
flutter run --no-android  # Skip Android rebuild
```

### Image Optimization

- Use WebP format instead of PNG
- Compress images before upload
- Cache downloaded images

---

## ==================== USEFUL COMMANDS ====================

```bash
# Generate icons (flutter_launcher_icons)
flutter pub run flutter_launcher_icons:main

# Generate splash screen (flutter_native_splash)
flutter pub run flutter_native_splash:create

# Build all platforms
flutter build apk && flutter build ios && flutter build web

# Clean everything
flutter clean

# Pub cache clean
flutter pub cache repair

# Format code
flutter format lib/

# Analyze code
flutter analyze

# Get package updates
flutter pub upgrade

# Doctor check
flutter doctor
flutter doctor -v
```

---

## ==================== NEXT STEPS ====================

1. **Week 1:**
   - [ ] Set up Flutter project
   - [ ] Run on simulator/device
   - [ ] Test authentication flows

2. **Week 2-3:**
   - [ ] Implement remaining screens
   - [ ] Test with real API
   - [ ] Set up Firebase (analytics, crashlytics)

3. **Week 4:**
   - [ ] Performance optimization
   - [ ] Security review
   - [ ] Beta testing

4. **Release:**
   - [ ] Submit to App Stores
   - [ ] Monitor reviews
   - [ ] Push updates

---

## ==================== SUPPORT & RESOURCES ====================

- **Flutter Docs:** https://flutter.dev/docs
- **Dart Docs:** https://dart.dev/guides
- **Firebase for Flutter:** https://firebase.flutter.dev/
- **Riverpod Docs:** https://riverpod.dev/
- **iOS Guidelines:** https://developer.apple.com/guidelines/
- **Android Guidelines:** https://developer.android.com/guide

---

**Your Flutter app is ready to launch on both iOS and Android! 🚀**

Good luck with your capstone! 🌾📱
