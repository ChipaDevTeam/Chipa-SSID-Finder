import 'dart:io';
import 'package:webview_cef/webview_cef.dart';

/// Entry points for one-time setup of the Chipa SSID Finder library.
class ChipaSsidFinder {
  ChipaSsidFinder._();

  /// Default desktop user-agent used for the Linux CEF runtime.
  static const String defaultLinuxUserAgent =
      'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';

  /// Initialises the WebView backend for the current platform.
  ///
  /// On Linux this boots the CEF (Chromium) runtime that
  /// [SsidExtractionScreen] relies on — it **must** be called once, after
  /// `WidgetsFlutterBinding.ensureInitialized()` and before showing the
  /// extraction screen. On every other platform this is a no-op, so it is safe
  /// to call unconditionally.
  ///
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   await ChipaSsidFinder.ensureInitialized();
  ///   runApp(const MyApp());
  /// }
  /// ```
  static Future<void> ensureInitialized({
    String userAgent = defaultLinuxUserAgent,
  }) async {
    if (Platform.isLinux) {
      await WebviewManager().initialize(userAgent: userAgent);
    }
  }
}
