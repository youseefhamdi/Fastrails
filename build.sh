#!/bin/bash

# Fastrails Build Script
# This script builds the Fastrails tool with all necessary checks

set -e

echo "════════════════════════════════════════════════════════"
echo "  Fastrails Build Script v0.0.3"
echo "════════════════════════════════════════════════════════"
echo ""

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "❌ Error: Go is not installed"
    echo "   Please install Go 1.21 or higher from https://golang.org/"
    exit 1
fi

# Check Go version
GO_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
echo "✓ Go version: $GO_VERSION"

# Download dependencies
echo ""
echo "📦 Downloading dependencies..."
go mod download

# Verify dependencies
echo "🔍 Verifying dependencies..."
go mod verify

# Build the binary
echo ""
echo "🔨 Building Fastrails..."
go build -o fastrails -ldflags="-s -w" .

if [ $? -eq 0 ]; then
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "  ✅ Build successful!"
    echo "════════════════════════════════════════════════════════"
    echo ""
    echo "Binary created: ./fastrails"
    echo ""

    # Check if binary exists and is executable
    if [ -f "./fastrails" ]; then
        chmod +x ./fastrails
        SIZE=$(ls -lh ./fastrails | awk '{print $5}')
        echo "Binary size: $SIZE"
        echo ""

        # Show version
        echo "Testing binary..."
        ./fastrails --version
        echo ""

        echo "To install globally, run:"
        echo "  sudo mv ./fastrails /usr/local/bin/"
        echo ""
        echo "Or add to PATH:"
        echo "  export PATH=\$PATH:\$(pwd)"
        echo ""
    fi
else
    echo ""
    echo "❌ Build failed!"
    exit 1
fi
