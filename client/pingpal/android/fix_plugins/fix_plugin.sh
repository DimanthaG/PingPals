#!/bin/bash

# Path to the original plugin build.gradle
PLUGIN_PATH="/Users/dimanthagoonewardena/.pub-cache/hosted/pub.dev/flutter_secure_storage-5.1.2/android/build.gradle"

# Back up the original file
cp "$PLUGIN_PATH" "${PLUGIN_PATH}.backup"

# Replace with our fixed version
cp "/Users/dimanthagoonewardena/Desktop/pingpals-client/pingpal/android/fix_plugins/flutter_secure_storage_build.gradle" "$PLUGIN_PATH"

echo "Plugin fixed successfully!" 