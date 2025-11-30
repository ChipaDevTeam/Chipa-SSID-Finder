# PocketOption Implementation Guide

## Overview
PocketOption has been implemented with special SSID formatting that generates both Demo and Real account SSIDs from the `ci_session` cookie.

## How It Works

### Cookie Detection
The app looks for the `ci_session` cookie after login:
```
Cookie Name: ci_session
Cookie Value: a:4:{s:10:"session_id";s:32:"8730b217490d9b22b08c8eb596aa6a8f";s:10:"ip_address";s:13:"158.220.78.39";s:10:"user_agent";s:120:"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36 OP";s:13:"last_activity";i:1764505022;}459254dec1973bb05d0a8c19fc7c8fca
```

### SSID Formatting

The app automatically formats two SSIDs from the cookie value:

#### 1. Demo SSID 🎮
```
42["auth",{"session":"<ci_session_value>","isDemo":1,"uid":<user_id>,"platform":1,"isFastHistory":true,"isOptimized":true}]
```

**Example:**
```
42["auth",{"session":"t04ppgptp3404h0lajp4bo7smh","isDemo":1,"uid":101884312,"platform":1,"isFastHistory":true,"isOptimized":true}]
```

#### 2. Real SSID 💰
```
42["auth",{"session":"<ci_session_value_with_escaped_quotes>","isDemo":0,"uid":<user_id>,"platform":1,"isFastHistory":true,"isOptimized":true}]
```

**Example:**
```
42["auth",{"session":"a:4:{s:10:\"session_id\";s:32:\"8730b217490d9b22b08c8eb596aa6a8f\";s:10:\"ip_address\";s:13:\"158.220.78.39\";s:10:\"user_agent\";s:120:\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36 OP\";s:13:\"last_activity\";i:1764505022;}459254dec1973bb05d0a8c19fc7c8fca","isDemo":0,"uid":101884312,"platform":1,"isFastHistory":true,"isOptimized":true}]
```

## User Interface

When the SSID is detected, the app displays:
- ✅ Success message
- 🎮 **Demo SSID** card with copy button
- 💰 **Real SSID** card with copy button
- Each SSID is scrollable and selectable
- One-tap copy for each SSID type

## Configuration

### In `lib/models/trading_platform.dart`:
```dart
TradingPlatform(
  name: 'pocketoptions',
  displayName: 'PocketOptions',
  url: 'https://pocketoption.com/en/login',
  cookieKey: 'ci_session',                    // Main cookie to extract
  type: PlatformType.pocketOption,             // Special formatting
  userIdCookieKey: 'user_id',                  // Optional: Extract user ID
  colors: [0xFF3B82F6, 0xFF1D4ED8],           // Blue gradient
),
```

### In `lib/utils/ssid_formatter.dart`:
The `formatPocketOptionSSID()` method handles:
1. Escaping special characters in the session value
2. Formatting the Demo SSID with `isDemo: 1`
3. Formatting the Real SSID with `isDemo: 0`
4. Including user ID from cookies or default value

## Usage Flow

1. **User selects PocketOptions** from the platform grid
2. **WebView opens** https://pocketoption.com/en/login
3. **User logs in** with their credentials
4. **App monitors cookies** after each page load
5. **Cookie detected** - `ci_session` found
6. **SSIDs formatted** - Both Demo and Real versions created
7. **Display shown** - Beautiful bottom sheet with both SSIDs
8. **User copies** the SSID they need
9. **Success!** 🎉

## Testing

To test PocketOption:
1. Run the app
2. Tap "PocketOptions" card
3. Log in to your account
4. Wait for the SSID display to appear
5. Copy either Demo or Real SSID
6. Use it in your application

## Differences from OlympTrade

| Feature | OlympTrade | PocketOption |
|---------|------------|--------------|
| Cookie Name | `access_token` | `ci_session` |
| SSID Format | Simple (just the cookie value) | Complex (formatted JSON) |
| Output | 1 token | 2 tokens (Demo + Real) |
| Processing | Direct display | Formatted with escaping |

## Future Enhancements

Possible improvements:
- Auto-detect user ID from additional cookies
- Validate SSID format before displaying
- Add QR code for easy sharing
- Save SSID history locally
- Support for other PocketOption cookie formats

## Technical Details

### Cookie Extraction
```dart
// Extract ci_session
for (var cookie in cookies) {
  if (cookie.name == 'ci_session') {
    cookieValue = cookie.value.toString();
    break;
  }
}

// Extract user_id if available
if (widget.platform.userIdCookieKey != null) {
  for (var cookie in cookies) {
    if (cookie.name == 'user_id') {
      userId = cookie.value.toString();
      break;
    }
  }
}
```

### SSID Formatting
```dart
// Escape special characters for JSON
final escapedSession = ciSession
    .replaceAll('\\', '\\\\')
    .replaceAll('"', '\\"');

// Create Demo SSID
final demoSSID = '42["auth",{"session":"$demoSessionId","isDemo":1,"uid":$uid,"platform":1,"isFastHistory":true,"isOptimized":true}]';

// Create Real SSID  
final realSSID = '42["auth",{"session":"$escapedSession","isDemo":0,"uid":$uid,"platform":1,"isFastHistory":true,"isOptimized":true}]';
```

## Build Time

With optimizations, building takes:
- **Clean build**: ~30 seconds
- **Incremental**: ~5-10 seconds

Your APK location:
```
/Users/vigowalker/Chipa SSID Finder/build/app/outputs/flutter-apk/app-release.apk
```

---

**PocketOption is now fully implemented and ready to use!** 🚀
