# Supported platforms

## Bundled definitions

`PlatformConstants.platforms` ships ready-made definitions for eight trading
platforms:

| `name` | Display name | URL | Type | Session cookie |
| --- | --- | --- | --- | --- |
| `olymptrade` | OlympTrade | https://olymptrade.com | `simple` | `access_token` |
| `pocketoptions` | PocketOptions | https://pocketoption.com | `pocketOption` | `ci_session` (+ `user_id`) |
| `quotex` | Quotex | https://quotex.io | `simple` | `access_token` |
| `binomo` | Binomo | https://binomo.com | `simple` | `access_token` |
| `iqoptions` | IqOptions | https://iqoption.com | `simple` | `access_token` |
| `expertoptions` | Expert Options | https://expertoption.com | `simple` | `access_token` |
| `gmgn` | GmGn | https://gmgn.ai | `simple` | `access_token` |
| `axiomtrade` | Axiom Trade | https://axiom.trade | `web3` | `__Secure-next-auth.session-token` (+ alternates) |

Look one up by name:

```dart
final quotex = PlatformConstants.platforms
    .firstWhere((p) => p.name == 'quotex');
```

## Platform types

`PlatformType` controls how the raw cookie value is turned into the result map:

- **`simple`** — returns the cookie value directly as `{'token': value}`.
- **`pocketOption`** — builds both a Demo and a Real SSID in PocketOption's
  `42["auth",{...}]` socket format, using the `user_id` cookie for the real UID.
- **`web3`** — checks cookies *and* `localStorage`/`sessionStorage` (via
  `jsTokenExtraction`), then labels the discovered token(s) and any wallet
  address.

## Defining a custom platform

`SsidExtractionScreen` accepts any `TradingPlatform`, so you are not limited to
the bundled list.

### Simple platform

```dart
const myPlatform = TradingPlatform(
  name: 'example',
  displayName: 'Example Broker',
  url: 'https://example.com',
  cookieKey: 'access_token',
  colors: [0xFF6B46C1, 0xFF9333EA], // gradient [start, end] as ARGB ints
);
```

### With fallback cookie names

If the session cookie is named inconsistently, list fallbacks — the extractor
tries `cookieKey` first, then each `alternateCookieKeys` entry in order:

```dart
const myPlatform = TradingPlatform(
  name: 'example',
  displayName: 'Example Broker',
  url: 'https://example.com',
  cookieKey: '__Secure-session',
  alternateCookieKeys: ['session', 'token', 'access_token'],
  colors: [0xFF00D1FF, 0xFF0066FF],
);
```

### PocketOption-style (demo + real)

```dart
const myPlatform = TradingPlatform(
  name: 'example',
  displayName: 'Example',
  url: 'https://example.com',
  cookieKey: 'ci_session',
  type: PlatformType.pocketOption,
  userIdCookieKey: 'user_id',
  colors: [0xFF3B82F6, 0xFF1D4ED8],
);
```

### Web3 / localStorage token

Provide a `jsTokenExtraction` snippet that returns a JSON string of discovered
tokens; the extractor parses it and labels the result.

```dart
const myPlatform = TradingPlatform(
  name: 'example',
  displayName: 'Example DeFi',
  url: 'https://example.trade',
  cookieKey: 'session-token',
  type: PlatformType.web3,
  alternateCookieKeys: ['token', 'access_token'],
  jsTokenExtraction: '''
    (function() {
      var out = {};
      var t = localStorage.getItem('token');
      if (t) out['token'] = t;
      return JSON.stringify(out);
    })()
  ''',
  colors: [0xFF10B981, 0xFF059669],
);
```

See the `axiomtrade` entry in the source for a fuller Web3 extraction snippet
that also scans every storage key for `token`/`session`/`auth`/`wallet`.

## Combining bundled + custom

```dart
final platforms = [
  ...PlatformConstants.platforms,
  myPlatform,
];
```
