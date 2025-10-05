#!/bin/sh

# Xcode Cloud pre-build script for Flutter
# This script runs before Xcode Cloud builds the project

set -e

echo "🚀 Starting Flutter setup for Xcode Cloud..."

# Navigate to project root
cd "$CI_WORKSPACE"

echo "📦 Running flutter pub get..."
flutter pub get

echo "🔧 Setting up iOS dependencies..."
cd ios

echo "📱 Running pod install..."
pod install --repo-update

echo "✅ Flutter setup complete!"
