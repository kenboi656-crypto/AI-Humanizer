#!/bin/bash
set -e

echo "🔨 Building AI-Humanizer..."

# Clean previous build
rm -rf dist

# Install dependencies
npm ci --omit=dev

# TypeScript compilation
tsc

# Vite build for frontend
vite build

# Copy server file to output
cp server.js dist/server.js || cp src/server.ts dist/server.js

echo "✅ Build complete!"
echo "📁 Output in: dist/"
echo "🚀 Start with: node dist/server.js"
