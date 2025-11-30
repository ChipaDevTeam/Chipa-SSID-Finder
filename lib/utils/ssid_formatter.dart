class SSIDFormatter {
  /// Formats PocketOption SSID from ci_session cookie
  /// Returns a map with 'demo' and 'real' SSIDs
  static Map<String, String> formatPocketOptionSSID(
    String ciSession,
    String? userId,
  ) {
    // Extract the actual UID from cookies if available, otherwise use default
    final uid = userId ?? '101884312';
    
    // Escape the cookie value for JSON
    final escapedSession = ciSession
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"');
    
    // For demo account
    // Extract just the session ID part if the ci_session looks like a serialized PHP session
    String demoSessionId = ciSession;
    if (ciSession.contains('session_id')) {
      // Try to extract a simpler session ID for demo
      // In real scenarios, demo might use a different format
      demoSessionId = ciSession.split(';').first;
    }
    
    final demoSSID = '42["auth",{"session":"$demoSessionId","isDemo":1,"uid":$uid,"platform":1,"isFastHistory":true,"isOptimized":true}]';
    
    // For real account
    final realSSID = '42["auth",{"session":"$escapedSession","isDemo":0,"uid":$uid,"platform":1,"isFastHistory":true,"isOptimized":true}]';
    
    return {
      'demo': demoSSID,
      'real': realSSID,
    };
  }
  
  /// Simple formatter for platforms that just return the cookie value
  static Map<String, String> formatSimpleSSID(String value) {
    return {
      'token': value,
    };
  }
}
