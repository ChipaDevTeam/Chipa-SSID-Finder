import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../models/trading_platform.dart';
import '../utils/ssid_formatter.dart';

class WebViewScreen extends StatefulWidget {
  final TradingPlatform platform;

  const WebViewScreen({super.key, required this.platform});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? webViewController;
  Map<String, String>? formattedSSIDs; // Changed to support multiple SSIDs
  String? userId; // For PocketOption user ID
  bool isLoading = true;
  double loadingProgress = 0;
  bool isCheckingCookies = false;

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
          if (formattedSSIDs != null) _buildSSIDDisplay(),
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

      String? cookieValue;
      
      // Find the main cookie
      for (var cookie in cookies) {
        if (cookie.name == widget.platform.cookieKey) {
          cookieValue = cookie.value.toString();
          break;
        }
      }
      
      // Try alternate cookie keys if main key not found
      if (cookieValue == null && widget.platform.alternateCookieKeys != null) {
        for (var altKey in widget.platform.alternateCookieKeys!) {
          for (var cookie in cookies) {
            if (cookie.name == altKey) {
              cookieValue = cookie.value.toString();
              break;
            }
          }
          if (cookieValue != null) break;
        }
      }

      // Extract user ID if needed (for PocketOption)
      if (widget.platform.userIdCookieKey != null) {
        for (var cookie in cookies) {
          if (cookie.name == widget.platform.userIdCookieKey) {
            userId = cookie.value.toString();
            break;
          }
        }
      }
      
      // For Web3 platforms, also try extracting from localStorage via JS
      if (widget.platform.type == PlatformType.web3 && 
          widget.platform.jsTokenExtraction != null &&
          cookieValue == null) {
        try {
          final jsResult = await webViewController!.evaluateJavascript(
            source: widget.platform.jsTokenExtraction!,
          );
          if (jsResult != null && jsResult.toString().isNotEmpty && jsResult.toString() != '{}') {
            final resultStr = jsResult.toString();
            try {
              final Map<String, dynamic> tokens = json.decode(resultStr);
              if (tokens.isNotEmpty) {
                setState(() {
                  formattedSSIDs = SSIDFormatter.formatWeb3Tokens(tokens);
                });
                return;
              }
            } catch (_) {
              // If not valid JSON, treat as raw token
              if (resultStr.length > 5) {
                cookieValue = resultStr;
              }
            }
          }
        } catch (e) {
          debugPrint('JS extraction error: $e');
        }
      }

      if (cookieValue != null && cookieValue.isNotEmpty) {
        setState(() {
          // Format the SSID based on platform type
          if (widget.platform.type == PlatformType.pocketOption) {
            formattedSSIDs = SSIDFormatter.formatPocketOptionSSID(
              cookieValue!,
              userId,
            );
          } else {
            formattedSSIDs = SSIDFormatter.formatSimpleSSID(cookieValue!);
          }
        });
      }
    } catch (e) {
      debugPrint('Error checking cookies: $e');
    } finally {
      setState(() {
        isCheckingCookies = false;
      });
    }
  }

  Widget _buildSSIDDisplay() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(widget.platform.colors[0]),
              Color(widget.platform.colors[1]),
            ],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'SSID Found!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Successfully extracted from ${widget.platform.displayName}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Display all formatted SSIDs
                    ...formattedSSIDs!.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildSSIDCard(
                          label: _getSSIDLabel(entry.key),
                          value: entry.value,
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                        label: const Text('Close'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(widget.platform.colors[0]),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSSIDLabel(String key) {
    switch (key) {
      case 'demo':
        return '🎮 Demo SSID';
      case 'real':
        return '💰 Real SSID';
      case 'token':
        return '🔑 Access Token';
      case 'session':
        return '🔐 Session Token';
      case 'wallet':
        return '👛 Wallet Address';
      default:
        if (key.startsWith('token_')) return '🔑 Token ${key.split('_').last}';
        return '🔑 $key';
    }
  }

  String? _getSSIDWarning(String key) {
    switch (key) {
      case 'real':
        return '⚠️ This SSID only works on this device. Download our upcoming desktop app to find the real SSID for your PC.';
      default:
        return null;
    }
  }

  Widget _buildSSIDCard({required String label, required String value}) {
    // Extract key from label (e.g., 'demo' from 'Demo SSID')
    String key = '';
    if (label.contains('Demo')) key = 'demo';
    if (label.contains('Real')) key = 'real';
    if (label.contains('Token')) key = 'token';
    
    final warning = _getSSIDWarning(key);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.copy,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: value),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$label copied to clipboard!'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                tooltip: 'Copy to clipboard',
              ),
            ],
          ),
          if (warning != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Text(
                warning,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 150),
            child: SingleChildScrollView(
              child: SelectableText(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
