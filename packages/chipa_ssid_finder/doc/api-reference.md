# API reference

Everything below is exported from the single entry point:

```dart
import 'package:chipa_ssid_finder/chipa_ssid_finder.dart';
```

---

## `ChipaSsidFinder`

One-time setup helpers.

### `static Future<void> ensureInitialized({String userAgent = defaultLinuxUserAgent})`

Initialises the WebView backend for the current platform. On Linux this boots
the CEF runtime; on all other platforms it is a no-op. Call once after
`WidgetsFlutterBinding.ensureInitialized()` and before showing an extraction
screen.

- `userAgent` — the UA CEF reports (Linux only). Defaults to
  `defaultLinuxUserAgent`.

### `static const String defaultLinuxUserAgent`

A desktop Linux Chrome user-agent string used by the CEF runtime.

---

## `SsidExtractionScreen`

A `StatelessWidget` that renders the platform login page and extracts the SSID
automatically, choosing the correct WebView backend per platform.

### Constructor

```dart
const SsidExtractionScreen({
  Key? key,
  required TradingPlatform platform,
  SsidExtractedCallback? onExtracted,
  bool showResultSheet = true,
  VoidCallback? onClose,
})
```

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `platform` | `TradingPlatform` | required | Platform to extract from. |
| `onExtracted` | `SsidExtractedCallback?` | `null` | Fired with the SSID map on each successful extraction (may fire multiple times). |
| `showResultSheet` | `bool` | `true` | Whether to show the built-in `SsidResultSheet`. |
| `onClose` | `VoidCallback?` | `null` | Overrides the result sheet's close action; defaults to `Navigator.pop`. |

---

## `SsidExtractedCallback`

```dart
typedef SsidExtractedCallback = void Function(Map<String, String> ssids);
```

Signature for `SsidExtractionScreen.onExtracted`. The map is the labelled token
map produced by `SsidExtractor.format` (or the Web3 parser).

---

## `TradingPlatform`

Immutable description of a platform to extract from.

```dart
const TradingPlatform({
  required String name,
  required String url,
  required String cookieKey,
  required String displayName,
  required List<int> colors,
  PlatformType type = PlatformType.simple,
  String? userIdCookieKey,
  List<String>? alternateCookieKeys,
  String? jsTokenExtraction,
  String? iconHint,
})
```

| Field | Type | Description |
| --- | --- | --- |
| `name` | `String` | Stable identifier (e.g. `'olymptrade'`). |
| `displayName` | `String` | Human-readable name shown in the UI. |
| `url` | `String` | Login page URL loaded in the WebView. |
| `cookieKey` | `String` | Primary session cookie name. |
| `colors` | `List<int>` | Two ARGB ints `[start, end]` for the gradient. |
| `type` | `PlatformType` | Extraction/formatting strategy. Default `simple`. |
| `userIdCookieKey` | `String?` | Cookie holding the user id (PocketOption). |
| `alternateCookieKeys` | `List<String>?` | Fallback cookie names, tried in order. |
| `jsTokenExtraction` | `String?` | JS snippet returning a JSON token map (Web3). |
| `iconHint` | `String?` | Optional icon identifier hint for host UIs. |

---

## `PlatformType`

```dart
enum PlatformType { simple, pocketOption, web3 }
```

- `simple` — cookie value returned as `{'token': value}`.
- `pocketOption` — builds demo + real `42["auth",{...}]` SSIDs.
- `web3` — checks cookies plus `localStorage`/`sessionStorage`.

---

## `PlatformConstants`

### `static const List<TradingPlatform> platforms`

The eight bundled platform definitions. See [Supported platforms](platforms.md).

---

## `SsidExtractor`

Stateless, WebView-agnostic extraction helpers. All static.

### `static String? findCookieValue(TradingPlatform platform, Map<String, String> cookies)`

Returns the primary session cookie value, falling back to
`alternateCookieKeys`. Returns `null` if none is present or all are empty.

### `static String? findUserId(TradingPlatform platform, Map<String, String> cookies)`

Returns the `userIdCookieKey` value if the platform declares one and it is
present; otherwise `null`.

### `static Map<String, String> format(TradingPlatform platform, String value, String? userId)`

Formats a raw cookie value into the labelled SSID map, dispatching on
`platform.type`.

### `static Map<String, String>? tryParseWeb3Json(String? jsResult)`

Interprets a Web3 JS extraction result as a JSON token map and formats it.
Returns `null` when the input is `null`, empty, `{}`, or not valid JSON — in
which case the caller should treat a non-trivial string as a raw token.

---

## `SSIDFormatter`

Lower-level formatters used by `SsidExtractor`. All static.

### `static Map<String, String> formatPocketOptionSSID(String ciSession, String? userId)`

Returns `{'demo': ..., 'real': ...}` in PocketOption's socket-auth format. The
real SSID embeds the escaped `ciSession` and the `userId` (falling back to a
default UID when `userId` is `null`).

### `static Map<String, String> formatSimpleSSID(String value)`

Returns `{'token': value}`.

### `static Map<String, String> formatWeb3Tokens(Map<String, dynamic> tokens)`

Labels a discovered-token map: picks the first priority key as `session`, adds a
`wallet` entry if present, and otherwise lists up to five discovered tokens.

---

## `SsidResultSheet`

A `StatelessWidget` (a `Positioned` for use inside a `Stack`) that renders the
extracted SSIDs with copy-to-clipboard buttons and a close button.

```dart
const SsidResultSheet({
  Key? key,
  required TradingPlatform platform,
  required Map<String, String> formattedSSIDs,
  required VoidCallback onClose,
})
```

| Field | Type | Description |
| --- | --- | --- |
| `platform` | `TradingPlatform` | Drives the header text and gradient colours. |
| `formattedSSIDs` | `Map<String, String>` | The SSID map to display. |
| `onClose` | `VoidCallback` | Called when the close button is tapped. |
