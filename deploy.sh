#!/usr/bin/env bash

set -e

echo "🚀 Starting deployment..."

# Ensure script runs in correct directory
cd "$(dirname "$0")"

# Install dependencies
npm install

# Stop existing app safely
pm2 delete simple_app || true

# Start app with PM2
pm2 start ./bin/www --name simple_app

# Save PM2 process list
pm2 save

# Enable startup (safe to run multiple times)
pm2 startup systemd -u ubuntu --hp /home/ubuntu || true

echo "🎉 Deployment completed successfully!"