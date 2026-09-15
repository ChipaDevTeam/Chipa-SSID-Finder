## 1.0.0

- Initial release, extracted from the Chipa SSID Finder app.
- Pure-Dart extraction logic: `TradingPlatform` / `PlatformConstants`,
  `SsidExtractor`, `SSIDFormatter`.
- Drop-in `SsidExtractionScreen` widget with automatic per-platform WebView
  backend selection (`flutter_inappwebview` on Android/iOS/macOS/Windows,
  `webview_cef` on Linux).
- `onExtracted` callback and optional built-in result sheet.
- `ChipaSsidFinder.ensureInitialized()` for Linux CEF startup.
- Bundled platform definitions: OlympTrade, PocketOptions, Quotex, Binomo,
  IqOptions, Expert Options, GmGn and Axiom Trade.
