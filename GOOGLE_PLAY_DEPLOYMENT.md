# Google Play Store Deployment Guide

## ✅ Pre-Deployment Checklist

### App Configuration
- [x] Package name changed to: `com.chipaway.ssid_finder`
- [x] Version: 1.0.0 (versionCode: 1)
- [x] App name: "Chipa SSID Finder"
- [x] Permissions configured (Internet, Network State)
- [x] ProGuard rules added
- [x] Network security config added
- [x] App icon created

### Build Configuration
- [x] Release build type configured
- [x] Code minification enabled
- [x] Resource shrinking enabled
- [x] Target SDK: 36
- [x] Min SDK: 21 (Android 5.0+)

## 📝 Step 1: Generate Release Keystore

You need to create a keystore for signing your app:

```bash
cd "/Users/vigowalker/Chipa SSID Finder/android/app"

keytool -genkey -v -keystore release-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias release-key
```

**Important**: Save the passwords! You'll need them.

Then create `key.properties` in `/android/` folder:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=release-key
storeFile=../app/release-keystore.jks
```

### Update build.gradle

Replace the signingConfigs section in `android/app/build.gradle`:

```groovy
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... existing code ...
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

## 🏗️ Step 2: Build Release APK/AAB

### Build App Bundle (AAB) - Recommended for Play Store

```bash
cd "/Users/vigowalker/Chipa SSID Finder"
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### Build APK (Alternative)

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

## 📱 Step 3: Test the Release Build

### Install and test:

```bash
# For AAB (need bundletool)
java -jar bundletool.jar build-apks \
  --bundle=build/app/outputs/bundle/release/app-release.aab \
  --output=app.apks \
  --mode=universal

# Extract and install
unzip -p app.apks universal.apk > app-universal.apk
adb install app-universal.apk

# For APK
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Test checklist:
- [ ] App launches successfully
- [ ] OlympTrade login and SSID extraction works
- [ ] PocketOptions shows Demo & Real SSIDs
- [ ] All 8 platforms display correctly
- [ ] Copy to clipboard works
- [ ] No crashes or errors
- [ ] App works on different Android versions (if possible)

## 🎨 Step 4: Prepare Store Assets

### Required Assets

1. **App Icon (512x512 PNG)**
   - File: `app_icon.svg` (convert to PNG)
   - See `ICON_GUIDE.md` for conversion instructions

2. **Feature Graphic (1024x500 PNG/JPG)**
   - Create a banner with app name and icon
   - Use the purple gradient theme

3. **Screenshots (PNG/JPG)**
   - Minimum 2, maximum 8 screenshots
   - Phone: 16:9 or 9:16 aspect ratio
   - Recommended size: 1080x1920 or 1080x2340

   Suggested screenshots:
   - Home screen with 8 platform cards
   - OlympTrade with SSID displayed
   - PocketOptions with Demo/Real SSIDs
   - Copy success notification

4. **Privacy Policy URL**
   - Required for apps that access internet
   - Can host on GitHub Pages or your website
   - See `PRIVACY_POLICY.md` template below

## 📋 Step 5: Google Play Console Setup

### Create App Listing

1. Go to [Google Play Console](https://play.google.com/console)
2. Click "Create app"
3. Fill in:
   - **App name**: Chipa SSID Finder
   - **Default language**: English (United States)
   - **App type**: App
   - **Free/Paid**: Free

### Store Listing

**App name**: Chipa SSID Finder

**Short description** (80 chars max):
```
Extract SSID tokens from trading platforms. Supports 8+ platforms instantly.
```

**Full description** (4000 chars max):
```
🔑 Chipa SSID Finder - Extract Trading Platform Tokens with Ease

Quickly and securely extract SSID authentication tokens from popular trading platforms. Perfect for traders who need instant access to their session tokens.

✅ SUPPORTED PLATFORMS

• OlympTrade - Instant token extraction
• PocketOptions - Both Demo & Real SSID
• Quotex
• Binomo
• IqOptions
• Expert Options
• GmGn
• AxiomTrade

🎨 FEATURES

✨ Modern Material Design 3 UI
🔐 Secure in-app login via WebView
📋 One-tap copy to clipboard
🌗 Automatic dark/light mode
⚡ Fast and lightweight
🎯 Simple 3-step process
🔄 Support for multiple account types

📱 HOW IT WORKS

1. Select Your Platform
   Choose from 8 popular trading platforms in a beautiful grid layout

2. Secure Login
   Log in directly within the app using a secure WebView - your credentials never leave your device

3. Instant Extraction
   SSID tokens are automatically detected and displayed in an easy-to-copy format

4. Copy & Use
   One tap to copy your token to clipboard and use it wherever you need

🔐 SECURITY & PRIVACY

• No credentials stored
• Secure WebView implementation
• Cookies only extracted, never modified
• Your data stays on your device
• No tracking or analytics

💡 SPECIAL FEATURES

PocketOptions Support:
Automatically generates both Demo and Real account SSIDs from a single login, saving you time and effort.

Modern Interface:
Each platform has its own unique color gradient, making navigation intuitive and beautiful.

🎯 WHO IS THIS FOR?

• Traders needing quick SSID access
• Users managing multiple trading accounts
• Anyone requiring session token extraction
• Developers testing trading APIs

📊 SUPPORTED ANDROID VERSIONS

• Android 5.0 (Lollipop) and above
• Optimized for modern Android versions
• Works on phones and tablets

🆕 VERSION 1.0.0

Initial release with support for 8 trading platforms and full SSID extraction capabilities.

💬 FEEDBACK & SUPPORT

Have suggestions or found a bug? Contact us through the app or visit our GitHub repository.

⚠️ DISCLAIMER

This app is designed for legitimate use by account holders to access their own session tokens. Always follow the terms of service of your trading platform.
```

**App category**: Tools

**Tags**: trading, tools, security, tokens

**Email**: your-email@example.com

**Privacy Policy**: [Your Privacy Policy URL]

### Content Rating

1. Fill out the questionnaire
2. Answer questions about your app's content
3. Should get a rating of "Everyone" or "PEGI 3"

### App Content

- **Privacy Policy**: Required - Upload URL
- **App Access**: All functionality available without login
- **Ads**: No ads
- **In-app purchases**: None
- **Target audience**: Adults
- **Data safety**: Fill out data collection questionnaire
  - Data collected: None
  - Data shared: None
  - Security practices: Data encrypted in transit

### Release

1. **Countries**: Select countries (or "All countries")
2. **Upload AAB/APK**: Upload `app-release.aab`
3. **Release name**: Version 1.0.0
4. **Release notes**:
   ```
   🎉 Initial Release - Version 1.0.0
   
   ✨ Features:
   • Support for 8 trading platforms
   • OlympTrade with instant token extraction
   • PocketOptions with Demo & Real SSID generation
   • Modern Material Design 3 interface
   • One-tap copy to clipboard
   • Dark mode support
   • Secure WebView login
   
   Supported Platforms:
   • OlympTrade ✅
   • PocketOptions ✅
   • Quotex, Binomo, IqOptions, Expert Options, GmGn, AxiomTrade
   ```

## 🚀 Step 6: Submit for Review

1. Review all sections
2. Check for any warnings or errors
3. Click "Send for review"
4. Wait for approval (typically 1-7 days)

## 📊 Post-Launch

### Monitor

- Check crash reports in Play Console
- Monitor reviews and ratings
- Track download statistics

### Updates

To release an update:
1. Update version in `pubspec.yaml`: `1.0.1+2`
2. Update versionCode and versionName in `build.gradle`
3. Build new AAB
4. Upload to Play Console
5. Fill in release notes

## 🔧 Troubleshooting

### Build fails
```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

### Signing issues
- Verify `key.properties` exists and has correct paths
- Check keystore file location
- Verify passwords are correct

### Upload rejected
- Ensure minSdkVersion is at least 21
- Check targetSdkVersion is current (36)
- Verify all required permissions are declared

## 📁 Files Created for Deployment

- ✅ `android/app/proguard-rules.pro` - Code obfuscation rules
- ✅ `android/app/src/main/res/xml/network_security_config.xml` - Network config
- ✅ `app_icon.svg` - Source icon file
- ✅ `ICON_GUIDE.md` - Icon generation guide
- ✅ Package name updated to `com.chipaway.ssid_finder`
- ✅ Version set to 1.0.0
- ✅ ProGuard enabled
- ✅ Code minification enabled

## 🎯 Current Status

✅ **Ready for keystore generation and release build!**

Next steps:
1. Generate release keystore
2. Update signing config
3. Build release AAB
4. Prepare store assets (icon PNG, screenshots)
5. Create Google Play Console listing
6. Submit for review

---

**Need help?** Check the troubleshooting section or open an issue on GitHub.
