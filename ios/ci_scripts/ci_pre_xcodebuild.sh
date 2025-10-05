#!/bin/sh

# Xcode Cloud pre-build script for Flutter
# This script runs before Xcode Cloud builds the project

set -e

echo "🚀 Starting pre-build setup for Xcode Cloud..."

# Navigate to project root
cd "$CI_WORKSPACE"

echo "📁 Current directory: $(pwd)"
echo "📁 Contents:"
ls -la

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ pubspec.yaml not found. Trying alternative paths..."
    
    # Try going up one level
    cd ..
    echo "📁 Trying parent directory: $(pwd)"
    ls -la
    
    if [ ! -f "pubspec.yaml" ]; then
        echo "❌ pubspec.yaml still not found. Available files:"
        find . -name "pubspec.yaml" -type f 2>/dev/null || echo "No pubspec.yaml found"
        exit 1
    fi
fi

echo "✅ Found pubspec.yaml in: $(pwd)"

# Check if Flutter is available
if command -v flutter &> /dev/null; then
    echo "📦 Running flutter pub get..."
    flutter pub get
else
    echo "⚠️ Flutter not available, skipping flutter pub get"
fi

echo "🔧 Setting up iOS dependencies..."
cd ios

echo "📱 Running pod install..."
pod install --repo-update

echo "✅ Pre-build setup complete!"
