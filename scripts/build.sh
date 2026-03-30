#!/bin/bash
set -e

# Change directory to the root of the project
cd "$(dirname "$0")/.."

echo "🏗️  Starting ShopSmart Build Process..."

# Build server dependencies
echo -e "\n📦 Building server..."
cd server
npm install
cd ..

# Build client
echo -e "\n📦 Building client..."
cd client
npm install
npm run build
cd ..

echo -e "\n✅ ShopSmart built successfully! Output is in client/dist"
