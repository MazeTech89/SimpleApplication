#!/usr/bin/env bash

set -e  # ✅ Stop on error

echo "🚀 Starting deployment..."

# Remove outdated Node.js if present
sudo apt remove -y nodejs npm 2>/dev/null || true

# Add NodeSource repository for Node.js 18 LTS
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -

# Install Node.js 18 LTS
sudo apt update && sudo apt install -y nodejs

# Install PM2 (safe way)
sudo npm install -g pm2

# Stop existing app safely (won’t fail if not running)
pm2 delete simple_app || true

# Ensure app directory exists
if [ ! -d "SimpleApplication" ]; then
  echo "SimpleApplication directory not found!"
  exit 1
fi

# Change directory
cd SimpleApplication/

# Install dependencies
npm install

# Start app with PM2
pm2 start ./bin/www --name simple_app

# Save PM2 process list (auto-restart after reboot)
pm2 save

# Enable PM2 startup
pm2 startup systemd -u ubuntu --hp /home/ubuntu || true

echo "Deployment completed successfully!"