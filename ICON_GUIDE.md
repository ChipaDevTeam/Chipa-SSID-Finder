# App Icon Generation Guide

## Icon Design

The app icon features:
- **Background**: Purple gradient (#6B46C1 to #9333EA)
- **Symbol**: White key icon representing security/access
- **Badge**: "SSID" text at the bottom
- **Style**: Modern, minimal, Material Design 3

## Files Created

### 1. Source Icon
- **File**: `app_icon.svg`
- **Format**: SVG (Scalable Vector Graphics)
- **Size**: 512x512px
- **Use**: Can be scaled to any size without quality loss

### 2. Google Play Assets Needed

For Google Play Console, you need:

#### High-res Icon (Required)
- **Size**: 512x512 pixels
- **Format**: PNG (32-bit with alpha)
- **File**: Use the exported `app_icon_512.png`

#### Feature Graphic (Required)
- **Size**: 1024x500 pixels
- **Format**: PNG or JPEG
- **File**: `feature_graphic.png` (to be created)

#### Screenshots (Required)
- **Minimum**: 2 screenshots
- **Format**: PNG or JPEG
- **Size**: Phone screenshots should be 16:9 or 9:16 aspect ratio

## How to Generate PNG from SVG

### Option 1: Using Online Tools (Easiest)
1. Go to https://cloudconvert.com/svg-to-png
2. Upload `app_icon.svg`
3. Set size to 512x512
4. Download the PNG

### Option 2: Using ImageMagick (Command Line)
```bash
# Install ImageMagick (if not installed)
brew install imagemagick

# Convert SVG to PNG
convert -background none -size 512x512 app_icon.svg app_icon_512.png
```

### Option 3: Using Inkscape (Free Software)
1. Download Inkscape from https://inkscape.org
2. Open `app_icon.svg`
3. File > Export PNG Image
4. Set width/height to 512
5. Export

### Option 4: Using Flutter Icon Generator (Recommended)
```bash
# Add to pubspec.yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"
  adaptive_icon_background: "#6B46C1"
  adaptive_icon_foreground: "assets/icon/icon_foreground.png"

# Then run
flutter pub get
flutter pub run flutter_launcher_icons
```

## Manual Icon Setup (Already Done)

The app currently uses XML drawables for the icon:
- `/android/app/src/main/res/drawable/ic_launcher_foreground.xml`
- `/android/app/src/main/res/values/colors.xml`
- `/android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml`

## For Google Play Store

### Required Assets

1. **App Icon (512x512)**
   - Use: `app_icon_512.png`
   - Upload to: Store listing > Store settings

2. **Feature Graphic (1024x500)**
   - Create a banner version
   - Should include app name: "Chipa SSID Finder"
   - Use same color scheme

3. **Screenshots**
   - Take screenshots of:
     - Platform selector screen
     - OlympTrade WebView with SSID
     - PocketOptions with Demo/Real SSID
   - Minimum 2, maximum 8

4. **App Description**
   ```
   Chipa SSID Finder - Extract Trading Platform Tokens

   Easily extract SSID authentication tokens from popular trading platforms:
   ✅ OlympTrade
   ✅ PocketOptions (Demo & Real)
   ✅ Quotex
   ✅ Binomo
   ✅ IqOptions
   ✅ Expert Options
   ✅ GmGn
   ✅ AxiomTrade

   Features:
   🎨 Modern Material Design 3 UI
   🔐 Secure in-app login
   📋 One-tap copy to clipboard
   🌗 Dark mode support
   ⚡ Fast and lightweight

   How it works:
   1. Select your trading platform
   2. Log in securely in the app
   3. SSID automatically extracted
   4. Copy and use instantly!

   Perfect for traders who need quick access to their session tokens.
   ```

5. **Short Description**
   ```
   Extract SSID tokens from trading platforms with ease. Supports 8+ platforms.
   ```

## Color Scheme

- **Primary**: #6B46C1 (Purple)
- **Secondary**: #9333EA (Bright Purple)
- **Accent**: #3B82F6 (Blue - for PocketOptions)
- **Background**: Gradient from Primary to Secondary

## Icon Sizes for Android

The app automatically generates these sizes:
- mipmap-mdpi: 48x48px
- mipmap-hdpi: 72x72px
- mipmap-xhdpi: 96x96px
- mipmap-xxhdpi: 144x144px
- mipmap-xxxhdpi: 192x192px

## Export the Icon

To get a PNG for Google Play:

1. Open the SVG in any image editor
2. Export as PNG at 512x512
3. Save as `app_icon_512.png`
4. This is your Google Play icon!

Alternatively, I can help you convert it using an online tool or ImageMagick if you have it installed.
