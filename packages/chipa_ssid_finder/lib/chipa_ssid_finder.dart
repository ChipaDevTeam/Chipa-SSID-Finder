/// Chipa SSID Finder — extract session tokens (SSIDs) from trading platforms.
///
/// This library ships two layers:
///
/// * **Pure-Dart extraction logic** — [TradingPlatform] / [PlatformConstants],
///   [SsidExtractor] and [SSIDFormatter]. These have no Flutter dependency and
///   can be used with any WebView (feed them a `name -> value` cookie map).
/// * **A drop-in Flutter widget** — [SsidExtractionScreen], which embeds the
///   platform login page and extracts the SSID automatically, picking the
///   right WebView backend per platform.
///
/// On Linux, call [ChipaSsidFinder.ensureInitialized] once at startup.
library;

export 'src/chipa_ssid_finder.dart';
export 'src/models/trading_platform.dart';
export 'src/extraction/ssid_extractor.dart';
export 'src/extraction/ssid_formatter.dart';
export 'src/widgets/ssid_result_sheet.dart';
export 'src/webview/ssid_extraction_screen.dart'
    show SsidExtractionScreen, SsidExtractedCallback;
