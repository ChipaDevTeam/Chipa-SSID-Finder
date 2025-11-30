# 🚀 Quick Reference Guide

## Run Commands

```bash
# Run on Android
flutter run

# Run on iOS  
flutter run -d ios

# Run on Chrome (UI testing only)
flutter run -d chrome

# Run on macOS
flutter run -d macos

# Use the quick launch script
./run.sh
```

## File Structure Quick Reference

```
lib/
├── main.dart                           # App entry, theme config
├── models/
│   └── trading_platform.dart           # Platform definitions (EDIT HERE to customize)
└── screens/
    ├── platform_selector_screen.dart   # Home screen
    └── webview_screen.dart             # WebView + cookie extraction
```

## Customization Cheat Sheet

### Add/Edit Platform
**File:** `lib/models/trading_platform.dart`

```dart
TradingPlatform(
  name: 'platformid',           // Internal ID
  displayName: 'Display Name',  // UI label
  url: 'https://example.com',   // Login URL
  cookieKey: 'access_token',    // Cookie to find
  colors: [0xFF6B46C1, 0xFF9333EA], // [startColor, endColor]
),
```

### Change Theme Colors
**File:** `lib/main.dart`

```dart
ColorScheme.fromSeed(
  seedColor: const Color(0xFF6B46C1), // Main app color
  brightness: Brightness.light,        // or .dark
),
```

## Common Commands

```bash
# Get dependencies
flutter pub get

# Clean build
flutter clean

# Update dependencies
flutter pub upgrade

# Check for issues
flutter doctor

# See available devices
flutter devices

# Build APK (Android)
flutter build apk

# Build iOS
flutter build ios

# Format code
flutter format .

# Analyze code
flutter analyze
```

## Debugging

```bash
# Run with verbose logging
flutter run -v

# Hot reload (when app is running)
Press 'r' in terminal

# Hot restart (when app is running)
Press 'R' in terminal

# Clear data and restart
Press 'C' in terminal

# Quit app
Press 'q' in terminal
```

## Platform-Specific Setup

### Android
- Minimum SDK: 21
- Target SDK: 34
- Internet permission: ✅ Already configured
- Cleartext traffic: ✅ Enabled

### iOS
- Minimum iOS: 12.0
- App Transport Security: ✅ Configured
- WebView support: ✅ Enabled

## Cookie Keys Reference

All platforms currently use: `access_token`

To change for a specific platform:
```dart
cookieKey: 'your_cookie_name_here',
```

Common cookie names in trading platforms:
- `access_token`
- `session_token`
- `auth_token`
- `bearer_token`
- `ssid`
- `jwt`

## Gradient Colors Reference

Current platform colors:
```dart
OlympTrade:     [0xFF6B46C1, 0xFF9333EA] // Purple
PocketOptions:  [0xFF3B82F6, 0xFF1D4ED8] // Blue
Quotex:         [0xFF10B981, 0xFF059669] // Green
Binomo:         [0xFFF59E0B, 0xFFD97706] // Amber
IqOptions:      [0xFFEF4444, 0xFFDC2626] // Red
Expert Options: [0xFF8B5CF6, 0xFF7C3AED] // Violet
GmGn:           [0xFF06B6D4, 0xFF0891B2] // Cyan
AxiomTrade:     [0xFFEC4899, 0xFFDB2777] // Pink
```

Color format: `0xFFRRGGBB`
- FF = Alpha (opacity)
- RR = Red
- GG = Green
- BB = Blue

## Dependencies

```yaml
flutter_inappwebview: ^6.0.0     # WebView with cookie access
shared_preferences: ^2.2.2       # Local storage
cupertino_icons: ^1.0.2          # iOS icons
```

## Testing Checklist

- [ ] App launches successfully
- [ ] All 8 platforms visible
- [ ] Cards have unique colors
- [ ] Animations work smoothly
- [ ] Tap platform opens WebView
- [ ] Website loads correctly
- [ ] Can log in to platform
- [ ] SSID detected after login
- [ ] Bottom sheet appears
- [ ] Can copy SSID
- [ ] Copy & Close works
- [ ] Returns to home screen

## Troubleshooting Quick Fixes

### "SDK not found"
```bash
flutter doctor
```

### "Gradle sync failed" (Android)
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### "Pod install failed" (iOS)
```bash
cd ios
pod repo update
pod install
cd ..
```

### "Dependencies conflict"
```bash
flutter pub get --verbose
```

### "WebView not working"
Check AndroidManifest.xml has:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
android:usesCleartextTraffic="true"
```

### "Cookies not detected"
- Ensure user is actually logged in
- Check if cookie name is correct in platform model
- Try refreshing the page after login
- Check browser dev tools for actual cookie name

## Performance Tips

1. **Keep WebView simple** - Avoid unnecessary reloads
2. **Check cookies efficiently** - Only on navigation events
3. **Use const constructors** - Already implemented for performance
4. **Minimize rebuilds** - State management is optimized

## Security Notes

- ✅ No credentials stored
- ✅ Cookies only extracted, not modified
- ✅ SSID only in memory
- ✅ HTTPS enforced where possible
- ⚠️ User responsible for SSID security after copying

## Next Steps After Setup

1. **Test OlympTrade** (fully implemented)
2. **Test other platforms** (verify URLs and cookie names)
3. **Adjust cookie keys** if needed for specific platforms
4. **Customize colors** to match your brand
5. **Add features** (history, multiple accounts, etc.)

## Support Resources

- **Flutter Docs**: https://docs.flutter.dev
- **InAppWebView Docs**: https://inappwebview.dev
- **Material Design**: https://m3.material.io

## Quick Edits

### Change App Name
- `pubspec.yaml`: Change `name: ssid_finder`
- Android: `AndroidManifest.xml` → `android:label`
- iOS: `Info.plist` → `CFBundleDisplayName`

### Change App Icon
```bash
flutter pub add flutter_launcher_icons
# Configure in pubspec.yaml
flutter pub run flutter_launcher_icons
```

### Change Package Name
Use package rename tool or manually update:
- Android: `build.gradle`, `AndroidManifest.xml`
- iOS: `Info.plist`, Xcode project

---

**📖 For detailed information, see:**
- `PROJECT_SUMMARY.md` - Complete overview
- `APP_OVERVIEW.md` - Feature details
- `FLOW_DIAGRAM.md` - Technical flow
- `SETUP.md` - Setup instructions
