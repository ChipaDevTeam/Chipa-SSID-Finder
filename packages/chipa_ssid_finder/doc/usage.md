# Usage

There are two ways to use the package: the **drop-in widget** (handles the
WebView for you) and the **pure logic** (bring your own WebView).

## The drop-in widget

`SsidExtractionScreen` renders the platform's login page in an embedded browser
and extracts the SSID automatically once the session cookie is present.

```dart
SsidExtractionScreen(
  platform: PlatformConstants.platforms.first,
  onExtracted: (ssids) => debugPrint('$ssids'),
)
```

### Parameters

| Parameter | Type | Default | Purpose |
| --- | --- | --- | --- |
| `platform` | `TradingPlatform` | required | Which platform to extract from. |
| `onExtracted` | `SsidExtractedCallback?` | `null` | Called with the SSID map each time one is extracted. |
| `showResultSheet` | `bool` | `true` | Show the built-in result sheet on success. |
| `onClose` | `VoidCallback?` | `null` | Overrides the sheet's close action (defaults to `Navigator.pop`). |

### The result map

`onExtracted` (and the result sheet) receive a `Map<String, String>` whose keys
depend on the platform type:

| Platform type | Example result |
| --- | --- |
| `simple` | `{'token': 'eyJ...'}` |
| `pocketOption` | `{'demo': '42["auth",...]', 'real': '42["auth",...]'}` |
| `web3` | `{'session': '...', 'wallet': '0x...'}` |

### Callback-only mode

To build your own success UI, suppress the sheet and act on the callback:

```dart
SsidExtractionScreen(
  platform: platform,
  showResultSheet: false,
  onExtracted: (ssids) {
    myController.add(ssids);
    Navigator.of(context).pop(ssids);
  },
)
```

> `onExtracted` may fire more than once — for example when the user navigates
> within the site or taps reload — as fresh tokens become available. Debounce or
> take-first on your side if you only want a single result.

### Custom close behaviour

```dart
SsidExtractionScreen(
  platform: platform,
  onClose: () {
    // e.g. return to a dashboard instead of just popping
    Navigator.of(context).popUntil((r) => r.isFirst);
  },
)
```

## Pure logic (bring your own WebView)

If you already have a WebView, skip the widget and call the extractor directly.
Flatten your WebView's cookies into a `name -> value` map first.

```dart
final platform = PlatformConstants.platforms
    .firstWhere((p) => p.name == 'pocketoptions');

// cookieMap: Map<String, String> collected from your WebView
final cookieValue = SsidExtractor.findCookieValue(platform, cookieMap);
final userId = SsidExtractor.findUserId(platform, cookieMap);

if (cookieValue != null) {
  final ssids = SsidExtractor.format(platform, cookieValue, userId);
  // {'demo': ..., 'real': ...}
}
```

### Web3 platforms

Web3 platforms (e.g. Axiom Trade) may keep the token in `localStorage` rather
than a cookie. Run the platform's `jsTokenExtraction` snippet in your WebView
and pass the result to `tryParseWeb3Json`:

```dart
if (platform.type == PlatformType.web3 && cookieValue == null) {
  final jsResult = await myWebView.runJavaScriptReturningResult(
    platform.jsTokenExtraction!,
  );
  final web3 = SsidExtractor.tryParseWeb3Json(jsResult.toString());
  if (web3 != null) {
    // web3 is the formatted token map, e.g. {'session': ..., 'wallet': ...}
  }
}
```

`tryParseWeb3Json` returns `null` when the result is empty or not JSON; in that
case treat a non-trivial string as a raw token and pass it to
`SsidExtractor.format`.

## Reusing the result sheet

`SsidResultSheet` is exported so you can show the same styled result UI from
your own screen. It is a `Positioned` widget meant to be placed inside a `Stack`:

```dart
Stack(
  children: [
    myWebViewWidget,
    if (ssids != null)
      SsidResultSheet(
        platform: platform,
        formattedSSIDs: ssids!,
        onClose: () => setState(() => ssids = null),
      ),
  ],
)
```
