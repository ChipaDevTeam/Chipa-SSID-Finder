# Getting started

## 1. Add the dependency

```yaml
dependencies:
  chipa_ssid_finder: ^1.0.0
```

If you are consuming it from within this repo, use a path dependency instead:

```yaml
dependencies:
  chipa_ssid_finder:
    path: packages/chipa_ssid_finder
```

Then fetch packages:

```bash
flutter pub get
```

The package pulls in two WebView backends transitively:

- [`flutter_inappwebview`](https://pub.dev/packages/flutter_inappwebview) — used on Android, iOS, macOS and Windows.
- [`webview_cef`](https://pub.dev/packages/webview_cef) — used on Linux, where `flutter_inappwebview` has no implementation.

Each backend has its own platform setup — see [Platform setup](platform-setup.md).

## 2. Initialise once at startup

Call `ChipaSsidFinder.ensureInitialized()` after
`WidgetsFlutterBinding.ensureInitialized()` and before showing the extraction
screen. On Linux this boots the CEF (Chromium) runtime; on every other platform
it is a no-op, so it is safe to call unconditionally.

```dart
import 'package:flutter/material.dart';
import 'package:chipa_ssid_finder/chipa_ssid_finder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ChipaSsidFinder.ensureInitialized();
  runApp(const MyApp());
}
```

## 3. Extract an SSID

Push `SsidExtractionScreen` for the platform you want. The user logs in
normally inside the embedded browser; the SSID is extracted automatically as
soon as the session cookie appears.

```dart
void openExtraction(BuildContext context, TradingPlatform platform) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => SsidExtractionScreen(
      platform: platform,
      onExtracted: (ssids) {
        // e.g. {'token': 'abc...'} or {'demo': ..., 'real': ...}
        debugPrint('Extracted: $ssids');
      },
    ),
  ));
}
```

By default a result sheet slides up when an SSID is found, with copy-to-clipboard
buttons. Set `showResultSheet: false` to suppress it and drive your own UI from
the `onExtracted` callback.

## 4. Pick a platform

The bundled definitions live in `PlatformConstants.platforms`:

```dart
final olymp = PlatformConstants.platforms
    .firstWhere((p) => p.name == 'olymptrade');
```

See [Supported platforms](platforms.md) for the full list and how to define
custom ones.

## Next steps

- [Usage](usage.md) — the callback, the result sheet, and pure-logic extraction.
- [How it works](how-it-works.md) — what happens under the hood.
- [API reference](api-reference.md) — every public symbol.
