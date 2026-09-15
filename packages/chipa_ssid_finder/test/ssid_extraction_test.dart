import 'package:flutter_test/flutter_test.dart';
import 'package:chipa_ssid_finder/chipa_ssid_finder.dart';

void main() {
  TradingPlatform platformNamed(String name) =>
      PlatformConstants.platforms.firstWhere((p) => p.name == name);

  group('SsidExtractor.findCookieValue', () {
    test('returns the primary cookie when present', () {
      final olymp = platformNamed('olymptrade');
      final value = SsidExtractor.findCookieValue(olymp, {
        'access_token': 'abc123',
      });
      expect(value, 'abc123');
    });

    test('falls back to alternate cookie keys', () {
      final axiom = platformNamed('axiomtrade');
      final value = SsidExtractor.findCookieValue(axiom, {
        'session': 'fallback-token',
      });
      expect(value, 'fallback-token');
    });

    test('returns null when no known cookie is present', () {
      final olymp = platformNamed('olymptrade');
      expect(SsidExtractor.findCookieValue(olymp, {'unrelated': 'x'}), isNull);
    });

    test('ignores empty cookie values', () {
      final olymp = platformNamed('olymptrade');
      expect(SsidExtractor.findCookieValue(olymp, {'access_token': ''}), isNull);
    });
  });

  group('SsidExtractor.findUserId', () {
    test('reads the user-id cookie when the platform declares one', () {
      final pocket = platformNamed('pocketoptions');
      expect(
        SsidExtractor.findUserId(pocket, {'user_id': '42'}),
        '42',
      );
    });

    test('returns null when the platform has no user-id key', () {
      final olymp = platformNamed('olymptrade');
      expect(SsidExtractor.findUserId(olymp, {'user_id': '42'}), isNull);
    });
  });

  group('SsidExtractor.format', () {
    test('produces demo and real SSIDs for PocketOption', () {
      final pocket = platformNamed('pocketoptions');
      final result = SsidExtractor.format(pocket, 'ci-session-value', '99');
      expect(result.keys, containsAll(['demo', 'real']));
      expect(result['real'], contains('ci-session-value'));
      expect(result['real'], contains('"uid":99'));
      expect(result['real'], contains('"isDemo":0'));
      expect(result['demo'], contains('"isDemo":1'));
    });

    test('produces a simple token map for simple platforms', () {
      final olymp = platformNamed('olymptrade');
      expect(SsidExtractor.format(olymp, 'tok', null), {'token': 'tok'});
    });
  });

  group('SsidExtractor.tryParseWeb3Json', () {
    test('returns null for empty / non-JSON input', () {
      expect(SsidExtractor.tryParseWeb3Json(null), isNull);
      expect(SsidExtractor.tryParseWeb3Json(''), isNull);
      expect(SsidExtractor.tryParseWeb3Json('{}'), isNull);
      expect(SsidExtractor.tryParseWeb3Json('not json'), isNull);
    });

    test('parses a token map and surfaces the session token', () {
      final result = SsidExtractor.tryParseWeb3Json('{"token":"xyz"}');
      expect(result, isNotNull);
      expect(result!['session'], 'xyz');
    });
  });

  group('SSIDFormatter.formatWeb3Tokens', () {
    test('prefers priority keys and extracts wallet address', () {
      final result = SSIDFormatter.formatWeb3Tokens({
        'jwt': 'jwt-token',
        'walletAddress': '0xABC',
      });
      expect(result['session'], 'jwt-token');
      expect(result['wallet'], '0xABC');
    });

    test('falls back to discovered tokens when no priority key exists', () {
      final result = SSIDFormatter.formatWeb3Tokens({'foo': 'bar'});
      expect(result['token'], 'bar');
    });
  });
}
