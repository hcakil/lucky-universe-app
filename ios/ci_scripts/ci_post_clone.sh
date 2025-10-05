#!/bin/sh

# Xcode Cloud post-clone script for Flutter
# This script runs after Xcode Cloud clones the repository

set -e

echo "🔧 Setting up project environment..."

# Navigate to project root
cd "$CI_WORKSPACE"

echo "📁 Current directory: $(pwd)"
echo "📁 Contents:"
ls -la

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ pubspec.yaml not found. Trying alternative paths..."
    
    # Try going up one level (from ios to project root)
    cd ..
    echo "📁 Trying parent directory: $(pwd)"
    ls -la
    
    if [ ! -f "pubspec.yaml" ]; then
        echo "❌ pubspec.yaml still not found. Trying one more level up..."
        
        # Try going up one more level
        cd ..
        echo "📁 Trying grandparent directory: $(pwd)"
        ls -la
        
        if [ ! -f "pubspec.yaml" ]; then
            echo "❌ pubspec.yaml still not found. Available files:"
            find . -name "pubspec.yaml" -type f 2>/dev/null || echo "No pubspec.yaml found"
            exit 1
        fi
    fi
fi

echo "✅ Found pubspec.yaml in: $(pwd)"

# First, run flutter pub get to generate required files
echo "📦 Running flutter pub get to generate required files..."
if command -v flutter &> /dev/null; then
    flutter pub get
    echo "✅ Flutter pub get completed"
else
    echo "⚠️ Flutter not available, trying to create Generated.xcconfig manually..."
    
    # Create the Generated.xcconfig file manually
    mkdir -p ios/Flutter
    cat > ios/Flutter/Generated.xcconfig << EOF
// This is a generated file; do not edit or check into version control.
FLUTTER_ROOT=/usr/local/bin/flutter
FLUTTER_APPLICATION_PATH=/Volumes/workspace/repository
FLUTTER_TARGET=lib/main.dart
FLUTTER_BUILD_DIR=build
FLUTTER_BUILD_NAME=1.1.1
FLUTTER_BUILD_NUMBER=6
EXCLUDED_ARCHS[sdk=iphonesimulator*]=i386
DART_OBFUSCATION=false
TRACK_WIDGET_CREATION=true
TREE_SHAKE_ICONS=false
PACKAGE_CONFIG=.dart_tool/package_config.json
EOF
    echo "✅ Created Generated.xcconfig manually"
fi

echo "📦 Setting up iOS dependencies..."
cd ios

# Check if Podfile exists
if [ ! -f "Podfile" ]; then
    echo "❌ Podfile not found in ios directory"
    echo "📁 iOS directory contents:"
    ls -la
    exit 1
fi

echo "🔧 Running pod install..."
pod install --repo-update

echo "✅ iOS dependencies setup complete!"
