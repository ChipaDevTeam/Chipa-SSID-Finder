# Platform setup

`chipa_ssid_finder` uses `flutter_inappwebview` on Android/iOS/macOS/Windows and
`webview_cef` on Linux. Each has platform-specific requirements. This page
summarises the essentials; always cross-check the upstream docs, linked below,
for your exact toolchain versions.

## Android

- **minSdkVersion**: 19 or higher (see `android/app/build.gradle`).
- **Internet permission** in `android/app/src/main/AndroidManifest.xml`:

  ```xml
  <uses-permission android:name="android.permission.INTERNET"/>
  ```

- No extra cookie configuration is required — the package enables
  `thirdPartyCookiesEnabled` and `sharedCookiesEnabled` on the WebView.

Upstream: <https://inappwebview.dev/docs/intro/>

## iOS

- Set the platform to **iOS 12+** in `ios/Podfile`:

  ```ruby
  platform :ios, '12.0'
  ```

- If a target platform is served only over cleartext (rare), you may need an
  App Transport Security exception in `ios/Runner/Info.plist`. Most trading
  platforms are HTTPS, so this is usually unnecessary.

Upstream: <https://inappwebview.dev/docs/intro/>

## macOS

- Set the platform to **macOS 10.13+** in `macos/Podfile`.
- Enable outgoing network access in both entitlements files
  (`macos/Runner/DebugProfile.entitlements` and `Release.entitlements`):

  ```xml
  <key>com.apple.security.network.client</key>
  <true/>
  ```

## Windows

- Requires the **WebView2 runtime**, which ships with current Windows 10/11.
  On older machines, bundle or install the Evergreen WebView2 runtime.
- Build with a recent Visual Studio toolchain (the app in this repo pins
  `windows-2022` in CI for reliable VS detection).

## Linux

Linux uses **CEF (Chromium Embedded Framework)** via `webview_cef` because
`flutter_inappwebview` has no Linux backend. This is what lets the package read
HttpOnly session cookies on Linux.

1. Install the usual Flutter Linux desktop build dependencies (GTK, clang,
   CMake, ninja, pkg-config).
2. Call the initialiser **before** showing any extraction screen:

   ```dart
   await ChipaSsidFinder.ensureInitialized();
   ```

   The first launch downloads/extracts the CEF runtime, so allow extra time and
   ensure the app has write access to its runtime directory.
3. On first run CEF may take a few seconds to initialise. If it fails, the
   screen shows a "Could not start the browser engine" message — restarting the
   app usually resolves transient CEF setup failures.

Upstream: <https://pub.dev/packages/webview_cef>

## User agent

Both backends send a browser-like user agent so login pages render correctly:

- Mobile/desktop WebView: an Android Chrome UA.
- Linux CEF: a desktop Linux Chrome UA (`ChipaSsidFinder.defaultLinuxUserAgent`).

You can override the Linux UA:

```dart
await ChipaSsidFinder.ensureInitialized(
  userAgent: 'Mozilla/5.0 ... your UA ...',
);
```

The mobile/desktop UA is fixed by the widget; if a platform requires a specific
UA there, use the pure-logic path with your own WebView (see [Usage](usage.md)).
