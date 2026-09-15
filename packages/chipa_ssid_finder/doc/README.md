# chipa_ssid_finder documentation

`chipa_ssid_finder` extracts session tokens (SSIDs) from trading platforms via
an embedded WebView. It ships pure-Dart extraction logic plus a drop-in Flutter
widget that works on Android, iOS, macOS, Windows and Linux.

## Contents

| Guide | What it covers |
| --- | --- |
| [Getting started](getting-started.md) | Install, initialise, extract your first SSID |
| [Platform setup](platform-setup.md) | Per-OS WebView requirements (permissions, CEF, entitlements) |
| [Usage](usage.md) | The widget, the callback, and pure-logic-only extraction |
| [Supported platforms](platforms.md) | Bundled platform definitions and how to add your own |
| [How it works](how-it-works.md) | The extraction pipeline and backend selection |
| [API reference](api-reference.md) | Every public class, method and parameter |

## At a glance

```dart
import 'package:flutter/material.dart';
import 'package:chipa_ssid_finder/chipa_ssid_finder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ChipaSsidFinder.ensureInitialized(); // Linux CEF boot; no-op elsewhere
  runApp(const MyApp());
}

// Later, open the extraction screen for a platform:
Navigator.of(context).push(MaterialPageRoute(
  builder: (_) => SsidExtractionScreen(
    platform: PlatformConstants.platforms.first,
    onExtracted: (ssids) => debugPrint('$ssids'),
  ),
));
```

> **Note on responsible use.** This package reads authentication cookies from
> sites the user logs into inside your app. Only use it against platforms and
> accounts you are authorised to access, and handle extracted tokens as
> secrets — never log them in production or transmit them to third parties.
