#!/bin/bash

# SSID Finder - Quick Launch Script
# This script helps you quickly run the Flutter app

echo "🚀 SSID Finder - Quick Launch"
echo "=============================="
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null
then
    echo "❌ Flutter is not installed or not in PATH"
    echo "Please install Flutter from: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter is installed"
echo ""

# Get Flutter version
echo "📱 Flutter version:"
flutter --version | head -n 1
echo ""

# Change to project directory
cd "/Users/vigowalker/Chipa SSID Finder"

# Check for dependencies
if [ ! -d ".dart_tool" ]; then
    echo "📦 Installing dependencies..."
    flutter pub get
    echo ""
fi

# Show available devices
echo "📱 Available devices:"
flutter devices
echo ""

# Ask user which platform to run
echo "Which platform would you like to run?"
echo "1) Android"
echo "2) iOS"
echo "3) Chrome (Web - for testing UI only)"
echo "4) macOS"
read -p "Enter choice (1-4): " choice

case $choice in
    1)
        echo ""
        echo "🤖 Launching on Android..."
        flutter run
        ;;
    2)
        echo ""
        echo "🍎 Launching on iOS..."
        flutter run -d ios
        ;;
    3)
        echo ""
        echo "🌐 Launching in Chrome (Note: WebView features may not work)..."
        flutter run -d chrome
        ;;
    4)
        echo ""
        echo "💻 Launching on macOS..."
        flutter run -d macos
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac
