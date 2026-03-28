enum PlatformType {
  simple,      // Just displays the cookie value (OlympTrade)
  pocketOption, // Special formatting for PocketOption
  web3,        // Web3/DeFi platforms (axiom.trade) - checks cookies + localStorage
}

class TradingPlatform {
  final String name;
  final String url;
  final String cookieKey;
  final String displayName;
  final List<int> colors;
  final PlatformType type;
  final String? userIdCookieKey;
  final List<String>? alternateCookieKeys; // Fallback cookie names to try
  final String? jsTokenExtraction; // JS code to extract token from localStorage/sessionStorage
  final String? iconHint; // Platform-specific icon identifier

  const TradingPlatform({
    required this.name,
    required this.url,
    required this.cookieKey,
    required this.displayName,
    required this.colors,
    this.type = PlatformType.simple,
    this.userIdCookieKey,
    this.alternateCookieKeys,
    this.jsTokenExtraction,
    this.iconHint,
  });
}

class PlatformConstants {
  static const List<TradingPlatform> platforms = [
    TradingPlatform(
      name: 'olymptrade',
      displayName: 'OlympTrade',
      url: 'https://olymptrade.com',
      cookieKey: 'access_token',
      colors: [0xFF6B46C1, 0xFF9333EA], // Purple gradient
      iconHint: 'chart_line',
    ),
    TradingPlatform(
      name: 'pocketoptions',
      displayName: 'PocketOptions',
      url: 'https://pocketoption.com',
      cookieKey: 'ci_session',
      type: PlatformType.pocketOption,
      userIdCookieKey: 'user_id',
      colors: [0xFF3B82F6, 0xFF1D4ED8], // Blue gradient
      iconHint: 'wallet',
    ),
    TradingPlatform(
      name: 'quotex',
      displayName: 'Quotex',
      url: 'https://quotex.io',
      cookieKey: 'access_token',
      colors: [0xFF10B981, 0xFF059669], // Green gradient
      iconHint: 'trending_up',
    ),
    TradingPlatform(
      name: 'binomo',
      displayName: 'Binomo',
      url: 'https://binomo.com',
      cookieKey: 'access_token',
      colors: [0xFFF59E0B, 0xFFD97706], // Amber gradient
      iconHint: 'bar_chart',
    ),
    TradingPlatform(
      name: 'iqoptions',
      displayName: 'IqOptions',
      url: 'https://iqoption.com',
      cookieKey: 'access_token',
      colors: [0xFFEF4444, 0xFFDC2626], // Red gradient
      iconHint: 'candlestick',
    ),
    TradingPlatform(
      name: 'expertoptions',
      displayName: 'Expert Options',
      url: 'https://expertoption.com',
      cookieKey: 'access_token',
      colors: [0xFF8B5CF6, 0xFF7C3AED], // Violet gradient
      iconHint: 'analytics',
    ),
    TradingPlatform(
      name: 'gmgn',
      displayName: 'GmGn',
      url: 'https://gmgn.ai',
      cookieKey: 'access_token',
      colors: [0xFF06B6D4, 0xFF0891B2], // Cyan gradient
      iconHint: 'auto_graph',
    ),
    TradingPlatform(
      name: 'axiomtrade',
      displayName: 'Axiom Trade',
      url: 'https://axiom.trade',
      cookieKey: '__Secure-next-auth.session-token',
      type: PlatformType.web3,
      alternateCookieKeys: [
        'next-auth.session-token',
        '__Secure-next-auth.callback-url',
        'session',
        'token',
        'access_token',
        '_session',
      ],
      jsTokenExtraction: '''
        (function() {
          var keys = ['token', 'session', 'access_token', 'auth_token', 'jwt',
                      'walletAddress', 'connectedWallet', 'axiom_session',
                      'next-auth.session-token', 'user'];
          var result = {};
          for (var i = 0; i < keys.length; i++) {
            var val = localStorage.getItem(keys[i]);
            if (val) result[keys[i]] = val;
            var sVal = sessionStorage.getItem(keys[i]);
            if (sVal) result['ss_' + keys[i]] = sVal;
          }
          // Also scan for any key containing 'token', 'session', 'auth', 'wallet'
          for (var j = 0; j < localStorage.length; j++) {
            var k = localStorage.key(j);
            if (k && (k.toLowerCase().indexOf('token') !== -1 ||
                      k.toLowerCase().indexOf('session') !== -1 ||
                      k.toLowerCase().indexOf('auth') !== -1 ||
                      k.toLowerCase().indexOf('wallet') !== -1)) {
              result[k] = localStorage.getItem(k);
            }
          }
          return JSON.stringify(result);
        })()
      ''',
      colors: [0xFF00D1FF, 0xFF0066FF], // Axiom blue gradient
      iconHint: 'diamond',
    ),
  ];
}
