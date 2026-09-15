# chipa_ssid_finder

Extract session tokens (SSIDs) from trading platforms via an embedded WebView.

This package is the reusable core of the **Chipa SSID Finder** app. It ships
two layers you can use independently:

- **Pure-Dart extraction logic** — no Flutter dependency. Feed it a
  `name -> value` cookie map and it returns the labelled SSID map.
- **A drop-in Flutter widget** — `SsidExtractionScreen` embeds the platform's
  login page, then extracts the SSID automatically once the user logs in. It
  picks the right WebView backend for each platform.

## Supported platforms

Android, iOS, macOS and Windows use
[`flutter_inappwebview`](https://pub.dev/packages/flutter_inappwebview). Linux
has no `flutter_inappwebview` implementation, so it falls back to
[`webview_cef`](https://pub.dev/packages/webview_cef) (CEF/Chromium), which can
also read HttpOnly session cookies.

Bundled trading-platform definitions: OlympTrade, PocketOptions, Quotex,
Binomo, IqOptions, Expert Options, GmGn and Axiom Trade.

## Install

```yaml
dependencies:
  chipa_ssid_finder: ^1.0.0
```

Follow the platform setup instructions for
[`flutter_inappwebview`](https://inappwebview.dev/docs/intro/) and, if you
target Linux, [`webview_cef`](https://pub.dev/packages/webview_cef).

## Usage

### Drop-in widget

```dart
import 'package:flutter/material.dart';
import 'package:chipa_ssid_finder/chipa_ssid_finder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Required on Linux (no-op elsewhere): boots the CEF runtime.
  await ChipaSsidFinder.ensureInitialized();
  runApp(const MyApp());
}

// Push the extraction screen for a platform:
Navigator.of(context).push(MaterialPageRoute(
  builder: (_) => SsidExtractionScreen(
    platform: PlatformConstants.platforms.first, // e.g. OlympTrade
    onExtracted: (ssids) {
      // ssids is e.g. {'demo': ..., 'real': ...} or {'token': ...}
      debugPrint('Got SSIDs: $ssids');
    },
  ),
));
```

`SsidExtractionScreen` shows a built-in result sheet by default. Pass
`showResultSheet: false` if you only want the `onExtracted` callback and will
render your own UI, and `onClose` to override the sheet's close behaviour.

### Pure logic only

If you already have your own WebView, use the extractor directly with a
flattened cookie map:

```dart
final platform =
    PlatformConstants.platforms.firstWhere((p) => p.name == 'pocketoptions');

final cookieValue = SsidExtractor.findCookieValue(platform, cookieMap);
final userId = SsidExtractor.findUserId(platform, cookieMap);

if (cookieValue != null) {
  final ssids = SsidExtractor.format(platform, cookieValue, userId);
  // {'demo': ..., 'real': ...}
}
```

For Web3 platforms, run `platform.jsTokenExtraction` in your WebView and pass
the result to `SsidExtractor.tryParseWeb3Json`.

### Custom platforms

`SsidExtractionScreen` accepts any `TradingPlatform`, so you can define your
own instead of using the bundled `PlatformConstants.platforms`:

```dart
const myPlatform = TradingPlatform(
  name: 'example',
  displayName: 'Example',
  url: 'https://example.com',
  cookieKey: 'access_token',
  colors: [0xFF6B46C1, 0xFF9333EA],
);
```

## License

No license file ships with this package yet — add one before publishing.
