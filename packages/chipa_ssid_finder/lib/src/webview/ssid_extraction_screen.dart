import 'dart:io';
import 'package:flutter/material.dart';
import '../models/trading_platform.dart';
import 'ssid_inappwebview_screen.dart';
import 'ssid_webview_screen_linux.dart';

/// Signature for the callback fired when one or more SSIDs are extracted.
///
/// [ssids] is the labelled token map produced by the shared extractor, e.g.
/// `{'demo': ..., 'real': ...}` for PocketOption or `{'token': ...}` for a
/// simple platform.
typedef SsidExtractedCallback = void Function(Map<String, String> ssids);

/// Drop-in extraction screen: renders the platform's login page in an embedded
/// browser and automatically extracts the SSID once the user has logged in.
///
/// It picks the correct WebView backend for the current platform:
/// `flutter_inappwebview` on Android/iOS/macOS/Windows, and `webview_cef`
/// (CEF/Chromium) on Linux, which `flutter_inappwebview` does not support.
///
/// On Linux you must call [ensureInitialized] once at app startup before
/// showing this widget.
///
/// ```dart
/// Navigator.of(context).push(MaterialPageRoute(
///   builder: (_) => SsidExtractionScreen(
///     platform: PlatformConstants.platforms.first,
///     onExtracted: (ssids) => print(ssids),
///   ),
/// ));
/// ```
class SsidExtractionScreen extends StatelessWidget {
  /// The trading platform to extract an SSID from.
  final TradingPlatform platform;

  /// Called whenever a fresh set of SSIDs is extracted. May fire more than
  /// once (e.g. on navigation/refresh) as new tokens become available.
  final SsidExtractedCallback? onExtracted;

  /// Whether to show the built-in result bottom sheet when an SSID is found.
  /// Set to `false` if you only want the [onExtracted] callback and will build
  /// your own UI. Defaults to `true`.
  final bool showResultSheet;

  /// Called when the user dismisses the result sheet's close button. Defaults
  /// to popping the current route.
  final VoidCallback? onClose;

  const SsidExtractionScreen({
    super.key,
    required this.platform,
    this.onExtracted,
    this.showResultSheet = true,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isLinux) {
      return SsidWebViewScreenLinux(
        platform: platform,
        onExtracted: onExtracted,
        showResultSheet: showResultSheet,
        onClose: onClose,
      );
    }
    return SsidInAppWebViewScreen(
      platform: platform,
      onExtracted: onExtracted,
      showResultSheet: showResultSheet,
      onClose: onClose,
    );
  }
}
