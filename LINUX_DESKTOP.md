# Linux Desktop Support

The app runs on Linux desktop. Because `flutter_inappwebview` has **no Linux
implementation**, Linux uses a CEF-backed WebView (`webview_cef`) for the
cookie/SSID extraction, while Android, iOS, macOS and Windows keep using
`flutter_inappwebview`. The extraction logic and result UI are shared across
all platforms.

## Architecture

| Layer | File |
|-------|------|
| Platform router (picks WebView per OS) | `lib/screens/extraction_screen.dart` |
| Mobile / macOS / Windows WebView | `lib/screens/webview_screen.dart` (flutter_inappwebview) |
| Linux WebView | `lib/screens/webview_screen_linux.dart` (webview_cef / CEF) |
| Shared cookie → SSID logic | `lib/utils/ssid_extractor.dart` |
| Shared result sheet UI | `lib/screens/ssid_result_sheet.dart` |
| CEF runtime init (Linux only) | `lib/main.dart` |

On Linux, CEF reads cookies through its own cookie manager
(`WebviewManager().visitAllCookies()`), so **HttpOnly session tokens are
captured** — the same tokens the mobile app extracts.

## Build prerequisites (one-time)

Install the standard Flutter Linux desktop toolchain plus a few CEF runtime
libraries:

```bash
sudo apt update && sudo apt install -y \
  clang cmake ninja-build pkg-config libgtk-3-dev \
  mesa-utils libnss3 libnspr4 libgbm1 libasound2t64 xclip
```

> On older Ubuntu/Debian, use `libasound2` instead of `libasound2t64`.

`xclip` is optional at build time but **required at runtime for clipboard
paste inside the CEF WebView** — without it users can't paste passwords into
platform login forms. Ship it as a package dependency (`.deb`) or bundle a
copy for AppImage.

Verify the toolchain:

```bash
flutter doctor
```

The `Linux toolchain` line should show `✓`.

## Build & run

```bash
flutter config --enable-linux-desktop   # already enabled in this repo
flutter pub get
flutter run -d linux                     # debug
flutter build linux --release            # release
```

> **First build is slow.** CEF's Standard Distribution (~330 MB) is downloaded
> into `linux/third/cef` and `libcef_dll_wrapper` is compiled from source.
> Subsequent builds reuse it.

Release output:

```
build/linux/x64/release/bundle/
```

The whole `bundle/` directory (executable + `lib/` + CEF `.so`s + `data/`)
must be shipped together.

## Packaging

**Strip the CEF binary first.** The release bundle is ~1.5 GB because the
prebuilt `lib/libcef.so` ships unstripped (~1.3 GB of debug symbols). Strip it
before packaging to bring the bundle down to ~200 MB:

```bash
strip build/linux/x64/release/bundle/lib/libcef.so
```

Then package the whole `bundle/` directory (executable + `lib/` + CEF `.so`s +
`.pak` resources + `data/`) together:

- **Tarball:** `tar czf ChipaSSIDFinder-linux-x64.tar.gz -C build/linux/x64/release/bundle .`
- **AppImage / .deb / Flatpak:** wrap the `bundle/` directory. AppImage is the
  simplest for direct distribution; Flatpak for Flathub. Declare `xclip` as a
  runtime dependency (or bundle it).

## Notes / limitations

- Linux CEF uses the software rendering path (no GPU zero-copy), so it is a
  little heavier than Windows/macOS CEF — fine for this app's usage.
- The CEF binaries are large; the release bundle is ~150–250 MB.
- `webview_cef`'s CMake automatically patches the Linux runner
  (`linux/runner/my_application.cc` and `main.cc`) at build time to wire up CEF
  init and keyboard events — no manual native edits are required.
