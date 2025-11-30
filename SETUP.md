# SSID Finder - Setup Instructions

## Quick Start

1. **Get Flutter dependencies:**
   ```bash
   cd "/Users/vigowalker/Chipa SSID Finder"
   flutter pub get
   ```

2. **Run the app:**
   
   For Android:
   ```bash
   flutter run
   ```
   
   For iOS:
   ```bash
   flutter run -d ios
   ```

## How It Works

### Platform Selector
- The home screen displays 8 trading platforms in a beautiful grid layout
- Each platform has its own color scheme and gradient
- Tap any platform card to open its login page

### OlympTrade (Currently Implemented)
1. Tap the "OlympTrade" card
2. The app opens https://olymptrade.com in a WebView
3. Log in to your account
4. Once logged in, the app automatically detects the `access_token` cookie
5. The SSID (access token) is displayed in a beautiful bottom sheet
6. You can copy the token with one tap

### Features
- ✅ Modern Material 3 UI with gradients and animations
- ✅ Dark/Light theme support
- ✅ Automatic cookie detection
- ✅ Easy copy-to-clipboard functionality
- ✅ Beautiful animated cards
- ✅ Progress indicators during loading
- ✅ Secure WebView with full JavaScript support

## Supported Platforms

Currently, the app is configured for:
1. **OlympTrade** ✅ Fully implemented
2. PocketOptions (URL configured, ready to use)
3. Quotex (URL configured, ready to use)
4. Binomo (URL configured, ready to use)
5. IqOptions (URL configured, ready to use)
6. Expert Options (URL configured, ready to use)
7. GmGn (URL configured, ready to use)
8. AxiomTrade (URL configured, ready to use)

All platforms follow the same pattern - they look for the `access_token` cookie after login.

## Customization

To adjust which cookie to search for on each platform, edit:
`lib/models/trading_platform.dart`

Change the `cookieKey` property for any platform:
```dart
TradingPlatform(
  name: 'olymptrade',
  displayName: 'OlympTrade',
  url: 'https://olymptrade.com',
  cookieKey: 'access_token',  // Change this if needed
  colors: [0xFF6B46C1, 0xFF9333EA],
),
```

## Troubleshooting

If you encounter any issues:

1. **Dependencies not installed:**
   ```bash
   flutter pub get
   ```

2. **Android build issues:**
   ```bash
   cd android
   ./gradlew clean
   cd ..
   flutter clean
   flutter pub get
   ```

3. **iOS build issues:**
   ```bash
   cd ios
   pod install
   cd ..
   flutter clean
   flutter pub get
   ```

## Requirements

- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher
- Android SDK 21+ or iOS 12+
