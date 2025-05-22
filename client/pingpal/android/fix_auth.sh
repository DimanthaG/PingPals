#!/bin/bash

# This script fixes authentication issues in the PingPals app

echo "=========================="
echo "PingPals Auth Fix Script"
echo "=========================="

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APP_DIR="$(dirname "$SCRIPT_DIR")"

echo "App directory: $APP_DIR"

# Try to find Flutter
FLUTTER_PATH=""

# Check common Flutter installation locations
if [ -d "$HOME/flutter/bin" ]; then
  FLUTTER_PATH="$HOME/flutter/bin/flutter"
elif [ -d "$HOME/development/flutter/bin" ]; then
  FLUTTER_PATH="$HOME/development/flutter/bin/flutter"
elif [ -d "/usr/local/flutter/bin" ]; then
  FLUTTER_PATH="/usr/local/flutter/bin/flutter"
elif command -v flutter &> /dev/null; then
  FLUTTER_PATH="flutter"
else
  echo "ERROR: Flutter SDK not found in PATH or common locations."
  echo "Please install Flutter or add it to your PATH and try again."
  echo "For more information, visit: https://flutter.dev/docs/get-started/install"
  exit 1
fi

echo "Using Flutter at: $FLUTTER_PATH"

# Check for google-services.json
if [ -f "$SCRIPT_DIR/app/google-services.json" ]; then
  echo "Found google-services.json"
else
  echo "ERROR: google-services.json not found in $SCRIPT_DIR/app/"
  echo "Please make sure this file is properly configured"
  exit 1
fi

# Check keystore for SHA-1
if [ -f "$HOME/.android/debug.keystore" ]; then
  echo "Displaying debug keystore info:"
  keytool -list -v -keystore "$HOME/.android/debug.keystore" -alias androiddebugkey -storepass android -keypass android | grep "SHA1:"
  echo ""
  echo "Make sure this SHA-1 is registered in your Firebase console!"
else
  echo "Debug keystore not found in default location. Please verify it exists and is registered in Firebase"
fi

# Create local.properties if not exists
if [ ! -f "$SCRIPT_DIR/local.properties" ]; then
  echo "Creating local.properties file"
  echo "flutter.sdk=$HOME/flutter" > "$SCRIPT_DIR/local.properties"
  echo "sdk.dir=$HOME/Library/Android/sdk" >> "$SCRIPT_DIR/local.properties"
  echo "flutter.buildMode=release" >> "$SCRIPT_DIR/local.properties"
fi

# Fix the plugins directory if needed
PLUGINS_DIR="$HOME/.pub-cache/hosted/pub.dev"
if [ -d "$PLUGINS_DIR" ]; then
  echo "Checking plugin configurations..."

  # Fix flutter_secure_storage if needed
  SECURE_STORAGE_PATH="$PLUGINS_DIR/flutter_secure_storage-8.0.0/android/build.gradle"
  if [ -f "$SECURE_STORAGE_PATH" ]; then
    echo "Checking flutter_secure_storage plugin"
    if grep -q "compileSdkVersion" "$SECURE_STORAGE_PATH"; then
      echo "flutter_secure_storage plugin looks good"
    else
      echo "Fixing flutter_secure_storage plugin"
      cp "$APP_DIR/android/fix_plugins/flutter_secure_storage_build.gradle" "$SECURE_STORAGE_PATH"
    fi
  fi
fi

echo ""
echo "Cleaning the project..."
cd "$APP_DIR"
$FLUTTER_PATH clean

echo ""
echo "Getting dependencies..."
$FLUTTER_PATH pub get

echo ""
echo "Building the APK..."
$FLUTTER_PATH build apk --release

if [ $? -eq 0 ]; then
  echo ""
  echo "=============================================="
  echo "Build successful! APK is located at:"
  echo "$APP_DIR/build/app/outputs/flutter-apk/app-release.apk"
  echo "=============================================="
else
  echo ""
  echo "Build failed. Please check the errors above."
fi 