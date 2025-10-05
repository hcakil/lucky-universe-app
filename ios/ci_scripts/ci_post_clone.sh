#!/bin/sh

# Xcode Cloud post-clone script for Flutter
# This script runs after Xcode Cloud clones the repository

set -e

echo "🔧 Setting up Flutter environment..."

# Install Flutter if not available
if ! command -v flutter &> /dev/null; then
    echo "📥 Installing Flutter..."
    # Xcode Cloud has Flutter pre-installed, but let's ensure it's available
    export PATH="$PATH:/usr/local/bin"
fi

# Navigate to project root
cd "$CI_WORKSPACE"

echo "📦 Getting Flutter dependencies..."
flutter pub get

echo "🔧 Setting up iOS dependencies..."
cd ios
pod install --repo-update

echo "✅ Flutter environment setup complete!"
