import 'dart:convert';
import '../models/trading_platform.dart';
import 'ssid_formatter.dart';

/// Shared, WebView-agnostic logic for turning a set of cookies (and optional
/// Web3 JS extraction result) into the formatted SSID map the UI displays.
///
/// Both the mobile/Windows/macOS WebView (flutter_inappwebview) and the Linux
/// WebView (webview_cef) normalise their cookies to a simple `name -> value`
/// map and then use these helpers, so extraction behaves identically across
/// platforms.
class SsidExtractor {
  /// Finds the primary session cookie value for [platform], falling back to
  /// any [TradingPlatform.alternateCookieKeys]. Returns null if none present.
  static String? findCookieValue(
    TradingPlatform platform,
    Map<String, String> cookies,
  ) {
    final primary = cookies[platform.cookieKey];
    if (primary != null && primary.isNotEmpty) return primary;

    if (platform.alternateCookieKeys != null) {
      for (final altKey in platform.alternateCookieKeys!) {
        final value = cookies[altKey];
        if (value != null && value.isNotEmpty) return value;
      }
    }
    return null;
  }

  /// Finds the user-id cookie (used by PocketOption), if the platform declares
  /// one. Returns null otherwise.
  static String? findUserId(
    TradingPlatform platform,
    Map<String, String> cookies,
  ) {
    if (platform.userIdCookieKey == null) return null;
    final value = cookies[platform.userIdCookieKey];
    return (value != null && value.isNotEmpty) ? value : null;
  }

  /// Formats a raw cookie [value] into the labelled SSID map for display,
  /// based on the platform type.
  static Map<String, String> format(
    TradingPlatform platform,
    String value,
    String? userId,
  ) {
    if (platform.type == PlatformType.pocketOption) {
      return SSIDFormatter.formatPocketOptionSSID(value, userId);
    }
    return SSIDFormatter.formatSimpleSSID(value);
  }

  /// Attempts to interpret the result of a Web3 JS extraction as a JSON token
  /// map. Returns the formatted token map on success, or null when the result
  /// is empty/not JSON (in which case the caller should treat it as a raw
  /// token value).
  static Map<String, String>? tryParseWeb3Json(String? jsResult) {
    if (jsResult == null) return null;
    final trimmed = jsResult.trim();
    if (trimmed.isEmpty || trimmed == '{}') return null;
    try {
      final decoded = json.decode(trimmed);
      if (decoded is Map<String, dynamic> && decoded.isNotEmpty) {
        return SSIDFormatter.formatWeb3Tokens(decoded);
      }
    } catch (_) {
      // Not valid JSON — caller treats it as a raw token string.
    }
    return null;
  }
}
