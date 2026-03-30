#!/bin/bash
set -e

# Change directory to the root of the project
cd "$(dirname "$0")/.."

echo "🚀 Starting ShopSmart CI check..."

# Run server checks
echo -e "\n📂 Checking server..."
(
    cd server
    echo "📦 Installing server dependencies..."
    npm ci
    echo "🧪 Running tests..."
    npm test
    echo "🧹 Running lint..."
    npm run lint
)

# Run client checks
echo -e "\n📂 Checking client..."
(
    cd client
    echo "📦 Installing client dependencies..."
    npm ci
    echo "🧪 Running tests..."
    npm test
    echo "🧹 Running lint..."
    npm run lint
    echo "🏗️  Building client..."
    npm run build
)

echo -e "\n✅ ShopSmart CI check completed successfully!"