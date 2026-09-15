import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../models/trading_platform.dart';
import '../extraction/ssid_extractor.dart';
import '../widgets/ssid_result_sheet.dart';
import 'ssid_extraction_screen.dart';

/// WebView-based extraction screen for platforms where `flutter_inappwebview`
/// is supported: Android, iOS, macOS and Windows.
///
/// Linux is not supported by flutter_inappwebview and uses
/// [SsidWebViewScreenLinux] (webview_cef) instead.
class SsidInAppWebViewScreen extends StatefulWidget {
  final TradingPlatform platform;
  final SsidExtractedCallback? onExtracted;
  final bool showResultSheet;
  final VoidCallback? onClose;

  const SsidInAppWebViewScreen({
    super.key,
    required this.platform,
    this.onExtracted,
    this.showResultSheet = true,
    this.onClose,
  });

  @override
  State<SsidInAppWebViewScreen> createState() => _SsidInAppWebViewScreenState();
}

class _SsidInAppWebViewScreenState extends State<SsidInAppWebViewScreen> {
  InAppWebViewController? webViewController;
  Map<String, String>? formattedSSIDs; // Supports multiple SSIDs
  String? userId; // For PocketOption user ID
  bool isLoading = true;
  double loadingProgress = 0;
  bool isCheckingCookies = false;

  void _handleClose() {
    if (widget.onClose != null) {
      widget.onClose!();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _emit(Map<String, String> ssids) {
    widget.onExtracted?.call(ssids);
    if (widget.showResultSheet) {
      setState(() => formattedSSIDs = ssids);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(widget.platform.colors[0]),
                    Color(widget.platform.colors[1]),
                  ],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.wifi_find, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            Text(widget.platform.displayName),
          ],
        ),
        elevation: 0,
        actions: [
          if (formattedSSIDs != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Reload',
              onPressed: () {
                setState(() {
                  formattedSSIDs = null;
                  userId = null;
                });
                webViewController?.reload();
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              if (isLoading)
                LinearProgressIndicator(
                  value: loadingProgress,
                  backgroundColor: Colors.grey[200],
                ),
              Expanded(
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: WebUri(widget.platform.url),
                    headers: {
                      'User-Agent': 'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
                    },
                  ),
                  initialSettings: InAppWebViewSettings(
                    javaScriptEnabled: true,
                    domStorageEnabled: true,
                    databaseEnabled: true,
                    thirdPartyCookiesEnabled: true,
                    sharedCookiesEnabled: true,

                    // User agent
                    userAgent: 'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',

                    // Content settings
                    mediaPlaybackRequiresUserGesture: false,
                    allowsInlineMediaPlayback: true,
                    mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,

                    // View settings
                    useWideViewPort: true,
                    loadWithOverviewMode: true,
                    supportZoom: true,
                    builtInZoomControls: false,

                    // Cache and storage
                    cacheEnabled: true,
                    clearCache: false,

                    // Security and features
                    allowFileAccessFromFileURLs: true,
                    allowUniversalAccessFromFileURLs: true,
                    javaScriptCanOpenWindowsAutomatically: true,

                    // IFrame support
                    iframeAllow: "camera; microphone; geolocation",
                    iframeAllowFullscreen: true,

                    // Override URL loading
                    useShouldOverrideUrlLoading: false,
                  ),
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    setState(() {
                      isLoading = true;
                    });
                  },
                  onLoadStop: (controller, url) async {
                    setState(() {
                      isLoading = false;
                    });
                    // Check for cookies after page loads
                    await _checkForSSID();
                  },
                  onProgressChanged: (controller, progress) {
                    setState(() {
                      loadingProgress = progress / 100;
                      if (progress == 100) {
                        isLoading = false;
                      }
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    // Check cookies on navigation
                    _checkForSSID();
                  },
                  onReceivedError: (controller, request, error) {
                    debugPrint('WebView error: ${error.description}');
                  },
                  onReceivedHttpError: (controller, request, errorResponse) {
                    debugPrint('HTTP error: ${errorResponse.statusCode}');
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    debugPrint('Console: ${consoleMessage.message}');
                  },
                ),
              ),
            ],
          ),
          if (formattedSSIDs != null)
            SsidResultSheet(
              platform: widget.platform,
              formattedSSIDs: formattedSSIDs!,
              onClose: _handleClose,
            ),
          if (isCheckingCookies)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _checkForSSID() async {
    if (isCheckingCookies || webViewController == null) return;

    setState(() {
      isCheckingCookies = true;
    });

    try {
      final cookieManager = CookieManager.instance();
      final cookies = await cookieManager.getCookies(
        url: WebUri(widget.platform.url),
      );

      // Normalise to a simple name -> value map for the shared extractor.
      final cookieMap = <String, String>{};
      for (final cookie in cookies) {
        cookieMap[cookie.name] = cookie.value.toString();
      }

      String? cookieValue = SsidExtractor.findCookieValue(
        widget.platform,
        cookieMap,
      );
      userId = SsidExtractor.findUserId(widget.platform, cookieMap);

      // For Web3 platforms, also try extracting from localStorage via JS.
      if (widget.platform.type == PlatformType.web3 &&
          widget.platform.jsTokenExtraction != null &&
          cookieValue == null) {
        try {
          final jsResult = await webViewController!.evaluateJavascript(
            source: widget.platform.jsTokenExtraction!,
          );
          final web3Tokens = SsidExtractor.tryParseWeb3Json(jsResult?.toString());
          if (web3Tokens != null) {
            _emit(web3Tokens);
            return;
          }
          // Not JSON — treat a non-trivial result as a raw token.
          final resultStr = jsResult?.toString() ?? '';
          if (resultStr.length > 5) {
            cookieValue = resultStr;
          }
        } catch (e) {
          debugPrint('JS extraction error: $e');
        }
      }

      if (cookieValue != null && cookieValue.isNotEmpty) {
        _emit(SsidExtractor.format(widget.platform, cookieValue, userId));
      }
    } catch (e) {
      debugPrint('Error checking cookies: $e');
    } finally {
      setState(() {
        isCheckingCookies = false;
      });
    }
  }
}
