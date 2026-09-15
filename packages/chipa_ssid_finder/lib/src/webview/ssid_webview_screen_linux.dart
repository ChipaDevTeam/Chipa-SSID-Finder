import 'package:flutter/material.dart';
import 'package:webview_cef/webview_cef.dart';
import '../models/trading_platform.dart';
import '../extraction/ssid_extractor.dart';
import '../widgets/ssid_result_sheet.dart';
import 'ssid_extraction_screen.dart';

/// Linux extraction screen backed by CEF (webview_cef).
///
/// `flutter_inappwebview` has no Linux implementation, so on Linux we render a
/// full Chromium browser via CEF and read cookies (including HttpOnly session
/// tokens) through the CEF cookie manager. The extracted-SSID UI and the
/// cookie -> SSID logic are shared with [SsidInAppWebViewScreen] via
/// [SsidResultSheet] and [SsidExtractor], so behaviour matches other platforms.
///
/// The CEF runtime must be initialised once before this screen is shown; call
/// `ChipaSsidFinder.ensureInitialized()` at app startup.
class SsidWebViewScreenLinux extends StatefulWidget {
  final TradingPlatform platform;
  final SsidExtractedCallback? onExtracted;
  final bool showResultSheet;
  final VoidCallback? onClose;

  const SsidWebViewScreenLinux({
    super.key,
    required this.platform,
    this.onExtracted,
    this.showResultSheet = true,
    this.onClose,
  });

  @override
  State<SsidWebViewScreenLinux> createState() => _SsidWebViewScreenLinuxState();
}

class _SsidWebViewScreenLinuxState extends State<SsidWebViewScreenLinux> {
  final WebViewController _controller = WebviewManager().createWebView(
    loading: const Center(child: CircularProgressIndicator()),
  );

  Map<String, String>? formattedSSIDs;
  String? userId;
  bool isCheckingCookies = false;
  bool _initFailed = false;

  void _handleClose() {
    if (widget.onClose != null) {
      widget.onClose!();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _emit(Map<String, String> ssids) {
    widget.onExtracted?.call(ssids);
    if (widget.showResultSheet && mounted) {
      setState(() => formattedSSIDs = ssids);
    }
  }

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  Future<void> _initWebView() async {
    try {
      // WebviewManager must be initialised once at app start (see
      // ChipaSsidFinder.ensureInitialized). Wait for it to be ready before
      // creating the browser.
      await WebviewManager().ready;

      _controller.setWebviewListener(
        WebviewEventsListener(
          onLoadEnd: (controller, url) {
            _checkForSSID();
          },
        ),
      );

      await _controller.initialize(widget.platform.url);
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      debugPrint('CEF WebView init error: $e');
      if (mounted) setState(() => _initFailed = true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload',
            onPressed: () {
              setState(() {
                formattedSSIDs = null;
                userId = null;
              });
              _controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_initFailed)
            _buildInitError()
          else
            ValueListenableBuilder<bool>(
              valueListenable: _controller,
              builder: (context, ready, child) {
                return ready
                    ? _controller.webviewWidget
                    : const Center(child: CircularProgressIndicator());
              },
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
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildInitError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              'Could not start the browser engine.',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'The CEF runtime failed to initialise. Please restart the app '
              'and try again.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkForSSID() async {
    if (isCheckingCookies) return;
    setState(() => isCheckingCookies = true);

    try {
      // Pull every cookie CEF knows about (includes HttpOnly) and flatten the
      // domain -> {name: value} structure into a single name -> value map.
      final raw = await WebviewManager().visitAllCookies();
      final cookieMap = <String, String>{};
      if (raw is Map) {
        raw.forEach((_, cookiesForDomain) {
          if (cookiesForDomain is Map) {
            cookiesForDomain.forEach((name, value) {
              cookieMap[name.toString()] = value.toString();
            });
          }
        });
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
          final jsResult = await _controller.evaluateJavascript(
            widget.platform.jsTokenExtraction!,
          );
          final web3Tokens =
              SsidExtractor.tryParseWeb3Json(jsResult?.toString());
          if (web3Tokens != null) {
            _emit(web3Tokens);
            return;
          }
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
      if (mounted) setState(() => isCheckingCookies = false);
    }
  }
}
