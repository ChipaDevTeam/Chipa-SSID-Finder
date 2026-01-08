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
    
    // For demo account - use a clean, simple session format
    // Demo sessions use a simple alphanumeric session ID
    final demoSessionId = 'vtftn12e6f5f5008moitsd6skl';
    final demoUid = '27658142';
    
    final demoSSID = '42["auth",{"session":"$demoSessionId","isDemo":1,"uid":$demoUid,"platform":2,"isFastHistory":true,"isOptimized":true}]';
    
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
