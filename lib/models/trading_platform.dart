enum PlatformType {
  simple,      // Just displays the cookie value (OlympTrade)
  pocketOption // Special formatting for PocketOption
}

class TradingPlatform {
  final String name;
  final String url;
  final String cookieKey;
  final String displayName;
  final List<int> colors;
  final PlatformType type;
  final String? userIdCookieKey; // For extracting user ID if needed

  const TradingPlatform({
    required this.name,
    required this.url,
    required this.cookieKey,
    required this.displayName,
    required this.colors,
    this.type = PlatformType.simple,
    this.userIdCookieKey,
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
    ),
    TradingPlatform(
      name: 'pocketoptions',
      displayName: 'PocketOptions',
      url: 'https://pocketoption.com/en/login',
      cookieKey: 'ci_session',
      type: PlatformType.pocketOption,
      userIdCookieKey: 'user_id',
      colors: [0xFF3B82F6, 0xFF1D4ED8], // Blue gradient
    ),
    TradingPlatform(
      name: 'quotex',
      displayName: 'Quotex',
      url: 'https://quotex.io',
      cookieKey: 'access_token',
      colors: [0xFF10B981, 0xFF059669], // Green gradient
    ),
    TradingPlatform(
      name: 'binomo',
      displayName: 'Binomo',
      url: 'https://binomo.com',
      cookieKey: 'access_token',
      colors: [0xFFF59E0B, 0xFFD97706], // Amber gradient
    ),
    TradingPlatform(
      name: 'iqoptions',
      displayName: 'IqOptions',
      url: 'https://iqoption.com',
      cookieKey: 'access_token',
      colors: [0xFFEF4444, 0xFFDC2626], // Red gradient
    ),
    TradingPlatform(
      name: 'expertoptions',
      displayName: 'Expert Options',
      url: 'https://expertoption.com',
      cookieKey: 'access_token',
      colors: [0xFF8B5CF6, 0xFF7C3AED], // Violet gradient
    ),
    TradingPlatform(
      name: 'gmgn',
      displayName: 'GmGn',
      url: 'https://gmgn.ai',
      cookieKey: 'access_token',
      colors: [0xFF06B6D4, 0xFF0891B2], // Cyan gradient
    ),
    TradingPlatform(
      name: 'axiomtrade',
      displayName: 'AxiomTrade',
      url: 'https://axiomtrade.com',
      cookieKey: 'access_token',
      colors: [0xFFEC4899, 0xFFDB2777], // Pink gradient
    ),
  ];
}
