#!/bin/bash

# OpenShelf Flutter App - Quick Start Guide
# This script helps you get started with the OpenShelf Flutter application

echo "=========================================="
echo "OpenShelf Flutter App - Quick Start"
echo "=========================================="
echo ""

# Check Flutter installation
echo "1. Checking Flutter installation..."
flutter --version
echo ""

# Navigate to project directory
echo "2. Installing dependencies..."
cd openshelf_app || exit
flutter pub get
echo ""

# Analyze code
echo "3. Analyzing code..."
flutter analyze
echo ""

# Run the app
echo "4. Running the app..."
echo "   The app will launch on your default device/emulator"
echo "   Available commands during execution:"
echo "   - Press 'r' for hot reload"
echo "   - Press 'R' for hot restart"
echo "   - Press 'q' to quit"
echo ""

flutter run

echo ""
echo "=========================================="
echo "Setup complete! Happy coding!"
echo "=========================================="
