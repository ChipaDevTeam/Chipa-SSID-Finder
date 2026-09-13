import 'dart:io';
import 'package:flutter/material.dart';
import '../models/trading_platform.dart';
import 'webview_screen.dart';
import 'webview_screen_linux.dart';

/// Returns the correct SSID-extraction screen for the current platform.
///
/// Linux uses the CEF-backed [WebViewScreenLinux] because
/// `flutter_inappwebview` has no Linux implementation. Every other platform
/// (Android, iOS, macOS, Windows) uses [WebViewScreen].
Widget buildExtractionScreen(TradingPlatform platform) {
  if (Platform.isLinux) {
    return WebViewScreenLinux(platform: platform);
  }
  return WebViewScreen(platform: platform);
}
