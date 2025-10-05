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
    echo "❌ pubspec.yaml not found. Are we in the right directory?"
    exit 1
fi

echo "📦 Setting up iOS dependencies..."
cd ios

# Check if Podfile exists
if [ ! -f "Podfile" ]; then
    echo "❌ Podfile not found in ios directory"
    exit 1
fi

echo "🔧 Running pod install..."
pod install --repo-update

echo "✅ iOS dependencies setup complete!"
