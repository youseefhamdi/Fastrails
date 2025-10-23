#!/bin/bash

# Fastrails Installation Script

set -e

echo "════════════════════════════════════════════════════════"
echo "  Fastrails Installation Script"
echo "════════════════════════════════════════════════════════"
echo ""

# Check if running with sudo
if [ "$EUID" -ne 0 ]; then 
    echo "⚠️  This script needs sudo privileges to install to /usr/local/bin"
    echo "   Run with: sudo ./install.sh"
    exit 1
fi

# Build if binary doesn't exist
if [ ! -f "./fastrails" ]; then
    echo "🔨 Building Fastrails first..."
    su -c "./build.sh" $SUDO_USER
fi

# Install binary
echo "📦 Installing Fastrails to /usr/local/bin..."
cp ./fastrails /usr/local/bin/fastrails
chmod +x /usr/local/bin/fastrails

echo ""
echo "════════════════════════════════════════════════════════"
echo "  ✅ Installation successful!"
echo "════════════════════════════════════════════════════════"
echo ""
echo "You can now run 'fastrails' from anywhere!"
echo ""
echo "Quick start:"
echo "  1. Get your SecurityTrails cookie (see README.md)"
echo "  2. Save cURL command to cookie.txt"
echo "  3. Run: fastrails -d example.com"
echo ""
