#!/bin/bash
set -e

# Change directory to the root of the project
cd "$(dirname "$0")/.."

echo "🏗️  Starting ShopSmart build process..."

# Build server
echo -e "\n📂 Building server..."
(
    cd server
    echo "📦 Installing server dependencies..."
    npm ci
    # Add server build step here if necessary (e.g. typescript compilation)
)

# Build client
echo -e "\n📂 Building client..."
(
    cd client
    echo "📦 Installing client dependencies..."
    npm ci
    echo "🏗️  Building client UI..."
    npm run build
)

echo -e "\n✅ ShopSmart built successfully! Client output is in client/dist"