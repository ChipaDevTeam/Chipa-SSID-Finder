#!/bin/bash

# Chipa SSID Finder - Release Build Script
# This script helps generate keystore and build release AAB for Google Play

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project directory
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$PROJECT_DIR"

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  Chipa SSID Finder - Release Build Script${NC}"
echo -e "${BLUE}================================================${NC}\n"

# Function to print section headers
print_section() {
    echo -e "\n${GREEN}➜ $1${NC}\n"
}

# Function to print warnings
print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Function to print errors
print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Function to print success
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Check if Flutter is installed
print_section "Checking Flutter installation"
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi
print_success "Flutter found: $(flutter --version | head -n 1)"

# Check if keytool is installed
print_section "Checking Java keytool"
KEYTOOL=""
if [ -f "/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/keytool" ]; then
    KEYTOOL="/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/keytool"
    print_success "keytool found (Android Studio Java)"
elif command -v keytool &> /dev/null; then
    KEYTOOL="keytool"
    print_success "keytool found in PATH"
else
    print_error "keytool is not installed (part of JDK)"
    echo "Install JDK: brew install openjdk"
    echo "Or install Android Studio"
    exit 1
fi

# Step 1: Generate keystore (if not exists)
KEYSTORE_FILE="$PROJECT_DIR/release-keystore.jks"
KEY_PROPERTIES="$PROJECT_DIR/android/key.properties"

print_section "Step 1: Keystore Generation"

if [ -f "$KEYSTORE_FILE" ]; then
    print_warning "Keystore already exists: $KEYSTORE_FILE"
    read -p "Do you want to generate a new one? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_success "Using existing keystore"
    else
        rm "$KEYSTORE_FILE"
        echo "Deleted old keystore"
    fi
fi

if [ ! -f "$KEYSTORE_FILE" ]; then
    echo "Generating new keystore..."
    echo -e "${YELLOW}Please provide the following information:${NC}\n"
    
    $KEYTOOL -genkey -v -keystore "$KEYSTORE_FILE" \
        -keyalg RSA -keysize 2048 -validity 10000 \
        -alias release-key
    
    if [ $? -eq 0 ]; then
        print_success "Keystore generated successfully: $KEYSTORE_FILE"
    else
        print_error "Failed to generate keystore"
        exit 1
    fi
else
    print_success "Keystore exists: $KEYSTORE_FILE"
fi

# Step 2: Create key.properties (if not exists)
print_section "Step 2: Key Properties File"

if [ -f "$KEY_PROPERTIES" ]; then
    print_warning "key.properties already exists"
    read -p "Do you want to recreate it? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm "$KEY_PROPERTIES"
    fi
fi

if [ ! -f "$KEY_PROPERTIES" ]; then
    echo "Creating key.properties..."
    read -sp "Enter keystore password: " STORE_PASSWORD
    echo
    read -sp "Enter key password (press Enter if same as keystore): " KEY_PASSWORD
    echo
    
    if [ -z "$KEY_PASSWORD" ]; then
        KEY_PASSWORD="$STORE_PASSWORD"
    fi
    
    cat > "$KEY_PROPERTIES" << EOF
storePassword=$STORE_PASSWORD
keyPassword=$KEY_PASSWORD
keyAlias=release-key
storeFile=../release-keystore.jks
EOF
    
    print_success "key.properties created"
    print_warning "Keep this file secure and never commit it to version control!"
else
    print_success "key.properties exists"
fi

# Step 3: Clean build
print_section "Step 3: Cleaning Previous Build"
flutter clean
print_success "Clean complete"

# Step 4: Get dependencies
print_section "Step 4: Getting Dependencies"
flutter pub get
print_success "Dependencies updated"

# Step 5: Build release AAB
print_section "Step 5: Building Release AAB"
echo "This may take a few minutes..."

flutter build appbundle --release

if [ $? -eq 0 ]; then
    print_success "Release AAB built successfully!"
    
    AAB_PATH="$PROJECT_DIR/build/app/outputs/bundle/release/app-release.aab"
    AAB_SIZE=$(du -h "$AAB_PATH" | cut -f1)
    
    echo -e "\n${GREEN}================================================${NC}"
    echo -e "${GREEN}  Build Successful!${NC}"
    echo -e "${GREEN}================================================${NC}"
    echo -e "AAB Location: ${BLUE}$AAB_PATH${NC}"
    echo -e "AAB Size: ${BLUE}$AAB_SIZE${NC}"
    echo -e "${GREEN}================================================${NC}\n"
    
    # Optional: Build APK for testing
    read -p "Do you want to build a release APK for testing? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_section "Building Release APK"
        flutter build apk --release
        
        APK_PATH="$PROJECT_DIR/build/app/outputs/flutter-apk/app-release.apk"
        APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
        
        print_success "Release APK built: $APK_PATH ($APK_SIZE)"
    fi
    
else
    print_error "Build failed!"
    exit 1
fi

# Step 6: Next steps
print_section "Next Steps"
echo "1. Test the release APK on a real device:"
echo -e "   ${BLUE}flutter install --release${NC}"
echo ""
echo "2. Test all platforms (especially OlympTrade and PocketOptions)"
echo ""
echo "3. Upload AAB to Google Play Console:"
echo -e "   ${BLUE}$AAB_PATH${NC}"
echo ""
echo "4. Complete store listing with:"
echo "   • App icon: app_icon_512.png"
echo "   • Feature graphic: feature_graphic_1024x500.png"
echo "   • Screenshots (take 4-8 screenshots)"
echo "   • Privacy policy URL"
echo ""
echo "5. Submit for review!"
echo ""
print_warning "IMPORTANT: Keep your keystore and key.properties secure!"
print_warning "You'll need them for all future updates."
echo ""

# Create a backup reminder
print_section "Security Reminder"
echo -e "${RED}⚠️  BACKUP YOUR KEYSTORE! ⚠️${NC}"
echo ""
echo "Create backups of these files in a secure location:"
echo "  • release-keystore.jks"
echo "  • android/key.properties"
echo ""
echo "If you lose these, you won't be able to update your app!"
echo ""

print_success "Release build process complete! 🎉"
