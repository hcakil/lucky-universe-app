#!/bin/sh

# Xcode Cloud post-clone script for Flutter
# This script runs after Xcode Cloud clones the repository

set -e

echo "🔧 Setting up project environment..."

# Navigate to project root (go up two levels from ci_scripts)
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
