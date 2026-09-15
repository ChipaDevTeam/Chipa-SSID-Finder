# How it works

## The extraction pipeline

```
User opens SsidExtractionScreen(platform)
        │
        ▼
Widget picks a WebView backend for the current OS
   ├─ Linux ............. webview_cef (CEF/Chromium)
   └─ everything else ... flutter_inappwebview
        │
        ▼
Platform login page loads; user logs in normally
        │
        ▼
On every page load / navigation → _checkForSSID()
        │
        ├─ Collect all cookies → flatten to Map<String,String>
        │
        ├─ SsidExtractor.findCookieValue(platform, cookies)
        │     tries platform.cookieKey, then alternateCookieKeys
        │
        ├─ SsidExtractor.findUserId(...)  (PocketOption only)
        │
        ├─ If web3 and no cookie yet:
        │     run platform.jsTokenExtraction in the page
        │     → SsidExtractor.tryParseWeb3Json(result)
        │
        ▼
SsidExtractor.format(platform, value, userId)
        │
        ▼
onExtracted(map)  and/or  SsidResultSheet shows the map
```

## Why two WebView backends

`flutter_inappwebview` is the primary backend and covers Android, iOS, macOS and
Windows. It has **no Linux implementation**, so Linux falls back to
`webview_cef`, which embeds a full Chromium (CEF) instance. CEF can also read
**HttpOnly** cookies through its cookie manager, which is important because many
session tokens are HttpOnly.

The two backends normalise their very different cookie APIs into the same
`Map<String, String>` and then call the identical shared logic in
`SsidExtractor`, so extraction behaves the same everywhere.

## Cookie normalisation

- **flutter_inappwebview**: `CookieManager.getCookies(url:)` returns a list of
  cookies; the widget maps each `cookie.name → cookie.value`.
- **webview_cef**: `WebviewManager().visitAllCookies()` returns a nested
  `domain → {name: value}` structure; the widget flattens it into one
  `name → value` map (so HttpOnly tokens are included).

## Formatting rules

`SsidExtractor.format` dispatches on `platform.type`:

- `pocketOption` → `SSIDFormatter.formatPocketOptionSSID` builds the
  `42["auth",{...}]` payloads for both a demo and a real account. The real SSID
  embeds the escaped `ci_session` value and the `user_id`; the demo SSID uses a
  fixed sample session.
- everything else → `SSIDFormatter.formatSimpleSSID`, i.e. `{'token': value}`.

For `web3`, `SSIDFormatter.formatWeb3Tokens` picks the first present
priority key (`token`, `session`, `access_token`, `jwt`, …) as `session`,
surfaces a `wallet` address if found, and otherwise falls back to listing up to
five discovered tokens.

## When extraction fires

`_checkForSSID()` runs on page-load-stop and on navigation. It is guarded by an
`isCheckingCookies` flag so overlapping calls are ignored. Because it can fire
repeatedly, `onExtracted` may be called more than once during a session.

## Failure handling

- Cookie/JS errors are caught and logged via `debugPrint`; they never crash the
  screen.
- On Linux, if the CEF runtime fails to initialise, the screen renders a
  "Could not start the browser engine" panel instead of the WebView.
