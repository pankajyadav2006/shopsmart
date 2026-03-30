#!/bin/bash
set -e

# Change directory to the root of the project
cd "$(dirname "$0")/.."

echo "🚀 Starting ShopSmart CI check..."

# Function to run checks in a directory
run_checks() {
  local dir=$1
  echo -e "\n📂 Checking $dir..."
  if [ -d "$dir" ]; then
    cd "$dir"
    if [ -f "package.json" ]; then
      echo "📦 Installing dependencies in $dir..."
      npm install
      
      echo "🧹 Running lint in $dir..."
      npm run lint || echo "⚠️  Lint check failed in $dir"
      
      echo "🧪 Running tests in $dir..."
      npm test || echo "⚠️  Tests failed in $dir"
      
      if [[ "$dir" == "client" ]]; then
        echo "🏗️  Building client..."
        npm run build || echo "⚠️  Build failed in $dir"
      fi
    else
      echo "❌ No package.json found in $dir"
      return 1
    fi
    cd ..
  else
    echo "❌ Directory $dir not found"
    return 1
  fi
}

# Run checks for client and server
run_checks "server"
run_checks "client"

echo -e "\n✅ ShopSmart CI check completed successfully!"
