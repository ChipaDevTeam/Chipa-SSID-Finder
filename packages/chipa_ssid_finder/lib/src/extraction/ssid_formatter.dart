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

  /// Formats Web3/DeFi platform tokens extracted from cookies or localStorage
  /// Returns a map with labeled token entries
  static Map<String, String> formatWeb3Tokens(Map<String, dynamic> tokens) {
    final result = <String, String>{};
    
    // Priority order for display
    const priorityKeys = ['token', 'session', 'access_token', 'auth_token', 'jwt',
                           'next-auth.session-token', '__Secure-next-auth.session-token'];
    
    // First add priority keys if present
    for (final key in priorityKeys) {
      if (tokens.containsKey(key) && tokens[key] != null) {
        result['session'] = tokens[key].toString();
        break;
      }
    }
    
    // Add wallet address if found
    const walletKeys = ['walletAddress', 'connectedWallet', 'wallet'];
    for (final key in walletKeys) {
      if (tokens.containsKey(key) && tokens[key] != null) {
        result['wallet'] = tokens[key].toString();
        break;
      }
      // Check localStorage prefixed keys
      if (tokens.containsKey(key) && tokens[key] != null) {
        result['wallet'] = tokens[key].toString();
        break;
      }
    }
    
    // If no priority keys found, add all discovered tokens
    if (result.isEmpty) {
      var index = 0;
      for (final entry in tokens.entries) {
        if (entry.value != null && entry.value.toString().isNotEmpty) {
          final label = index == 0 ? 'token' : 'token_${index + 1}';
          result[label] = entry.value.toString();
          index++;
          if (index >= 5) break; // Limit to 5 tokens
        }
      }
    }
    
    return result;
  }
}
