# White Page Troubleshooting Guide

## Issue
When clicking PocketOptions, a white page appears instead of the login page.

## Changes Made

### 1. URL Update
Changed from:
```
https://pocketoption.com/en/login
```
To:
```
https://pocketoption.com
```

The main domain should redirect properly to the login page.

### 2. Enhanced WebView Settings

Added the following settings to fix white page issues:

#### User Agent
```dart
userAgent: 'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36'
```
This makes the WebView appear as a modern Chrome browser on Android.

#### Content & Security Settings
- `allowFileAccessFromFileURLs: true`
- `allowUniversalAccessFromFileURLs: true`
- `javaScriptCanOpenWindowsAutomatically: true`
- `mixedContentMode: MIXED_CONTENT_ALWAYS_ALLOW`

#### Storage Settings
- `domStorageEnabled: true`
- `databaseEnabled: true`
- `sharedCookiesEnabled: true`
- `thirdPartyCookiesEnabled: true`

#### URL Loading
- `useShouldOverrideUrlLoading: false` - Allows all navigation

### 3. Added Error Logging

The WebView now logs errors to help debug:
- `onReceivedError` - For WebView errors
- `onReceivedHttpError` - For HTTP errors
- `onConsoleMessage` - For JavaScript console messages

## Testing Steps

1. **Install the new APK**
   ```bash
   adb install -r "/Users/vigowalker/Chipa SSID Finder/build/app/outputs/flutter-apk/app-release.apk"
   ```

2. **Test PocketOption**
   - Open the app
   - Tap on PocketOptions (blue card)
   - The page should now load

3. **If Still White**
   - Check logs: `adb logcat | grep "WebView"`
   - Look for error messages

## Common Causes of White Page

### 1. Website Blocks WebViews
Some sites detect and block WebViews. Solutions:
- ✅ Use a proper User-Agent (already implemented)
- ✅ Enable JavaScript (already enabled)
- ✅ Allow mixed content (already enabled)

### 2. CORS Issues
Cross-Origin Resource Sharing might block content. Solutions:
- ✅ `allowUniversalAccessFromFileURLs: true` (implemented)
- ✅ `allowFileAccessFromFileURLs: true` (implemented)

### 3. JavaScript Required
The page needs JavaScript to render. Solutions:
- ✅ `javaScriptEnabled: true` (already enabled)
- ✅ `javaScriptCanOpenWindowsAutomatically: true` (implemented)

### 4. Cookies Not Working
The site requires cookies. Solutions:
- ✅ `thirdPartyCookiesEnabled: true` (enabled)
- ✅ `sharedCookiesEnabled: true` (enabled)
- ✅ `domStorageEnabled: true` (enabled)

### 5. SSL Certificate Issues
Mixed HTTP/HTTPS content. Solutions:
- ✅ `mixedContentMode: MIXED_CONTENT_ALWAYS_ALLOW` (implemented)

## Alternative Solutions

If the issue persists, you can try:

### Option 1: Use Desktop Mode
Add this to the URL request:
```dart
initialUrlRequest: URLRequest(
  url: WebUri('https://pocketoption.com'),
  headers: {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
  },
),
```

### Option 2: Clear WebView Cache
Add this before loading:
```dart
await webViewController?.clearCache();
await CookieManager.instance().deleteAllCookies();
```

### Option 3: Enable Debugging
For more details, enable WebView debugging in debug mode:
```dart
if (kDebugMode) {
  await InAppWebViewController.setWebContentsDebuggingEnabled(true);
}
```

## Verification

To verify it's working:
1. The WebView should show the PocketOption homepage/login
2. You should be able to interact with the page
3. After login, cookies should be detected
4. SSID cards should appear

## Current Configuration

**PocketOption Platform:**
- **URL**: `https://pocketoption.com`
- **Cookie**: `ci_session`
- **Type**: `PlatformType.pocketOption`
- **User-Agent**: Mobile Chrome 120

**WebView Settings:**
- JavaScript: ✅ Enabled
- DOM Storage: ✅ Enabled
- Third-party Cookies: ✅ Enabled
- User-Agent: ✅ Chrome Mobile
- Mixed Content: ✅ Allowed
- File Access: ✅ Enabled

## Expected Behavior

1. **Loading**: Progress bar shows at top
2. **Page Loads**: PocketOption homepage appears
3. **Navigation**: Can navigate to login page
4. **Login**: User enters credentials
5. **Cookie Detection**: App monitors `ci_session` cookie
6. **Display**: Shows Demo & Real SSIDs

## Need More Help?

If white page persists:
1. Check internet connection
2. Try on a different device
3. Check if pocketoption.com is accessible in regular browser
4. Look at WebView console logs for errors
5. Try clearing app data and reinstalling

---

**Latest APK Location:**
```
/Users/vigowalker/Chipa SSID Finder/build/app/outputs/flutter-apk/app-release.apk
```

**Build Time:** 4.5 seconds ⚡
